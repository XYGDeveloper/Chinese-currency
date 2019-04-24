//
//  HBAddressModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBMallAddressModel : NSObject

@property (nonatomic ,copy)NSString * address_id;
@property (nonatomic ,copy)NSString * member_id;
@property (nonatomic ,copy)NSString * name;
@property (nonatomic ,copy)NSString * area_id;
@property (nonatomic ,copy)NSString * city_id;
@property (nonatomic ,copy)NSString * area_info;
@property (nonatomic ,copy)NSString * address;
@property (nonatomic ,copy)NSString * phone;
@property (nonatomic ,copy)NSString * is_default;

+ (void)requestAddressListWithSuccess:(void(^)(NSArray<HBMallAddressModel *> *models, YWNetworkResultModel *obj))success
                              failure:(void(^)(NSError *error))failure;

- (void)requestSaveOrAddAddressWithIsAdd:(BOOL)isAdd
                                 success:(void(^)(YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure;

- (void)requestDeleteAddressWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
