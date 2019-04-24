//
//  YTGetNewsListApi.h
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTGetNewsListApi : BaseListApi
- (instancetype)initWithType:(NSString *)type
                      lanage:(NSString *)lanage;
@end

NS_ASSUME_NONNULL_END
