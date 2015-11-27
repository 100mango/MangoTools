//
//  NSAttributedString+Attributes.m
//  A category for NSAttributedString and NSMutableAttributedString to easily get or set sub-attributes.
//
//  Created by Shilo White on 9/22/13.
//  Copyright (c) 2013 XIDA Design & Technik. All rights reserved.
//

#import "NSAttributedString+Attributes.h"
#import <CoreText/CoreText.h>

#define DEFAULT_FONT_NAME  @"Helvetica"
#define DEFAULT_FONT_SIZE  12.0f
#define RANGE NSMakeRange(0, self.length)

@interface UIFont (Attributes)

+ (UIFont *)fontWithFont:(UIFont *)font size:(CGFloat)pointSize;
+ (UIFont *)fontWithFont:(UIFont *)font name:(NSString *)fontName;
+ (UIFont *)fontWithFont:(UIFont *)font bold:(BOOL)bold;
+ (UIFont *)fontWithFont:(UIFont *)font italic:(BOOL)italic;

@property (nonatomic, readonly) BOOL bold;
@property (nonatomic, readonly) BOOL italic;

@end

@implementation NSAttributedString (Attributes)

- (UIFont *)defaultFont
{
    return [UIFont fontWithName:DEFAULT_FONT_NAME size:DEFAULT_FONT_SIZE];
}

- (UIFont *)fontAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    return [self fontAtIndex:index longestEffectiveRange:range inRange:RANGE];
}

- (NSString *)fontNameAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    return [self fontNameAtIndex:index longestEffectiveRange:range inRange:RANGE];
}

- (CGFloat)fontSizeAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    return [self fontSizeAtIndex:index longestEffectiveRange:range inRange:RANGE];
}

- (BOOL)boldAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    return [self boldAtIndex:index longestEffectiveRange:range inRange:RANGE];
}

- (BOOL)italicAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range
{
    return [self italicAtIndex:index longestEffectiveRange:range inRange:RANGE];
}

- (UIFont *)fontAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit
{
    UIFont *font = [self attribute:NSFontAttributeName atIndex:index longestEffectiveRange:range inRange:rangeLimit];
    return font ? font : self.defaultFont;
}

- (NSString *)fontNameAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit
{
    NSString *fontName = [self fontAtIndex:index longestEffectiveRange:range inRange:rangeLimit].fontName;
    
    while (NSMaxRange(*range) < NSMaxRange(rangeLimit))
    {
        NSRange nextRange;
        NSString *nextFontName = [self fontAtIndex:NSMaxRange(*range) longestEffectiveRange:&nextRange inRange:rangeLimit].fontName;
        if (![fontName isEqualToString:nextFontName]) break;
        (*range).length += nextRange.length;
    }
    
    return fontName;
}

- (CGFloat)fontSizeAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit
{
    CGFloat fontSize = [self fontAtIndex:index longestEffectiveRange:range inRange:rangeLimit].pointSize;
    
    while (NSMaxRange(*range) < NSMaxRange(rangeLimit))
    {
        NSRange nextRange;
        CGFloat nextFontSize = [self fontAtIndex:NSMaxRange(*range) longestEffectiveRange:&nextRange inRange:rangeLimit].pointSize;
        if (fontSize != nextFontSize) break;
        (*range).length += nextRange.length;
    }
    
    return fontSize;
}

- (BOOL)boldAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit
{
    BOOL bold = [self fontAtIndex:index longestEffectiveRange:range inRange:rangeLimit].bold;
    
    while (NSMaxRange(*range) < NSMaxRange(rangeLimit))
    {
        NSRange nextRange;
        CGFloat nextBold = [self fontAtIndex:NSMaxRange(*range) longestEffectiveRange:&nextRange inRange:rangeLimit].bold;
        if (bold != nextBold) break;
        (*range).length += nextRange.length;
    }
    
    return bold;
}

- (BOOL)italicAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit
{
    BOOL italic = [self fontAtIndex:index longestEffectiveRange:range inRange:rangeLimit].italic;
    
    while (NSMaxRange(*range) < NSMaxRange(rangeLimit))
    {
        NSRange nextRange;
        CGFloat nextItalic = [self fontAtIndex:NSMaxRange(*range) longestEffectiveRange:&nextRange inRange:rangeLimit].italic;
        if (italic != nextItalic) break;
        (*range).length += nextRange.length;
    }
    
    return italic;
}

@end

@implementation NSMutableAttributedString (Attributes)

