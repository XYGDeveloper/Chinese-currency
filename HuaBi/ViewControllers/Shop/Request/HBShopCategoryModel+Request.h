//
//  HBShopCategoryModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/1.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBShopCategoryModel (Request)

+ (void)requestCategoriesWithSuccess:(void(^)(NSArray<HBShopCategoryModel *> *models, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
