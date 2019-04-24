//
//  ZYForbiddenTextField.m
//  YJOTC
//
//  Created by 周勇 on 2018/5/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ZYForbiddenTextField.h"

@implementation ZYForbiddenTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    // 禁用粘贴功能
//    if (action == @selector(paste:))
//        return NO;
//
//    // 禁用选择功能
//    if (action == @selector(select:))
//        return NO;
//
//    // 禁用全选功能
//    if (action == @selector(selectAll:))
//        return NO;
//
//    return [super canPerformAction:action withSender:sender];
//}

@end
