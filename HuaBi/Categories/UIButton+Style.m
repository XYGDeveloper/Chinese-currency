//
//  UIButton+Style.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UIButton+Style.h"

@implementation UIButton (Style)

- (void)_setupStyle {
    [self setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#37415C")] forState:UIControlStateDisabled];
    [self setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateDisabled];
    
    [self setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#4173C8")] forState:UIControlStateNormal];
    [self setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateNormal];
}

@end
