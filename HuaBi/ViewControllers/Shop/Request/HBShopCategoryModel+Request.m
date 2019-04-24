//
//  HBShopCategoryModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/1.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopCategoryModel+Request.h"

@implementation HBShopCategoryModel (Request)

+ (void)requestCategoriesWithSuccess:(void(^)(NSArray<HBShopCategoryModel *> *models, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure {
    [kNetwork_Tool objPOST:@"/Api/mall/cat" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<HBShopCategoryModel *> *array = [HBShopCategoryModel mj_objectArrayWithKeyValuesArray:model.result];
            if (success) {
//                NSMutableArray *tmp = @[].mutableCopy;
//                [tmp addObject:[HBShopCategoryModel createRecommendCategoryModel]];
//                [tmp addObjectsFromArray:array];
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
