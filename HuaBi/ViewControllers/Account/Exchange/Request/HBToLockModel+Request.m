//
//  HBToLockModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBToLockModel+Request.h"

@implementation HBToLockModel (Request)

+ (void)requestExchangeToLockModelsWithSuccess:(void(^)(NSArray<HBToLockModel *> *array, YWNetworkResultModel *obj))success
                                       failure:(void(^)(NSError *error))failure
{
    
    
    [kNetwork_Tool objPOST:@"/Api/Exchange/to_lock_log" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                HBToLockModel *models = [HBToLockModel mj_objectArrayWithKeyValuesArray:model.result];
                success(models, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

@end
