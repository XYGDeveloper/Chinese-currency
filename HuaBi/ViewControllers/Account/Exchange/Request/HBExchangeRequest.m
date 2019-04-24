//
//  HBExchangeRequest.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeRequest.h"

@implementation HBExchangeRequest

+ (void)requestExchangeKokNumberWithSuccess:(void(^)(NSString *number, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure
{
    
  
    [kNetwork_Tool objPOST:@"/Api/Exchange/k_num" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSString *number = [model.result ksObjectForKey:@"user_num"];
                success(number, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}


+ (void)requestExchangeToLockWithNumber:(NSString *)num
                                    pwd:(NSString *)pwd
                                success:(void(^)(YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure
{
    NSDictionary *parameters = @{
                                 @"num" : num ?: @"",
                                 @"pwd" : [pwd md5String] ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Exchange/to_lock"
                parameters:parameters
                   success:^(YWNetworkResultModel *model, id responseObject)
    {
        if (success) {
            success(model);
        }
    } failure:failure];
}

@end
