//
//  NSString+sandBox.m
//
//  Created by shenzhenIOS on 15/3/31.
//  Copyright © 2015年 ZhuuYong. All rights reserved.
//

#import "NSString+sandBox.h"

@implementation NSString (sandBox)
- (instancetype)appendCache
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[self lastPathComponent]];
}
//Document目录
- (instancetype)appendDocument
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[self lastPathComponent]];
}
//Temp目录
- (instancetype)appendTemp
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[self lastPathComponent]];
}
@end
