//
//  YTTradeModel.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTTradeModel : NSObject

@property (nonatomic, copy) NSString *user_total;//总量
@property (nonatomic, copy) NSString *num;//可用量
@property (nonatomic, copy) NSString *forzen_num;//冻结量
//@property (nonatomic, strong) id trade;//最新成交

@end

NS_ASSUME_NONNULL_END
