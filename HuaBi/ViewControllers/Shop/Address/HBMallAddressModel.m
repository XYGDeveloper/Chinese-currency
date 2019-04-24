//
//  HBAddressModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBMallAddressModel.h"

@implementation HBMallAddressModel

+ (void)requestAddressListWithSuccess:(void(^)(NSArray<HBMallAddressModel *> *models, YWNetworkResultModel *obj))success
                              failure:(void(^)(NSError *error))failure {
    
    [kNetwork_Tool objPOST:@"/Api/MallAddress/address_list" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<HBMallAddressModel *> *array = [HBMallAddressModel mj_objectArrayWithKeyValuesArray:model.result];
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

- (void)requestSaveOrAddAddressWithIsAdd:(BOOL)isAdd
                                 success:(void(^)(YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *parameters = @{
                                 @"name" : self.name ?: @"",
                                 @"area_info" : self.area_info ?:@"",
                                 @"address" : self.address ?:@"",
                                 @"phone" : self.phone ?:@"",
                                 @"is_default" : self.is_default ?:@"",
                                 }.mutableCopy;
    if (!isAdd) {
        parameters[@"address_id"] = self.address_id ?: @"";
    }
    NSString *uri = isAdd ? @"/Api/MallAddress/add_address" : @"/Api/MallAddress/save_address";
    [kNetwork_Tool objPOST:uri parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                success(model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
    
}



- (void)requestDeleteAddressWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"address_id" : self.address_id ?: @"",
                                 };
    [kNetwork_Tool objPOST:@"/Api/MallAddress/del_address" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                success(model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

@end
