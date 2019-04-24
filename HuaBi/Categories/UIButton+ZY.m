//
//  UIButton+ZY.m
//  jianpan
//
//  Created by 周勇 on 2017/8/22.
//  Copyright © 2017年 周勇. All rights reserved.
//

#import "UIButton+ZY.h"

@implementation UIButton (ZY)

- (UIButton *)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font titleAlignment:(NSInteger)textAlignment
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    /**
     UIControlContentHorizontalAlignmentCenter = 0,
     UIControlContentHorizontalAlignmentLeft   = 1,
     UIControlContentHorizontalAlignmentRight  = 2,
     UIControlContentHorizontalAlignmentFill   = 3,
     */
    //button.contentHorizontalAlignment =

    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}
@end
