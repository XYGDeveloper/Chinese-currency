//
//  GetListApi.h
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"


@interface GetListApi : BaseListApi

- (instancetype)initWithType:(NSString *)type
                      lanage:(NSString *)lanage;

@end
