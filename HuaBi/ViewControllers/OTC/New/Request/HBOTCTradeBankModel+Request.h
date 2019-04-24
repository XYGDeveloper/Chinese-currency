//
//  HBOTCTradeBankModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/18.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCTradeBankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBOTCTradeBankModel (Request)

+ (void)requestPayWaysWithSuccess:(void(^)(NSArray<NSString *> *payWays, YWNetworkResultModel *obj))success
                          failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