- (void)addFont:(UIFont *)font range:(NSRange)range
{
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)addFontName:(NSString *)fontName range:(NSRange)rangeLimit
{
    fontName = [UIFont fontWithName:fontName size:[UIFont systemFontSize]].fontName;
    if (!fontName) return;
    
    NSRange range = NSMakeRange(rangeLimit.location, rangeLimit.length);
    UIFont *font = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
    
    if (![fontName isEqualToString:font.fontName])
        [self addFont:[UIFont fontWithFont:font name:fontName] range:range];
    
    while (NSMaxRange(range) < NSMaxRange(rangeLimit))
    {
        range.location = NSMaxRange(range);
        range.length = rangeLimit.length - range.location;
        
        UIFont *nextFont = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
        if (![fontName isEqualToString:nextFont.fontName])
            [self addFont:[UIFont fontWithFont:nextFont name:fontName] range:range];
    }
}

- (void)addFontSize:(CGFloat)fontSize range:(NSRange)rangeLimit
{
    if (!fontSize) return;
    
    NSRange range = NSMakeRange(rangeLimit.location, rangeLimit.length);
    UIFont *font = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
    
    if (fontSize != font.pointSize)
        [self addFont:[UIFont fontWithFont:font size:fontSize] range:range];
    
    while (NSMaxRange(range) < NSMaxRange(rangeLimit))
    {
        range.location = NSMaxRange(range);
        range.length = rangeLimit.length - range.location;
        
        UIFont *nextFont = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
        if (fontSize != nextFont.pointSize)
            [self addFont:[UIFont fontWithFont:nextFont size:fontSize] range:range];
    }
}

- (void)addBold:(BOOL)bold range:(NSRange)rangeLimit
{
    NSRange range = NSMakeRange(rangeLimit.location, rangeLimit.length);
    UIFont *font = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
    
    if (bold != font.bold)
        [self addFont:[UIFont fontWithFont:font bold:bold] range:range];
    
    while (NSMaxRange(range) < NSMaxRange(rangeLimit))
    {
        range.location = NSMaxRange(range);
        range.length = rangeLimit.length - range.location;
        
        UIFont *nextFont = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
        if (bold != nextFont.bold)
            [self addFont:[UIFont fontWithFont:nextFont bold:bold] range:range];
    }
}

- (void)addItalic:(BOOL)italic range:(NSRange)rangeLimit
{
    NSRange range = NSMakeRange(rangeLimit.location, rangeLimit.length);
    UIFont *font = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
    
    if (italic != font.italic)
        [self addFont:[UIFont fontWithFont:font italic:bold] range:range];
    
    while (NSMaxRange(range) < NSMaxRange(rangeLimit))
    {
        range.location = NSMaxRange(range);
        range.length = rangeLimit.length - range.location;
        
        UIFont *nextFont = [self fontAtIndex:range.location longestEffectiveRange:&range inRange:rangeLimit];
        if (italic != nextFont.italic)
            [self addFont:[UIFont fontWithFont:nextFont italic:bold] range:range];
    }
}

@end

@implementation UIFont (Attributes)

+ (UIFont *)fontWithFont:(UIFont *)font size:(CGFloat)pointSize
{
    return [self fontWithDescriptor:font.fontDescriptor size:pointSize];
}

+ (UIFont *)fontWithFont:(UIFont *)font name:(NSString *)fontName
{
    //check if CTFontDescriptorRef and CTFontRef are leaking
    CTFontDescriptorRef attributes = CTFontDescriptorCreateWithNameAndSize((__bridge CFStringRef)fontName, 0.0f);
    return (__bridge UIFont *)CTFontCreateCopyWithAttributes((__bridge CTFontRef)font, 0.0f, NULL, attributes);
}

+ (UIFont *)fontWithFont:(UIFont *)font bold:(BOOL)bold
{
    //check if CTFontRef is leaking
    return (__bridge UIFont *)CTFontCreateCopyWithSymbolicTraits((__bridge CTFontRef)font, 0.0f, NULL, (bold?kCTFontBoldTrait:0), kCTFontBoldTrait);
}

+ (UIFont *)fontWithFont:(UIFont *)font italic:(BOOL)italic
{
    //check if CTFontRef is leaking
    return (__bridge UIFont *)CTFontCreateCopyWithSymbolicTraits((__bridge CTFontRef)font, 0.0f, NULL, (italic?kCTFontItalicTrait:0), kCTFontItalicTrait);
}

- (BOOL)bold
{
    return (CTFontGetSymbolicTraits((__bridge CTFontRef)self) & kCTFontBoldTrait) != 0;
}

- (BOOL)italic
{
    return (CTFontGetSymbolicTraits((__bridge CTFontRef)self) & kCTFontItalicTrait) != 0;
}

@end
