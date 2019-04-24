//
//  YWHorizontalLineView.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWHorizontalLineView.h"

@implementation YWHorizontalLineView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.lineColor setStroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextMoveToPoint(context, 0., self.lineWidth / 2.);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), self.lineWidth / 2.);
    CGContextStrokePath(context);
}

#pragma mark - Private

- (void)_commonInit {
    _lineColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    _lineWidth = 1. / [UIScreen mainScreen].scale;
}

#pragma mark - Setters

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    [self setNeedsDisplay];
}

@end
