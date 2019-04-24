//
//  HBReceiveAwardModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReceiveAwardModel+Request.h"

@implementation HBReceiveAwardModel (Request)

+ (void)requestReceiveAwardModelsWithPage:(NSInteger)page
                                 pageSize:(NSInteger)pageSize
                                  success:(void(^)(NSArray<HBReceiveAwardModel *> *models, YWNetworkResultModel *obj))success
                                  failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"page" : @(page),
                                 @"page_size" : @(pageSize),
                                 };
    [kNetwork_Tool objPOST:@"/Api/Account/get_user_num_award_list" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<HBReceiveAwardModel *> *models = [HBReceiveAwardModel mj_objectArrayWithKeyValuesArray:model.result];
            if (success) {
                success(models, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

- (void)receiveAwardWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                        failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"id" : self.ID ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Account/update_user_num_award" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

@end
