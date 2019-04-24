//
//  NSMutableDictionary+safe.h
//  Zhuzhu
//
//  Created by zagger on 15/12/15.
//  Copyright © 2015年 www.globex.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (safe)

+ (instancetype)safeWithDictionary:(NSDictionary *)dic;

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey;

- (id)safeObjectForKey:(id<NSCopying>)aKey;

/** 移除aKey */
- (void)safeRemoveObjectForKey:(id<NSCopying>)aKey;

@end
