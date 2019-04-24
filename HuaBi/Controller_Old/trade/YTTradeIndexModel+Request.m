//
//  YTTradeIndexModel+Request.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeIndexModel+Request.h"


@implementation YTTradeIndexModel (Request)

+ (void)requestTradeIndexsWithCurrencyID:(NSString *)ID
                                 success:(void(^)(YTTradeIndexModel *model, YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 @"currency_id" : ID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Entrust/getIndex" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            YTTradeIndexModel *array = [YTTradeIndexModel mj_objectWithKeyValues:model.result];
            success(array, model);
        }
    } failure:failure];
    
}

@end
