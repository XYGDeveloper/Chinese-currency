//
//  YTData_listModel+Request.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/10/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTData_listModel+Request.h"

@implementation YTData_listModel (Request)

+ (void)requestQuotationsWithSuccess:(void(^)(NSArray<YTData_listModel *> *array, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure {
    
    [kNetwork_Tool objPOST:quotation_list parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<YTData_listModel *> *array = [YTData_listModel mj_objectArrayWithKeyValuesArray:model.result];
            if (success) {
                success(array, model);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}



@end
