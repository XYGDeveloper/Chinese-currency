//
//  HBShopBannerModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/2.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopBannerModel+Request.h"

@implementation HBShopBannerModel (Request)

+ (void)requestBannersWithSuccess:(void(^)(NSArray<HBShopBannerModel *> *models, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure {
    [kNetwork_Tool objPOST:@"/Api/mall/banner" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<HBShopBannerModel *> *array = [HBShopBannerModel mj_objectArrayWithKeyValuesArray:model.result];
            if (success) {
                success(array, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}


@end
