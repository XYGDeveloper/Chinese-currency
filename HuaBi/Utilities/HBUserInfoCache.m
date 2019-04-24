//
//  HBUserInfoCache.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBUserInfoCache.h"

@implementation HBUserInfoCache

+ (instancetype)sharedInstance {
    
    static HBUserInfoCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HBUserInfoCache new];
    });
    
    return sharedInstance;
}

@end
