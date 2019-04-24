//
//  NSString+toCNY.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/4.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "NSString+toCNY.h"

@implementation NSString (toCNY)

- (NSString *)_addCNY {
    return [NSString stringWithFormat:@"%@ CNY", self ?: @"--"];
}

@end
