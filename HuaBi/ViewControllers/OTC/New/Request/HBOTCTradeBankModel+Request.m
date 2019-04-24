//
//  HBOTCTradeBankModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/18.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCTradeBankModel+Request.h"

@implementation HBOTCTradeBankModel (Request)

+ (void)requestPayWaysWithSuccess:(void(^)(NSArray<NSString *> *payWays, YWNetworkResultModel *obj))success
                          failure:(void(^)(NSError *error))failure {
    [kNetwork_Tool objPOST:@"/Api/Bank/index" parameters:@{@"page_size" : @(100)} success:^(YWNetworkResultModel *obj, id responseObject) {
        if (obj.succeeded) {
            if (success) {
                NSMutableArray *result = @[].mutableCopy;
                NSArray *banks = [obj.result ksObjectForKey:kYHK];
                NSArray *zfbs = [obj.result ksObjectForKey:kZFB];
                NSArray *wecahts = [obj.result ksObjectForKey:kWechat];
                
                if ([self _checkHasActivatedPayWithPayways:banks]) {
    
                    [result addObject:kYHK];
                }
                
                if ([self _checkHasActivatedPayWithPayways:zfbs]) {
                    [result addObject:kZFB];
                }
                
                if ([self _checkHasActivatedPayWithPayways:wecahts]) {
                    [result addObject:kWechat];
                }
                success(result.copy,obj);
            }
        } else {
            if (failure) {
                failure(obj.error);
            }
        }
    } failure:failure];
}

+ (BOOL)_checkHasActivatedPayWithPayways:(id)payways {
     NSArray<HBOTCTradeBankModel *> *models = [HBOTCTradeBankModel mj_objectArrayWithKeyValuesArray:payways];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = '1'"];
    NSArray *filteredArray = [models filteredArrayUsingPredicate:predicate];
    return filteredArray.count > 0;
}

@end
