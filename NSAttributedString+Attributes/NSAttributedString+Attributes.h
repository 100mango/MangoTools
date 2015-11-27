//
//  NSAttributedString+Attributes.h
//  A category for NSAttributedString and NSMutableAttributedString to easily get or set sub-attributes.
//
//  Created by Shilo White on 9/22/13.
//  Copyright (c) 2013 XIDA Design & Technik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Attributes)

@property (nonatomic, readonly) UIFont *defaultFont;

- (UIFont *)fontAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range;
- (NSString *)fontNameAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range;
- (CGFloat)fontSizeAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range;
- (BOOL)boldAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range;
- (BOOL)italicAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)range;

- (UIFont *)fontAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit;
- (NSString *)fontNameAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit;
- (CGFloat)fontSizeAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit;
- (BOOL)boldAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit;
- (BOOL)italicAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)range inRange:(NSRange)rangeLimit;

@end


@interface NSMutableAttributedString (Attributes)

- (void)addFont:(UIFont *)font range:(NSRange)range;
- (void)addFontName:(NSString *)fontName range:(NSRange)range;
- (void)addFontSize:(CGFloat)fontSize range:(NSRange)range;
- (void)addBold:(BOOL)bold range:(NSRange)range;
- (void)addItalic:(BOOL)italic range:(NSRange)range;

@end
