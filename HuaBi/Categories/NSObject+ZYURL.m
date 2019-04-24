//
//  NSObject+ZYURL.m
//  ywshop
//
//  Created by 周勇 on 2017/11/10.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "NSObject+ZYURL.h"

@implementation NSObject (ZYURL)

- (NSURL *)ks_URL {
    
    NSString *url = (NSString *)self;
    /******  网络url  ******/
    if ([url containsString:@"http://"] || [url containsString:@"https://"]) {
        return [NSURL URLWithString:url];
    }
    /******  文件url  ******/
    return [NSURL fileURLWithPath:url];
}

@end
