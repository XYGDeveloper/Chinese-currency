//
//  HBTradeLimitTimeModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBTradeLimitTimeModel : NSObject

@property (nonatomic, copy) NSString *currency_id;
@property (nonatomic, copy) NSString *currency_name;
@property (nonatomic, copy) NSString *currency_mark;
@property (nonatomic, copy) NSString *min_limit;
@property (nonatomic, copy) NSString *max_limit;
@property (nonatomic, copy) NSString *max_time;
@property (nonatomic, copy) NSString *min_time;
@property (nonatomic, assign) BOOL is_limit;
@property (nonatomic, assign) BOOL is_time;
@end

NS_ASSUME_NONNULL_END
