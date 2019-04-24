//
//  HBHomeIndexModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeIndexModel.h"

#pragma mark - flash -

@implementation Flash

@end

#pragma mark - notice -

@implementation Notice

@end

#pragma mark - zixun -

@implementation Zixun

@end

@implementation HBHomeIndexModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"flash" : @"Flash",
//             @"notice" : @"Notice",
             @"zixun" : @"Zixun",
             };
}

@end
