//
//  HBSubscribeModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBSubscribeModel (Request)


/**
 认购列表页

 @param success success block
 @param failure failure block
 */
+ (void)requestSubscribeListWithPage:(NSInteger)page
                            pageSize:(NSInteger)pageSize
                             success:(void(^)(NSArray<HBSubscribeModel *> *models, YWNetworkResultModel *obj))success
                             failure:(void(^)(NSError *error))failure;


/**
 认购详细页面显示

 @param ID 项目ID
 @param success success block
 @param failure failure block
 */
+ (void)requestSubscribeByID:(NSString *)ID
                     success:(void(^)(HBSubscribeModel *model, YWNetworkResultModel *obj))success
                     failure:(void(^)(NSError *error))failure;


/**
 认购操作

 @param ID 认购项目ID
 @param num 认购数量
 @param success success block
 @param failure failure block
 */
+ (void)subscribeWithID:(NSString *)ID
                    num:(NSString *)num
                success:(void(^)(YWNetworkResultModel *obj))success
                failure:(void(^)(NSError *error))failure;




- (void)requestSubscribeBalanceWithSuccess:(void(^)(NSString *num, YWNetworkResultModel *obj))success
                                   failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
