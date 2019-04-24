//
//  YTTradeUserOrderModel+Request.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeUserOrderModel+Request.h"
#import "MJExtension.h"
#import "YTData_listModel.h"

@implementation YTTradeUserOrderModel (Request)

+ (void)requestTradeUserOrdersWithCurrencyID:(NSString *)currencyID
                                     success:(void(^)(NSArray<YTTradeUserOrderModel *> *array, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure {
    [self requestTradeUserOrdersWithCurrencyID:currencyID isHistory:NO success:success failure:failure];
}


+ (void)requestTradeUserOrdersWithCurrencyModel:(ListModel *)model
                                 isTypeOfBuy:(NSString *)isTypeOfBuy
                                        rows:(NSInteger)rows
                                        page:(NSInteger)page
                                   isHistory:(BOOL)isHistory
                                     success:(void(^)(NSArray<YTTradeUserOrderModel *> *array, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
//                                 @"currency" : model.currency_id ?: @"",
//                                 @"type" : isTypeOfBuy ?: @"",
//                                 @"currency_mark" : model.currency_mark ?: @"",
//                                 @"trade_currency_mark" : model.trade_currency_mark ?: @"",
                                 @"rows" : @(rows),
                                 @"page" : @(page),
                                 @"host_type" : isHistory ? @"2" : @"1",
                                 };
    
//    NSString *URIString = isHistory ? @"/Api/Entrust/trade_history_app" : @"/Api/Entrust/kill_order";
    [kNetwork_Tool objPOST:@"/Api/Entrust/kill_order_app" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<YTTradeUserOrderModel *> *array = [YTTradeUserOrderModel mj_objectArrayWithKeyValuesArray:[model.result valueForKey:@"user_orders"]];
            if (success) {
                success(array, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
    
}

+ (void)requestTradeUserOrdersWithCurrencyID:(NSString *)currencyID
                                   isHistory:(BOOL)isHistory
                                     success:(void(^)(NSArray<YTTradeUserOrderModel *> *array, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 @"currency" : currencyID ?: @"",
                                 };
    NSString *URIString = isHistory ? @"/Api/Entrust/trade_history_app" : @"/Api/Entrust/kill_order";
    [kNetwork_Tool objPOST:URIString parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
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

+ (void)requestTradeUserOrdersDetailsWithSuccess:(void(^)(NSArray<YTTradeUserOrderModel *> *array, YWNetworkResultModel *obj))success
                                         failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Entrust/kill_order_app_details" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
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

@end
