//
//  NTESVerifyCodeManager+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "NTESVerifyCodeManager+HB.h"

@implementation NTESVerifyCodeManager (HB)

+ (instancetype)getHBManager {
    
    NTESVerifyCodeManager *manager = [NTESVerifyCodeManager sharedInstance];
    manager.alpha = 0;
    manager.frame = CGRectNull;
    [manager configureVerifyCode:kVerifyKey timeout:7];
    
    return manager;
}

@end
