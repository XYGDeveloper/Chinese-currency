//
//  YTTradeUserOrderModel+Request.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeUserOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTTradeUserOrderModel (Request)

+ (void)requestTradeUserOrdersWithCurrencyID:(NSString *)currencyID
                                     success:(void(^)(NSArray<YTTradeUserOrderModel *> *array, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure;

- (void)cancelTradeOrdersWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
