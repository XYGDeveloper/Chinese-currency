//
//  YTTradeRequest.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YTTradeModel;
@interface YTTradeRequest : NSObject

+ (void)requestTradAllBuyLoginWithCurrencyID:(NSString *)ID
                                     success:(void(^)(YTTradeModel *model, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure;

+ (void)operateTradeWithCurrencyID:(NSString *)ID
                       isTypeOfBuy:(BOOL)isTypeOfBuy
                             price:(NSString *)price
                            number:(NSString *)number
                          password:(NSString *)password
                           success:(void(^)(YWNetworkResultModel *obj))success
                           failure:(void(^)(NSError *error))failure;




@end

NS_ASSUME_NONNULL_END
