//
//  UITextField+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UITextField+HB.h"

@implementation UITextField (HB)

- (void)_animateWithText:(NSString *)text {
    self.text = text;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    animation.keyTimes = @[@(0), @(0.2), @(1)];
    
    [self.layer addAnimation:animation forKey:nil];
}

@end
