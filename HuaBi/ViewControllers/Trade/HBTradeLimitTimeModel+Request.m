//
//  HBTradeLimitTimeModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBTradeLimitTimeModel+Request.h"

@implementation HBTradeLimitTimeModel (Request)

+ (void)requestTradeLimitTimeModelWithCurrencyID:(NSString *)ID
                                         success:(void(^)(HBTradeLimitTimeModel *model, YWNetworkResultModel *obj))success
                                         failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"currency" : ID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Entrust/limt_time" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            HBTradeLimitTimeModel *a = [HBTradeLimitTimeModel mj_objectWithKeyValues:model.result];
            success(a, model);
        }
    } failure:failure];
    
}
@end
