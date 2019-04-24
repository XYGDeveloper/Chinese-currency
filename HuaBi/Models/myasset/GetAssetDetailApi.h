//
//  GetAssetDetailApi.h
//  YJOTC
//
//  Created by l on 2018/9/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

@interface GetAssetDetailApi : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id
                currency_id:(NSString *)currency_id;
@end
