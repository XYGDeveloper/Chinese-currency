//
//  HBShopCartModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/8.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopCartModel+Request.h"

@implementation HBShopCartModel (Request)

+ (void)requestCartsWithSuccess:(void(^)(NSArray<HBShopCartModel *> *models, YWNetworkResultModel *obj))success
                        failure:(void(^)(NSError *error))failure {
    [kNetwork_Tool objPOST:@"/Api/cart/cart_list" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            
            NSArray<HBShopCartModel *> *array = [HBShopCartModel mj_objectArrayWithKeyValuesArray:model.result];
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

- (void)requestModifyNumberOfCartWithNumber:(NSInteger)number
                                    success:(void(^)(NSInteger stockNumber, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"cart_num" : @(number),
                                 @"cart_id" : self.cart_id ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/cart/cart_modify" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSInteger stockNumber = [[model.result ksObjectForKey:@"stock_num"] integerValue];
            if (success) {
                success(stockNumber, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

+ (void)requestDeleteCarts:(NSArray *)carts
                   success:(void(^)(YWNetworkResultModel *obj))success
                   failure:(void(^)(NSError *error))failure {
    
    
    NSString *IDs = [[carts mutableArrayValueForKey:@"cart_id"] componentsJoinedByString:@","];
    NSDictionary *parameters = @{
                                 @"cart_id" : IDs ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/cart/cart_del" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
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
