//
//  HBMoneyInterestRecordsModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestRecordsModel.h"


@interface HBMoneyInterestRecordsModel (Request)

+ (void)requestMoneyInterestRecordsByCurrencyID:(NSString *)currencyID
                                     isDividend:(BOOL)isDividend
                                           page:(NSInteger)page
                                        success:(void(^)(NSArray<HBMoneyInterestRecordsModel *> *array, YWNetworkResultModel *obj))success
                                        failure:(void(^)(NSError *error))failure;

+ (void)requestMoneyInterestCurrencysWithSuccess:(void(^)(NSArray<HBMoneyInterestRecordsModel *> *array, YWNetworkResultModel *obj))success
                                         failure:(void(^)(NSError *error))failure;

@end

