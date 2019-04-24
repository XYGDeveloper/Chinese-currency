//
//  HBOTCTradeInfoModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/15.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCTradeInfoModel+Request.h"

@implementation HBOTCTradeInfoModel (Request)

+ (void)requestTradeInfoModelWithTradeID:(NSString *)tradeID
                                 success:(void(^)(HBOTCTradeInfoModel *model, YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"trade_id" : tradeID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/TradeOtc/trade_info" parameters:parameters success:^(YWNetworkResultModel *obj, id responseObject) {
        if (obj.succeeded) {
            if (success) {
                HBOTCTradeInfoModel *model = [HBOTCTradeInfoModel mj_objectWithKeyValues:obj.result];
                success(model, obj);
            }
        } else {
            if (failure) {
                failure(obj.error);
            }
        }
    } failure:failure];
}

+ (void)requestPayTradeWithTradeID:(NSString *)tradeID
                         moneyType:(NSString *)moneyType
                           success:(void(^)(YWNetworkResultModel *obj))success
                           failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"trade_id" : tradeID ?: @"",
                                 @"money_type" : moneyType ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/TradeOtc/pay" parameters:parameters success:^(YWNetworkResultModel *obj, id responseObject) {
        if (obj.succeeded) {
            if (success) {
                success(obj);
            }
        } else {
            if (failure) {
                failure(obj.error);
            }
        }
    } failure:failure];
}

@end
