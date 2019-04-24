//
//  YTTradeRequest.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeRequest.h"
#import "YTTradeModel.h"
#import "MJExtension.h"

@implementation YTTradeRequest

+ (void)requestTradAllBuyLoginWithCurrencyID:(NSString *)ID
                                     success:(void(^)(YTTradeModel *model, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 @"currency" : ID ?: @"",
                                 };
//    NSString *URI = isTypeOfBuy ? @"/Api/Entrust/tradall_buy_login" : [NSString stringWithFormat: @"/Api/Entrust/tradall_sell_login/currency/%@", ID ?: @""];
    
    [kNetwork_Tool objPOST:@"/Api/Entrust/tradall_buy_login" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        
        if ([model succeeded]) {
            YTTradeModel *result = [YTTradeModel mj_objectWithKeyValues:model.result];
            if (success) {
                success(result, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
    } failure:failure];
}

+ (void)operateTradeWithCurrencyID:(NSString *)ID
                       isTypeOfBuy:(BOOL)isTypeOfBuy
                             price:(NSString *)price
                            number:(NSString *)number
                          password:(NSString *)password
                           success:(void(^)(YWNetworkResultModel *obj))success
                           failure:(void(^)(NSError *error))failure {
    NSString *priceKey;
    NSString *numKey;
    NSString *pwdKey;
    if (isTypeOfBuy) {
        priceKey = @"buyprice";
        numKey = @"buynum";
        pwdKey = @"buypwd";
    } else {
        priceKey = @"sellprice";
        numKey = @"sellnum";
        pwdKey = @"sellpwd";
    }
    
    NSDictionary *parameters = @{
                                 @"token_id" : @(kUserInfo.uid),
                                 @"key" : kUserInfo.token ?: @"",
                                 @"currency_id" : ID ?: @"",
                                 priceKey : price ?: @"",
                                 numKey : number ?: @"",
                                 pwdKey : password ?: @"",
                                 };
    NSString *URI = isTypeOfBuy ? @"/Api/Trade/buy" : @"/Api/Trade/sell";
    
    [kNetwork_Tool objPOST:URI parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}



@end
