//
//  ListModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/5.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTData_listModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListModel (Request)

- (void)collectWithSuccess:(void(^)(BOOL isCollected))success
                   failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
