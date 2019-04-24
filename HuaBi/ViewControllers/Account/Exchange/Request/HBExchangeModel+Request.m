//
//  HBExchangeModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeModel+Request.h"

@implementation HBExchangeModel (Request)

+ (void)requestExchangeModelsWithStatus:(NSInteger)status
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize
                                success:(void(^)(NSArray<HBExchangeModel *> *array, YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure
{
    

    NSMutableDictionary *parameters = @{
                                 @"page" :@(page),
                                 @"page_size" : @(pageSize),
                                 }.mutableCopy;
    if (status >= -1 && status <= 1) {
        parameters[@"status"] = @(status);
    }
    
    [kNetwork_Tool objPOST:@"/Api/Exchange/log" parameters:parameters.copy success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            NSArray<HBExchangeModel *> *models = [HBExchangeModel mj_objectArrayWithKeyValuesArray:model.result];
            success(models, model);
        }
    } failure:failure];
}

@end
