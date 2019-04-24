//
//  HBReleaseRecordModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReleaseRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBReleaseRecordModel (Request)

+ (void)requestReleaseRecordListWithID:(NSString *)ID
                                  page:(NSInteger)page
                              pageSize:(NSInteger)pageSize
                               success:(void(^)(NSArray<HBReleaseRecordModel *> *models, YWNetworkResultModel *obj))success
                               failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
