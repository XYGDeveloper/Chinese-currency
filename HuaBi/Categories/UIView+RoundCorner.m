//
//  UIView+RoundedCorner.m
//  xfj
//
//  Created by ZhangJing on 16/10/9.
//  Copyright © 2016年 xlbyun. All rights reserved.
//

#import "UIView+RoundCorner.h"
#import <objc/runtime.h>


@implementation UIView (RoundCorner)

- (void)roundWithRadius:(CGFloat)radius {
    [self roundCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight radius:radius borderColor:nil];
}

- (void)roundTopCornersRadius:(CGFloat)radius {
    [self roundTopCornersRadius:radius borderColor:nil];
}

- (void)roundBottomCornersRadius:(CGFloat)radius {
    [self roundBottomCornersRadius:radius borderColor:nil];
}

- (void)roundTopCornersRadius:(CGFloat)radius
                  borderColor:(UIColor *)color {
    [self roundCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:radius borderColor:color];
}

- (void)roundBottomCornersRadius:(CGFloat)radius
                     borderColor:(UIColor *)color {
    [self roundCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:radius borderColor:color];
}

- (void)roundRightCornersRadius:(CGFloat)radius {
    [self roundCorners:UIRectCornerBottomRight | UIRectCornerTopRight radius:radius borderColor:nil];
}

- (void)roundLeftCornersRadius:(CGFloat)radius {
    [self roundCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft radius:radius borderColor:nil];
}

- (void)roundCorners:(UIRectCorner)corners
              radius:(CGFloat)radius {
    [self roundCorners:corners radius:radius borderColor:nil];
    
}

- (void)roundCorners:(UIRectCorner)corners
              radius:(CGFloat)radius
         borderColor:(UIColor *)color {
    CGRect bounds = self.bounds;
    
    if (self.layer.mask) {
        if (!CGRectEqualToRect(self.layer.mask.bounds, bounds)) {
            
            if ([self.layer.mask isKindOfClass:[CAShapeLayer class]]) {
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
                self.layer.mask.bounds = bounds;
                CAShapeLayer *shapeLayer = self.layer.mask;
                shapeLayer.path = path.CGPath;
            }

        }
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = bounds;
    mask.path = path.CGPath;
    self.layer.mask = mask;
    
//    CAShapeLayer *frameLayer = [CAShapeLayer new];
//    frameLayer.frame = bounds;
//    frameLayer.path = path.CGPath;
//    frameLayer.strokeColor = color.CGColor;
//    frameLayer.fillColor = nil;
//
//    [self.layer addSublayer:frameLayer];
}




@end
