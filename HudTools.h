//
//  Tools.h
//  shike
//
//  Copyright (c) 2014年 shixun. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: 这个类可以多加几个分类 以免方法太多.

@interface HudTools : NSObject

+ (void)dismiss;
+ (void)showStatusWithString:(NSString *)string;
+ (void)showErrorWithString:(NSString *)string;
+ (void)showSuccessWithString:(NSString *)string;


@end
