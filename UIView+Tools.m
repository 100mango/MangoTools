//
//  UIView+Tools.m
//  shike
//
//  Created by Mango on 14/12/12.
//  Copyright (c) 2014年 shixun. All rights reserved.
//

#import "UIView+Tools.h"
#import <objc/runtime.h>
static const void *BGTouchEndedViewBlockKey = &BGTouchEndedViewBlockKey;
static const void *BGTouchLongPressEndedViewBlockKey = &BGTouchLongPressEndedViewBlockKey;


@implementation UIView (Tools)

- (void)ClipSquareViewToRound
{
    if (self.frame.size.width == self.frame.size.height)
    {
        self.layer.cornerRadius = self.frame.size.width/2;
    }
}

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

#pragma mark -animation
- (void)rotateViewWithAngle:(CGFloat)angle andDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
    }];
}

#pragma mark -handel action
- (void)touchEndedBlock:(void (^)(UIView *selfView))block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(touchEndedGesture)];
    tapped.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapped];
    objc_setAssociatedObject(self, BGTouchEndedViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)touchEndedGesture
{
    void(^_touchBlock)(UIView *selfView) = objc_getAssociatedObject(self, BGTouchEndedViewBlockKey);
    if (_touchBlock) {
        _touchBlock(self);
    }
}

-(void)longPressEndedBlock:(void (^)(UIView *selfView))block
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEndedGesture:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
    objc_setAssociatedObject(self, BGTouchLongPressEndedViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)longPressEndedGesture:(UIGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^_touchBlock)(UIView *selfView) = objc_getAssociatedObject(self, BGTouchLongPressEndedViewBlockKey);
        if (_touchBlock) {
            _touchBlock(self);
        }
    }
}


@end
