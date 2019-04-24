//
//  YTData_listModel+Request.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/10/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTData_listModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTData_listModel (Request)

+ (void)requestQuotationsWithSuccess:(void(^)(NSArray<YTData_listModel *> *array, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
