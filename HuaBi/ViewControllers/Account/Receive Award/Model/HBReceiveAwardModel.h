//
//  HBReceiveAwardModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBReceiveAwardModel : NSObject

@property (nonatomic ,copy)NSString * ID;
@property (nonatomic ,copy)NSString * member_id;
@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * num_award;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * type;
@property (nonatomic ,copy)NSString *status;

- (BOOL)canReceive;

@end

NS_ASSUME_NONNULL_END
