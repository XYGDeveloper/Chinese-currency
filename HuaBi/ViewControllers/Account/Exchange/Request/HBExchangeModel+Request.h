//
//  HBExchangeModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBExchangeModel (Request)

+ (void)requestExchangeModelsWithStatus:(NSInteger)status
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize
                                success:(void(^)(NSArray<HBExchangeModel *> *array, YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
