//
//  NSString+Tools.h
//  Trans
//
//  Created by Mango on 15/2/2.
//  Copyright (c) 2015年 Mango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

- (BOOL)isMobileNumber:(NSString *)mobileNum;

//只检查车牌号 （不包括缩写与英文代号：例如：京A)
- (BOOL)isCarNumber;

//构造URL,如果没有http前缀,则添加
+(NSURL *)HTTPURLFromString:(NSString *)string;

//返回构造好的时间字符串  60s-> 00:00:60
+ (NSString *)timeStringFromSeconds:(int)totalSeconds;
@end
