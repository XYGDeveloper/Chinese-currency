//
//  HBExchangeCurrencysModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeCurrencysModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBExchangeCurrencysModel (Request)

+ (void)requestExchangeCurrencysWithSuccess:(void(^)(HBExchangeCurrencysModel *currencysModel, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure;

+ (void)requestExchangeAddAPIWithPwd:(NSString *)pwd
                              fromID:(NSString *)fromID
                                toID:(NSString *)toID
                             fromNum:(NSString *)fromNum
                             success:(void(^)(YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
