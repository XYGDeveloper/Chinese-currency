//
//  HBToLockModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HBToLockModel : NSObject

@property (nonatomic, copy) NSString *log_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *currency_name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy, readonly) NSString *statusString;

@end

NS_ASSUME_NONNULL_END
