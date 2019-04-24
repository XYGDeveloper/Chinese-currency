//
//  TPOTCMyADModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/3.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "TPOTCMyADModel+Request.h"

@implementation TPOTCMyADModel (Request)

+ (void)requestMyADModelsWithCurrencyID:(NSString *)currencyID
                              isHistory:(BOOL)isHistory
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize
                                success:(void(^)(NSArray<TPOTCMyADModel *> *models, YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"currency_id" : currencyID ?: @"",
                                 @"page" : @(page),
                                 @"page_size" : @(pageSize),
                                 };
    NSString *URI = isHistory ? @"/Api/OrdersOtc/myhistory_order" : @"/Api/OrdersOtc/my_order";
    [kNetwork_Tool objPOST:URI parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSArray<TPOTCMyADModel *> *models = [NSArray modelArrayWithClass:TPOTCMyADModel.class json:model.result];
            if (success) {
                success(models, model);
            }
        } else {
            if (failure) {
                failure(model.error);
            }
        }
        
    } failure:failure];
}

@end
