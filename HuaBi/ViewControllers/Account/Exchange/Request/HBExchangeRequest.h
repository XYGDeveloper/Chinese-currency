//
//  HBExchangeRequest.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBExchangeRequest : NSObject

+ (void)requestExchangeKokNumberWithSuccess:(void(^)(NSString *number, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure;

+ (void)requestExchangeToLockWithNumber:(NSString *)num
                                    pwd:(NSString *)pwd
                                success:(void(^)(YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
