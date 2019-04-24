//
//  NSUserDefaults+HB.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/13.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults (HB)

+ (void)cleanExpiredData;

+ (void)setServerTime:(NSString *)serverTime;

+ (NSString *)getServerTime;

@end

