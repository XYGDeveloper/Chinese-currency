//
//  NSMutableDictionary+safe.m
//  Zhuzhu
//
//  Created by zagger on 15/12/15.
//  Copyright © 2015年 www.globex.cn. All rights reserved.
//

#import "NSMutableDictionary+safe.h"

@implementation NSMutableDictionary (safe)

+ (instancetype)safeWithDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    return [self dictionaryWithDictionary:dic];
}

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && ![aObj isKindOfClass:[NSNull class]] && aKey) {
        [self setObject:aObj forKey:aKey];
    } else {
        return;
    }
}

- (id)safeObjectForKey:(id<NSCopying>)aKey
{
    if (aKey != nil) {
        return [self objectForKey:aKey];
    } else {
        return nil;
    }
}

- (void)safeRemoveObjectForKey:(id<NSCopying>)aKey {
    if (aKey) {
        return [self removeObjectForKey:aKey];
    }
}

@end
