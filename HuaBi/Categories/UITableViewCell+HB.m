//
//  UITableViewCell+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UITableViewCell+HB.h"

@implementation UITableViewCell (HB)


- (void)_addSelectedBackgroundView {
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"HBSelectedBackgroundView" owner:nil options:nil].firstObject;
    self.selectedBackgroundView = view;
}

@end
