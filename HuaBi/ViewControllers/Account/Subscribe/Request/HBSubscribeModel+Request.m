//
//  HBSubscribeModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeModel+Request.h"

@implementation HBSubscribeModel (Request)


+ (void)requestSubscribeListWithPage:(NSInteger)page
                            pageSize:(NSInteger)pageSize
                             success:(void(^)(NSArray<HBSubscribeModel *> *models, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"page" : @(page),
                                 @"page_size" : @(pageSize),
                                 };
    [kNetwork_Tool objPOST:@"/Api/zhongchoum/indexm" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSArray<HBSubscribeModel *> *models = [HBSubscribeModel mj_objectArrayWithKeyValuesArray:model.result];
                success(models, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

+ (void)requestSubscribeByID:(NSString *)ID
                     success:(void(^)(HBSubscribeModel *model, YWNetworkResultModel *obj))success
                     failure:(void(^)(NSError *error))failure {
    
    
    [kNetwork_Tool objPOST:@"/Api/zhongchoum/detailsm" parameters:@{ @"id" : ID ?: @"" } success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                HBSubscribeModel *m = [HBSubscribeModel mj_objectWithKeyValues:model.result];
                success(m, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

+ (void)subscribeWithID:(NSString *)ID
                    num:(NSString *)num
                success:(void(^)(YWNetworkResultModel *obj))success
                failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"id" : ID ?: @"",
                                  @"num" : num ?: @""
                                 };
    [kNetwork_Tool objPOST:@"/Api/zhongchoum/run" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                success(model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}



- (void)requestSubscribeBalanceWithSuccess:(void(^)(NSString *num, YWNetworkResultModel *obj))success
                                   failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"id" : self.ID ?: @"",
                                 };
    [kNetwork_Tool objPOST:@"/Api/zhongchoum/detailsm_user" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                NSString *num = [model.result valueForKey:@"num"];
                success(num, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}



@end
