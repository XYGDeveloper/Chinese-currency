//
//  HBExchangeCurrencysModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeCurrencysModel+Request.h"

@implementation HBExchangeCurrencysModel (Request)

+ (void)requestExchangeCurrencysWithSuccess:(void(^)(HBExchangeCurrencysModel *currencysModel, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure {
    

    [kNetwork_Tool objPOST:@"/Api/Exchange/currencys" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            HBExchangeCurrencysModel *csModel = [HBExchangeCurrencysModel mj_objectWithKeyValues:model.result];
            if (success) {
                success(csModel, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

+ (void)requestExchangeAddAPIWithPwd:(NSString *)pwd
                              fromID:(NSString *)fromID
                                toID:(NSString *)toID
                             fromNum:(NSString *)fromNum
                             success:(void(^)(YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure
{
    
    NSString *md5pwd = [pwd md5String];
    NSDictionary *parameters = @{
                                 @"pwd" : md5pwd ?: @"",
                                 @"from_id" : fromID ?: @"",
                                 @"from_num" : fromNum ?: @"",
                                 @"to_id" : toID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Exchange/add" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

@end
