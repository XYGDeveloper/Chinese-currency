//
//  HBAppCache.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBAppCache : NSObject

+ (NSString *)cacheDirectory;

+ (void)cacheObject:(id<NSCoding>)obj fileName:(NSString *)fileName;

+ (id)objectWithFileName:(NSString *)fileName;

+ (void)clearCache;

+ (void)cleanCacheWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
