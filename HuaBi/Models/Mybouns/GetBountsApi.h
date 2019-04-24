//
//  GetBountsApi.h
//  YJOTC
//
//  Created by l on 2018/9/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

@interface GetBountsApi : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id
                       uuid:(NSString *)uuid
                  startTime:(NSString *)starttime
                    endTime:(NSString *)endTime;

@end
