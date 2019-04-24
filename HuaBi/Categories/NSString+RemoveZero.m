//
//  NSString+RemoveZero.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "NSString+RemoveZero.h"

@implementation NSString (RemoveZero)

- (NSString *)_removeZeroOfDoubleString {
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
    return [NSString stringWithFormat:@"%@", number];
    return self;
}

@end
