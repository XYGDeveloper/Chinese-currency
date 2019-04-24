//
//  HBGetC2CTradeListApi.h
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

@interface HBGetC2CTradeListApi : BaseListApi
- (instancetype)initWithType:(NSString *)key
                      tokid:(NSString *)tokenid
                      lanage:(NSString *)lanage;
@end
