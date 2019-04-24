//
//  HBCardModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCardModel+Request.h"

@implementation HBCardModel (Request)

- (void)verifyMemberWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                        failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameter = @{
                                @"name" : self.name ?: @"",
                                @"cardtype" : @(self.cardtype),
                                @"idcard" : self.idcard ?: @"",
                                @"pic1" : self.pic1 ?: @"",
                                @"pic2" : self.pic2 ?: @"",
                                @"pic3" : self.pic3 ?: @"",
                                @"country_code" : self.country_code ?: @"",
                                };
    [kNetwork_Tool objPOST:@"/Api/Account/member_verify" parameters:parameter success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

+ (void)requestVerifyInfoWithSuccess:(void(^)(HBCardModel *model, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure {
    [kNetwork_Tool objPOST:@"/Api/Account/verify_info" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            HBCardModel *cm = [HBCardModel mj_objectWithKeyValues:model.result];
            if (success) {
                success(cm, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

@end
