//
//  UIButton+LSSmsVerification.h
//  短信验证码
//
//  Created by yepiaoyang on 16/6/30.
//  Copyright © 2016年 yepiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LSSmsVerification)

- (void)startTimeWithDuration:(NSInteger)duration backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColo;
- (void)startTimeWithDuration1:(NSInteger)duration1 backgroundColor1:(UIColor *)backgroundColor1 titleColor1:(UIColor *)titleColo1;
/**
 *  获取短信验证码倒计时
 *
 *  @param duration 倒计时时间
 */
- (void)startTimeWithDuration:(NSInteger)duration;
- (void)startTimeWithDuration1:(NSInteger)duration1;

@end
