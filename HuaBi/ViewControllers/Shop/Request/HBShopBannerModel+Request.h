//
//  HBShopBannerModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/2.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBShopBannerModel (Request)

+ (void)requestBannersWithSuccess:(void(^)(NSArray<HBShopBannerModel *> *models, YWNetworkResultModel *obj))success
                          failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
