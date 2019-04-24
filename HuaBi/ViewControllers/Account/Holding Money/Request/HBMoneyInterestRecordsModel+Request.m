//
//  HBMoneyInterestRecordsModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestRecordsModel+Request.h"

@implementation HBMoneyInterestRecordsModel (Request)


///Api/MoneyInterest/currencys
+ (void)requestMoneyInterestRecordsByCurrencyID:(NSString *)currencyID
                                     isDividend:(BOOL)isDividend
                                           page:(NSInteger)page
                                        success:(void(^)(NSArray<HBMoneyInterestRecordsModel *> *array, YWNetworkResultModel *obj))success
                                        failure:(void(^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = @{@"page" : @(page)}.mutableCopy;
    if (currencyID && !isDividend) {
        parameters[@"currency_id"] = currencyID ?: @"";
    }
    
    NSString *path = isDividend ? @"/Api/MoneyInterest/dividend" : @"/Api/MoneyInterest/interest";
    
    [kNetwork_Tool objPOST:path parameters:parameters.copy success:^(YWNetworkResultModel *model, id responseObject) {
        if (model.succeeded) {
            if (success) {
                NSArray<HBMoneyInterestRecordsModel *> *array = [HBMoneyInterestRecordsModel mj_objectArrayWithKeyValuesArray:model.result];
                success(array, model);
            }
        } else if (failure) {
            failure(model.error);
        }
    } failure:failure];
}

+ (void)requestMoneyInterestCurrencysWithSuccess:(void(^)(NSArray<HBMoneyInterestRecordsModel *> *array, YWNetworkResultModel *obj))success
                                         failure:(void(^)(NSError *error))failure {
    
    
    [kNetwork_Tool objPOST:@"/Api/MoneyInterest/currencys" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if (model.succeeded) {
            if (success) {
                NSArray<HBMoneyInterestRecordsModel *> *array = [HBMoneyInterestRecordsModel mj_objectArrayWithKeyValuesArray:model.result];
                success(array, model);
            }
        } else if (failure) {
            failure(model.error);
        }
    } failure:failure];
}

@end
