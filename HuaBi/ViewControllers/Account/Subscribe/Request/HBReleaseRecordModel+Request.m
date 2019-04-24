//
//  HBReleaseRecordModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReleaseRecordModel+Request.h"

@implementation HBReleaseRecordModel (Request)

+ (void)requestReleaseRecordListWithID:(NSString *)ID
                                  page:(NSInteger)page
                              pageSize:(NSInteger)pageSize
                               success:(void(^)(NSArray<HBReleaseRecordModel *> *models, YWNetworkResultModel *obj))success
                                   failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"page" : @(page),
                                 @"page_size" : @(pageSize),
                                 @"id" : ID ?: @"",
                                 };

    [kNetwork_Tool objPOST:@"/Api/zhongchoum/detailsm_log_release" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSArray<HBReleaseRecordModel *> *models = [HBReleaseRecordModel mj_objectArrayWithKeyValuesArray:model.result];
                success(models, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

@end
