//
//  HBMoneyInterestWarpperModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestWarpperModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBMoneyInterestWarpperModel (Request)

+ (void)requestMoneyInterestWithSuccess:(void(^)(HBMoneyInterestWarpperModel *model, YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
