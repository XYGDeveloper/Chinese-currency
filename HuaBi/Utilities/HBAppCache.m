//
//  HBAppCache.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBAppCache.h"

@implementation HBAppCache

+ (void)initialize
{
    if (self == [HBAppCache class]) {
        NSString *cachePath = [self cacheDirectory];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}

+ (NSString *)cacheDirectory {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingString:@"/Archive"];
    return path;
}

+ (void)cacheObject:(id<NSCoding>)obj fileName:(NSString *)fileName {
    if (obj && fileName) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", [self cacheDirectory], fileName];
        [NSKeyedArchiver archiveRootObject:obj toFile:file];
    }
}

+ (id)objectWithFileName:(NSString *)fileName {
    if (fileName) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", [self cacheDirectory], fileName];
        return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    }
    return nil;
}

+ (void)clearCache {
    NSArray<NSString *> *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectory] error:nil];
    for (NSString *path in paths) {
        NSString *file = [[self cacheDirectory] stringByAppendingPathComponent:path];
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    }
}

+ (void)cleanCacheWithFileName:(NSString *)fileName {
    if (!fileName) {
        return;
    }
    
    NSString *file = [NSString stringWithFormat:@"%@/%@", [self cacheDirectory], fileName];
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
}

@end
