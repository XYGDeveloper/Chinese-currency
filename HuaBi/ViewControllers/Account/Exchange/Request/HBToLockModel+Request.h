//
//  HBToLockModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//


#import "HBToLockModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface HBToLockModel (Request)

+ (void)requestExchangeToLockModelsWithSuccess:(void(^)(NSArray<HBToLockModel *> *array, YWNetworkResultModel *obj))success
                                       failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
