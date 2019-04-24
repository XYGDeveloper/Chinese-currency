//
//  ICNNationalityModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ICNNationalityModel+Request.h"

@implementation ICNNationalityModel (Request)

+ (void)requestCountryListWithSuccess:(void(^)(NSArray<ICNNationalityModel *> *array, YWNetworkResultModel *model))success
                              failure:(void(^)(NSError *error))failure {
    
    [kNetwork_Tool objPOST:@"/Api/Account/countrylist" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray<ICNNationalityModel *> *array = [ICNNationalityModel mj_objectArrayWithKeyValuesArray:model.result];
        if ([model succeeded]) {
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
