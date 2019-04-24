//
//  HBUserInfoCache.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBUserInfoCache : NSObject

@property (nonatomic, strong) YJUserInfo *userInfo;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
