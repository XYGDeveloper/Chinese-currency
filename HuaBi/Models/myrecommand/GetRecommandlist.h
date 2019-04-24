//
//  GetRecommandlist.h
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

@interface GetRecommandlist : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id
                       uuid:(NSString *)uuid
                      level:(NSString *)level;
//- (instancetype)initWithKey:(NSString *)token
//                     lanage:(NSString *)lanage
//                   token_id:(NSString *)token_id
//                       uuid:(NSString *)uuid;
@end
