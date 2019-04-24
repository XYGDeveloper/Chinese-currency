//
//  HBMoneyInterestLogModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestLogModel+Request.h"

@implementation HBMoneyInterestLogModel (Request)

+ (void)requestMoneyInterestLogsWithPage:(NSInteger)page
                                 success:(void(^)(NSArray<HBMoneyInterestLogModel *> *array, YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure {
    
    
    [kNetwork_Tool objPOST:@"/Api/MoneyInterest/log" parameters:@{@"page" : @(page)} success:^(YWNetworkResultModel *model, id responseObject) {
        if (model.succeeded) {
            if (success) {
                NSArray<HBMoneyInterestLogModel *> *array = [HBMoneyInterestLogModel mj_objectArrayWithKeyValuesArray:model.result];
                success(array, model);
            }
        } else if (failure) {
            failure(model.error);
        }
    } failure:failure];
}

@end
