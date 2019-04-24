//
//  HBMyAssetsFilterModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetsFilterModel+Request.h"

@implementation HBMyAssetsFilterModel (Request)

+ (void)getCurrencyUserStreamFilterWithSuccess:(void(^)(NSArray<HBMyAssetsFilterModel *> *array, YWNetworkResultModel *model))success
                                       failure:(void(^)(NSError *error))failure {
    
    [kNetwork_Tool objPOST:@"/Api/AccountManage/getCurrencyUserStreamFilter" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<HBMyAssetsFilterModel *> *array = [HBMyAssetsFilterModel mj_objectArrayWithKeyValuesArray:model.result];
            if (success) {
                success(array, model);
            }
        }
    } failure:failure];
}

@end
