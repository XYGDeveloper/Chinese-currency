//
//  UILabel+ZY.m
//  jianpan
//
//  Created by 周勇 on 2017/8/22.
//  Copyright © 2017年 周勇. All rights reserved.
//

#import "UILabel+ZY.h"

@implementation UILabel (ZY)

- (UILabel *)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSInteger)textAlignment adjustsFont:(BOOL)isAdjust
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.adjustsFontSizeToFitWidth = isAdjust;
    return label;
}

- (UILabel *)initWithFrame:(CGRect)frame Atttext:(NSAttributedString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSInteger)textAlignment adjustsFont:(BOOL)isAdjust
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.attributedText = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.adjustsFontSizeToFitWidth = isAdjust;
    return label;
}


@end
