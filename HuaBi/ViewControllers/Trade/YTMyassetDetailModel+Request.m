//
//  YTMyassetDetailModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/5.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTMyassetDetailModel+Request.h"

@implementation YTMyassetDetailModel (Request)

+ (void)requestMyAssetDetailWithCurrencyID:(NSString *)ID
                                   success:(void(^)(YTMyassetDetailModel *model, YWNetworkResultModel *obj))success
                                   failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"currency_id" : ID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"Api/AccountManage/accent_list" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            YTMyassetDetailModel *a = [YTMyassetDetailModel mj_objectWithKeyValues:model.result];
            success(a, model);
        }
    } failure:failure];
    
}

@end
