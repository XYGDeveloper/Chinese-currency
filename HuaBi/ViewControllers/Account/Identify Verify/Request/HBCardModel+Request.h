//
//  HBCardModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBCardModel (Request)

- (void)verifyMemberWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                        failure:(void(^)(NSError *error))failure;

+ (void)requestVerifyInfoWithSuccess:(void(^)(HBCardModel *model, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
