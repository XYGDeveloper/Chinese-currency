//
//  HBMoneyInterestSettingModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestSettingModel+Request.h"

@implementation HBMoneyInterestSettingModel (Request)

- (void)addMoneyInterestWithNumber:(NSString *)number
                           success:(void(^)(YWNetworkResultModel *obj))success
                           failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"currency_id" : self.currency_id ?: @"",
                                 @"months" : self.months ?: @"",
                                 @"num" : number ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/MoneyInterest/add" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success( model);
        }
    } failure:failure];
}

@end
