//
//  UITextField+ChangeClearButton.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UITextField+ChangeClearButton.h"

@implementation UITextField (ChangeClearButton)

- (void)_changeClearButton {
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"qx_icon"] forState:UIControlStateNormal];
}

@end
