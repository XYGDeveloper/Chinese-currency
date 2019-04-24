//
//  YTLoginAndOutManager.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTLoginManager : NSObject

+ (void)logout;

+ (void)checkIsLogOutByCode:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
