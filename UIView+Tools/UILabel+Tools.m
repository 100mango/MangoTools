//
//  UILabel+Tools.m
//
//  Created by Mango on 15/12/4.
//  Copyright © 2015年 Mango. All rights reserved.
//

#import "UILabel+Tools.h"

@implementation UILabel (Tools)

- (void)setText:(NSString *)text highlightKeyWord:(NSArray *)keywords highlightColor:(UIColor*)color{
    
    if (text.length > 0) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    if ((text.length <= 0) || (keywords.count <= 0)) {
        self.attributedText = nil;
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *keyword in keywords) {
        BOOL endString = NO;
        NSUInteger pos = 0;
        NSString *tempStr = text;
        NSUInteger tempPos = 0;
        do {
            NSRange boldRange = [tempStr rangeOfString:keyword options:NSCaseInsensitiveSearch];
            if (boldRange.length > 0) {
                [attributeStr addAttribute:(NSString *)NSForegroundColorAttributeName value:color range:NSMakeRange(tempPos + boldRange.location, boldRange.length)];
                
                pos = boldRange.location + boldRange.length;
                tempPos += pos;
                tempStr = [tempStr substringFromIndex:pos];
            } else {
                endString = YES;
            }
        } while (!endString && tempPos < text.length);
        
    }
    self.text = nil;
    self.attributedText = attributeStr;
}
@end
