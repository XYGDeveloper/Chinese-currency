//
//  HBShopGoodModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/1.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopGoodModel+Request.h"

@implementation HBShopGoodModel (Request)

+ (void)requestGoodsWithPage:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                  categoryID:(NSString *)categoryID
                     success:(void(^)(NSArray<HBShopGoodModel *> *models, YWNetworkResultModel *obj))success
                     failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"page" : @(page),
                                 @"limit" : @(pageSize),
                                 @"cat_id" : categoryID,
                                 };
    [kNetwork_Tool objPOST:@"/Api/mall/index" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSArray<HBShopGoodModel *> *models = [HBShopGoodModel mj_objectArrayWithKeyValuesArray:model.result];
                success(models, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

@end
