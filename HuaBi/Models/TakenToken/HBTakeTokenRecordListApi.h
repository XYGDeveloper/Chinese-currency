//
//  HBTakeTokenRecordListApi.h
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBTakeTokenRecordListApi : BaseListApi
- (instancetype)initWithLanage:(NSString *)lanage
                         token:(NSString *)token
                      token_id:(NSString *)token_id
                   currency_id:(NSString *)currency_id
                        status:(NSString *)status;
@end

NS_ASSUME_NONNULL_END
