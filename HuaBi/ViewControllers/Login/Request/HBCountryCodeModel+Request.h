//
//  HBCountryCodeModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCountryCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBCountryCodeModel (Request)

+ (void)requestCountryListWithSuccess:(void(^)(NSArray<HBCountryCodeModel *> *array, YWNetworkResultModel *model))success
                              failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
