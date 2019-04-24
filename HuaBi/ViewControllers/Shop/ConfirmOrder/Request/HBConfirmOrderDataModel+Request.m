//
//  HBConfirmOrderDataModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/10.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderDataModel+Request.h"

@implementation HBConfirmOrderDataModel (Request)

+ (void)requestConfirmOrderWithCartIDs:(NSString *)cartIDs
                                 specs:(NSString *)specs
                            isFromCart:(BOOL)isFromCart
                               success:(void(^)(HBConfirmOrderDataModel *data, YWNetworkResultModel *obj))success
                               failure:(void(^)(NSError *error))failure {
    
    
    
    NSDictionary *parameters = @{
                                 @"cart_id" : cartIDs ?: @"",
                                 @"ifcart" : isFromCart ? @"1" : @"0",
                                 @"spec_array" : specs ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/MallBuy/buy_step1" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                HBConfirmOrderDataModel *data = [HBConfirmOrderDataModel mj_objectWithKeyValues:model.result];
                success(data, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}


+ (void)requestConfirmOrderSetp2WithCartIDs:(NSString *)cartIDs
                                  addressID:(NSString *)addressID
                                 currencyID:(NSString *)currencyID
                                 payMessage:(NSString *)payMessage
                                      specs:(NSString *)specs
                                 isFromCart:(BOOL)isFromCart
                                    success:(void(^)(NSString *orderNo, NSString *orderID, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure {
    
    
    
    NSDictionary *parameters = @{
                                 @"cart_id" : cartIDs ?: @"",
                                 @"ifcart" : isFromCart ? @"1" : @"0",
                                 @"spec_array" : specs ?: @"",
                                 @"address_id" : addressID ?: @"",
                                 @"currency_id" : currencyID ?: @"",
                                 @"pay_message" : payMessage ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/MallBuy/buy_step2" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                
                NSString *orderNo = [model.result ksObjectForKey:@"order_sn"];
                NSString *orderID = [model.result ksObjectForKey:@"order_id"];
                success(orderNo, orderID, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

+ (void)requestPayOrderWithOrderID:(NSString *)orderID
                          password:(NSString *)password
                           success:(void(^)(YWNetworkResultModel *obj))success
                           failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"order_id" : orderID ?: @"",
                                 @"pwd" : password ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/MallBuy/pay_order" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            if (success) {
                success( model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

@end
