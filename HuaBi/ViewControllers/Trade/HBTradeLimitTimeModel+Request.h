//
//  HBTradeLimitTimeModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//


#import "HBTradeLimitTimeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBTradeLimitTimeModel (Request)

+ (void)requestTradeLimitTimeModelWithCurrencyID:(NSString *)ID
                                         success:(void(^)(HBTradeLimitTimeModel *model, YWNetworkResultModel *obj))success
                                         failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
