//
//  NSTimer+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "NSTimer+HB.h"

@implementation NSTimer (HB)

+ (instancetype)_createRandomTimerWithTarget:(id)target selector:(SEL)sel {
    NSInteger randomSec = arc4random_uniform(5) + 1;
    return [NSTimer scheduledTimerWithTimeInterval:randomSec target:target selector:sel userInfo:nil repeats:NO];
}

@end
