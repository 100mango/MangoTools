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

+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // Draw your image
    [original drawInRect:frame];
    
    // Get the image, here setting the UIImageView image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
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

- (UIImage *)renderWithBounds:(CGRect)frame {
    
    CGSize imageSize = frame.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(c, CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y));
    [self.layer renderInContext:c];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
    
}

- (void)setAnchorPointAndRemainOrigin:(CGPoint)anchorPoint;
{
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}


#pragma mark -animation
- (void)rotateViewWithAngle:(CGFloat)angle andDuration:(CGFloat)duration
{
    
    [UIView animateWithDuration:duration animations:^{
        CGAffineTransform oldTransForm = self.transform;
        self.transform = CGAffineTransformRotate(oldTransForm, angle);
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


#pragma mark - UIImage
@implementation UIImage (Tools)
- (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    [self drawInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
    [inputImage drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
