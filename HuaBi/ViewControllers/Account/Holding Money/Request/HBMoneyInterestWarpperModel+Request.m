//
//  HBMoneyInterestWarpperModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestWarpperModel+Request.h"

@implementation HBMoneyInterestWarpperModel (Request)

+ (void)requestMoneyInterestWithSuccess:(void(^)(HBMoneyInterestWarpperModel *model, YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure {
    [kNetwork_Tool objPOST:@"/Api/MoneyInterest/index" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            HBMoneyInterestWarpperModel *m = [HBMoneyInterestWarpperModel mj_objectWithKeyValues:model.result];
            if (success) {
                success(m, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

@end
