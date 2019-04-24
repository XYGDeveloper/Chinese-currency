//
//  HBConfirmOrderDataModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/10.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBConfirmOrderDataModel (Request)

+ (void)requestConfirmOrderWithCartIDs:(NSString *)cartIDs
                                 specs:(NSString *)specs
                            isFromCart:(BOOL)isFromCart
                               success:(void(^)(HBConfirmOrderDataModel *data, YWNetworkResultModel *obj))success
                               failure:(void(^)(NSError *error))failure;

+ (void)requestConfirmOrderSetp2WithCartIDs:(NSString *)cartIDs
                                  addressID:(NSString *)addressID
                                 currencyID:(NSString *)currencyID
                                 payMessage:(NSString *)payMessage
                                      specs:(NSString *)specs
                                 isFromCart:(BOOL)isFromCart
                                    success:(void(^)(NSString *orderNo, NSString *orderID, YWNetworkResultModel *obj))success
                                    failure:(void(^)(NSError *error))failure;

+ (void)requestPayOrderWithOrderID:(NSString *)orderID
                          password:(NSString *)password
                           success:(void(^)(YWNetworkResultModel *obj))success
                           failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
