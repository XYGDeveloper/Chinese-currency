//
//  UIButton+LSSmsVerification.m
//  短信验证码
//
//  Created by yepiaoyang on 16/6/30.
//  Copyright © 2016年 yepiaoyang. All rights reserved.
//

#import "UIButton+LSSmsVerification.h"

@implementation UIButton (LSSmsVerification)

/**
 *  获取短信验证码倒计时
 *
 *  @param duration 倒计时时间
 */

- (void)startTimeWithDuration:(NSInteger)duration backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor {
    __block NSInteger timeout = duration;
    
    NSString *originalTitle = [self titleForState:UIControlStateNormal];
    UIColor *originalTitleColor = [self titleColorForState:UIControlStateNormal];
    UIFont *originalFont = self.titleLabel.font;
    UIColor *originalBGColor = self.backgroundColor;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer_t,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer_t, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer_t);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮为最初的状态
                [self setTitle:originalTitle forState:UIControlStateNormal];
                [self setTitleColor:originalTitleColor forState:UIControlStateNormal];
                self.titleLabel.font = originalFont;
                self.userInteractionEnabled = YES;
                self.layer.borderColor = originalTitleColor.CGColor;
                self.backgroundColor = originalBGColor;
            });
        }else{
            NSInteger seconds = timeout % duration;
            if(seconds == 0){
                seconds = duration;
            }
            NSString *strTime = [NSString stringWithFormat:@"%ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{//根据自己需求设置倒计时显示
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                if (titleColor) {
                    [self setTitleColor:titleColor forState:UIControlStateNormal];
                }
                
                //                self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                //                self.layer.borderColor = kColorFromStr(@"#999999").CGColor;
                self.backgroundColor = backgroundColor ?: kColorFromStr(@"#999999");
                [UIView commitAnimations];
                
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer_t);
}

- (void)startTimeWithDuration1:(NSInteger)duration1 backgroundColor1:(UIColor *)backgroundColor1 titleColor1:(UIColor *)titleColor1 {
    __block NSInteger timeout = duration1;
    
    NSString *originalTitle = [self titleForState:UIControlStateNormal];
    UIColor *originalTitleColor = [self titleColorForState:UIControlStateNormal];
    UIFont *originalFont = self.titleLabel.font;
    UIColor *originalBGColor = self.backgroundColor;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer_t,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer_t, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer_t);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮为最初的状态
                [self setTitle:originalTitle forState:UIControlStateNormal];
                [self setTitleColor:originalTitleColor forState:UIControlStateNormal];
                self.titleLabel.font = originalFont;
                self.userInteractionEnabled = YES;
                self.layer.borderColor = originalTitleColor.CGColor;
                self.backgroundColor = originalBGColor;
            });
        }else{
            NSInteger seconds = timeout % duration1;
            if(seconds == 0){
                seconds = duration1;
            }
            NSString *strTime = [NSString stringWithFormat:@"%ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{//根据自己需求设置倒计时显示
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self setTitle:[NSString stringWithFormat:@"%@秒后重新發送",strTime] forState:UIControlStateNormal];
                if (titleColor1) {
                    [self setTitleColor:titleColor1 forState:UIControlStateNormal];
                }
            
                self.backgroundColor = backgroundColor1 ?: kColorFromStr(@"#999999");
                [UIView commitAnimations];
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer_t);
}

- (void)startTimeWithDuration:(NSInteger)duration
{
    
    [self startTimeWithDuration:duration backgroundColor:nil titleColor:nil];
}


- (void)startTimeWithDuration1:(NSInteger)duration
{
    
    [self startTimeWithDuration1:duration backgroundColor1:[UIColor whiteColor] titleColor1:kColorFromStr(@"#333333")];
}

@end
