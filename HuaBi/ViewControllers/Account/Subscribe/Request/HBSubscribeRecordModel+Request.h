//
//  HBSubscribeRecordModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBSubscribeRecordModel (Request)

+ (void)requestSubscribeRecordListWithPage:(NSInteger)page
                                  pageSize:(NSInteger)pageSize
                                   success:(void(^)(NSArray<HBSubscribeRecordModel *> *models, YWNetworkResultModel *obj))success
                                   failure:(void(^)(NSError *error))failure;

/**
 释放
 
 ID 用户购币单ID
 @param success success block
 @param failure failure block
 */
- (void)releaseSubscribeWithSuccess:(void(^)(YWNetworkResultModel *obj))success
                            failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
