//
//  HBSubscribeRecordModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeRecordModel+Request.h"

@implementation HBSubscribeRecordModel (Request)

+ (void)requestSubscribeRecordListWithPage:(NSInteger)page
                                  pageSize:(NSInteger)pageSize
                                   success:(void(^)(NSArray<HBSubscribeRecordModel *> *models, YWNetworkResultModel *obj))success
                                   failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"page" : @(page),
                                 @"page_size" : @(pageSize),
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/zhongchoum/detailsm_log" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSArray<HBSubscribeRecordModel *> *models = [HBSubscribeRecordModel mj_objectArrayWithKeyValuesArray:model.result];
                success(models, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

- (void)releaseSubscribeWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                            failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"id" : self.ID ?: @"",
                                 };
    [kNetwork_Tool objPOST:@"/Api/zhongchoum/release" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

@end
