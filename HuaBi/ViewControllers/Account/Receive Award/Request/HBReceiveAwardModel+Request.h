//
//  HBReceiveAwardModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReceiveAwardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBReceiveAwardModel (Request)

+ (void)requestReceiveAwardModelsWithPage:(NSInteger)page
                                 pageSize:(NSInteger)pageSize
                                  success:(void(^)(NSArray<HBReceiveAwardModel *> *models, YWNetworkResultModel *obj))success
                                     failure:(void(^)(NSError *error))failure;

- (void)receiveAwardWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                        failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
