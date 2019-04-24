//
//  FinLogApi.h
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinLogApi : BaseListApi


@property (nonatomic,copy)NSString *leng;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currency_id;

- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id
                   leng:(NSString *)leng
                   type:(NSString *)type
                   currency_id:(NSString *)currency_id;
@end

NS_ASSUME_NONNULL_END
