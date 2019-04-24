//
//  NSDictionary+safe.h
//  Zhuzhu
//
//  Created by zagger on 15/12/15.
//  Copyright © 2015年 www.globex.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safe)

+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key;

/** 安全返回id */
- (id)safeObjectForKey:(id)key;

/** 安全返回NSString */
- (NSString *)safeStringForKey:(id)key;

/** 安全返回NSArray */
- (NSArray *)safeArrayForKey:(id)key;

/** 安全返回NSDictionary */
- (NSDictionary *)safeDictionaryForKey:(id)key;

- (NSMutableDictionary *)mutableDeepCopy;

@end
