//
//  HBMoneyInterestLogModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBMoneyInterestLogModel (Request)

+ (void)requestMoneyInterestLogsWithPage:(NSInteger)page
                                 success:(void(^)(NSArray<HBMoneyInterestLogModel *> *array, YWNetworkResultModel *obj))success
                                 failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
