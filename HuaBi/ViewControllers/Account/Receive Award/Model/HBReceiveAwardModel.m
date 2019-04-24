//
//  HBReceiveAwardModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReceiveAwardModel.h"

@implementation HBReceiveAwardModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             };
}

- (BOOL)canReceive {
    return [self.status isEqualToString:@"0"];
}

@end
