//
//  NSUserDefaults+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/13.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "NSUserDefaults+HB.h"

static NSString *const kServerTimeKey =  @"kServerTimeKey";

@implementation NSUserDefaults (HB)

+ (void)cleanExpiredData {
    [self setServerTime:nil];
}

+ (void)setServerTime:(NSString *)serverTime {
    if (!serverTime) {
        [kUserDefaults setObject:nil forKey:kServerTimeKey];
        return;
    }
    long long time =  [serverTime longLongValue] - [NSDate new].timeIntervalSince1970;
    [kUserDefaults setObject:@(time) forKey:kServerTimeKey];
}

+ (NSString *)getServerTime {
    id timeData = [kUserDefaults objectForKey:kServerTimeKey];
    if (!timeData) {
        return nil;
    }
    long long  time = [timeData longLongValue] + [NSDate new].timeIntervalSince1970;
    return [NSString stringWithFormat:@"%lld",time];
}

@end
