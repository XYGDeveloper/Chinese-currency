//
//  NSString+safe.m
//  Zhuzhu
//
//  Created by zagger on 15/12/15.
//  Copyright © 2015年 www.globex.cn. All rights reserved.
//

#import "NSString+safe.h"

@implementation NSString (safe)

- (NSString *)safeSubstringFromIndex:(NSUInteger)from
{
    if (from > self.length) {
        return nil;
    } else {
        return [self substringFromIndex:from];
    }
}

- (NSString *)safeSubstringToIndex:(NSUInteger)to
{
    if (to > self.length) {
        return nil;
    } else {
        return [self substringToIndex:to];
    }
}

- (NSString *)safeSubstringWithRange:(NSRange)range
{
    if (range.location + range.length > self.length) {
        return nil;
    } else {
        return [self substringWithRange:range];
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self rangeOfString:aString];
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self rangeOfString:aString options:mask];
    }
    
}

- (NSString *)safeStringByAppendingString:(NSString *)aString
{
    if (aString == nil) {
        return [self stringByAppendingString:@""];
    } else {
        return [self stringByAppendingString:aString];
    }
}

- (id)safeInitWithString:(NSString *)aString
{
    if (aString == nil) {
        return [self initWithString:@""];
    } else {
        return [self initWithString:aString];
    }
}

+ (id)safeStringWithString:(NSString *)string
{
    if (string == nil) {
        return [self stringWithString:@""];
    } else {
        return [self stringWithString:string];
    }
}

@end
