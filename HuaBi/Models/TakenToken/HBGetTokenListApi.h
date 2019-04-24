//
//  HBGetTokenListApi.h
//  HuaBi
//
//  Created by l on 2019/2/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBGetTokenListApi : BaseListApi
- (instancetype)initWithLanage:(NSString *)lanage token:(NSString *)token token_id:(NSString *)token_id;

@end

NS_ASSUME_NONNULL_END
