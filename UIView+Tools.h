//
//  UIView+Tools.h
//  shike
//
//  Created by Mango on 14/12/12.
//  Copyright (c) 2014年 shixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

//将正方形的View裁剪为圆形
- (void)ClipSquareViewToRound;

//添加边框
- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

//anmation helper
/**
 *  旋转view
 *  @param angle 弧度：PI = 360度
 */
- (void)rotateViewWithAngle:(CGFloat)angle;


//封装gestureRecognizer到UIView中，用的时候直接把需触发的block传入即可
- (void)touchEndedBlock:(void(^)(UIView *selfView))block;

- (void)touchEndedGesture;

- (void)longPressEndedBlock:(void(^)(UIView *selfView))block;

- (void)longPressEndedGesture:(UIGestureRecognizer*)gesture;
@end
