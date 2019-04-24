//
//  HBDateProgressView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBDateProgressView.h"

@interface HBDateProgressView ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation HBDateProgressView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressLayer.path = [self bezierPath].CGPath;
}

#pragma mark - Private

- (UIBezierPath *)bezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 3.5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), 3.5)];
    
//    [path closePath];
    return path;
}

- (void)_commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = kColorFromStr(@"#4173C8");
    
    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.borderWidth = 1.;
    self.layer.cornerRadius = 3.5;
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = self.tintColor.CGColor;
    self.progressLayer.lineWidth = 7.;
    self.progressLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:self.progressLayer];
}

#pragma mark - Setters

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(0, MIN(1., progress));
    self.progressLayer.strokeEnd =  progress;
}

@end
