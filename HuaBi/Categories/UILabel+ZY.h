//
//  UILabel+ZY.h
//  jianpan
//
//  Created by 周勇 on 2017/8/22.
//  Copyright © 2017年 周勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZY)

- (UILabel *)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSInteger)textAlignment adjustsFont:(BOOL)isAdjust;
- (UILabel *)initWithFrame:(CGRect)frame Atttext:(NSAttributedString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSInteger)textAlignment adjustsFont:(BOOL)isAdjust;

@end
