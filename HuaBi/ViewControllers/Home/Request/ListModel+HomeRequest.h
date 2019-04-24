//
//  ListModel+HomeRequest.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/24.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "YTData_listModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListModel (HomeRequest)

+ (void)requestHomeQuotationsWithSuccess:(void(^)(NSArray<ListModel *> *quotations, NSArray<YTData_listModel *> *allRankingArray, YWNetworkResultModel *model))success
                                 failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
