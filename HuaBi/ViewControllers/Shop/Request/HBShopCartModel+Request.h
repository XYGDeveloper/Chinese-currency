//
//  HBShopCartModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/8.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopCartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBShopCartModel (Request)

+ (void)requestCartsWithSuccess:(void(^)(NSArray<HBShopCartModel *> *models, YWNetworkResultModel *obj))success
                        failure:(void(^)(NSError *error))failure;

- (void)requestModifyNumberOfCartWithNumber:(NSInteger)number
                                    success:(void(^)(NSInteger stockNumber, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure;

+ (void)requestDeleteCarts:(NSArray *)carts
                   success:(void(^)(YWNetworkResultModel *obj))success
                   failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
