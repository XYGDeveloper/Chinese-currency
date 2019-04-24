//
//  YTTradeUserOrderModel+Request.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeUserOrderModel+Request.h"
#import "MJExtension.h"

@implementation YTTradeUserOrderModel (Request)

+ (void)requestTradeUserOrdersWithCurrencyID:(NSString *)currencyID
                                     success:(void(^)(NSArray<YTTradeUserOrderModel *> *array, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 @"currency" : currencyID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Entrust/kill_order" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<YTTradeUserOrderModel *> *array = [YTTradeUserOrderModel mj_objectArrayWithKeyValuesArray:model.result];
            if (success) {
                success(array, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

- (void)cancelTradeOrdersWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 @"order_id" : self.orders_id ?: @"",
                                 };
    [kNetwork_Tool objPOST:@"/Api/Depute/cancel" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                success(model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

@end
