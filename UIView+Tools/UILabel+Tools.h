//
//  UILabel+Tools.h
//
//  Created by Mango on 15/12/4.
//  Copyright © 2015年 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Tools)

- (void)setText:(NSString *)text highlightKeyWord:(NSArray *)keywords highlightColor:(UIColor*)color;
- (void)adjustFontSizeToFitBounds;

@end
