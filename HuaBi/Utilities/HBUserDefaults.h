//
//  HBUserDefaults.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBUserDefaults : NSObject

+ (NSString *)getCurrentCurrency;


/**
 设置当前计价方式：CNY or USD etc.

 @param currency 当前计价方式
 */
+ (void)setCurrentCurrency:(NSString *)currency;


@end

NS_ASSUME_NONNULL_END
