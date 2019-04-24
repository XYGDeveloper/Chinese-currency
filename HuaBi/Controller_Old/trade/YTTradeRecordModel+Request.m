//
//  YTTradeRecordModel+Request.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeRecordModel+Request.h"

@implementation YTTradeRecordModel (Request)

+ (void)requestTradeRecordsWithCurrencyID:(NSString *)currencyID
                                     success:(void(^)(NSArray<YTTradeRecordModel *> *array, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 @"currency" : currencyID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Entrust/trade_history_app" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<YTTradeRecordModel *> *array = [YTTradeRecordModel mj_objectArrayWithKeyValuesArray:model.result];
            if (success) {
                success(array, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

@end
