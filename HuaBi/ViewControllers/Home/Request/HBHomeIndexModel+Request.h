//
//  HBHomeIndexModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBHomeIndexModel (Request)

+ (void)requestHomeIndexDataWithSuccess:(void(^)(HBHomeIndexModel *model))success
                                failure:(void(^)(NSError *error))failure;

+ (void)requestHomeQuotationsWithSuccess:(void(^)(YWNetworkResultModel *model))success
                                 failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
