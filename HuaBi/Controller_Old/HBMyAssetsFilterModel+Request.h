//
//  HBMyAssetsFilterModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetsFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBMyAssetsFilterModel (Request)

+ (void)getCurrencyUserStreamFilterWithSuccess:(void(^)(NSArray<HBMyAssetsFilterModel *> *array, YWNetworkResultModel *model))success
                                       failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
