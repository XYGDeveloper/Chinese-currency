//
//  HBOTCTradeInfoModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/15.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCTradeInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBOTCTradeInfoModel (Request)

+ (void)requestTradeInfoModelWithTradeID:(NSString *)tradeID
                                 success:(void(^)(HBOTCTradeInfoModel *model, YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure;

+ (void)requestPayTradeWithTradeID:(NSString *)tradeID moneyType:(NSString *)moneyType
                           success:(void(^)(YWNetworkResultModel *obj))success
                           failure:(void(^)(NSError *error))failure;



@end

NS_ASSUME_NONNULL_END
