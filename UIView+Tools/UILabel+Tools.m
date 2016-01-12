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

- (void)adjustFontSizeToFitBounds
{
    //从最大字号放缩到最小字号
    int fontSize = 14;
    int minFontSize = 1;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
    CGSize textSize;
    
    do {
        self.font = [UIFont fontWithName:self.font.fontName size:fontSize];
        
        //获得当前字号所需的label大小
        textSize = [self sizeThatFits:constraintSize];
        // 如果估算label大小小于实际Label的大小,则找到,否则缩小字号继续寻找
        if( textSize.height <= self.frame.size.height){
            break;
        }
        
        fontSize -= 1;
        
    } while (fontSize > minFontSize);
    
    //如果只有一行 则居中
    if (floor((textSize.height / self.font.lineHeight)) == 1) {
        self.textAlignment = NSTextAlignmentCenter;
    }else{
        self.textAlignment = NSTextAlignmentLeft;
    }
    
}
@end
