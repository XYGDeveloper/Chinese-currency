//
//  YTTradeRecordModel.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTTradeRecordModel : NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *add_time;

- (UIColor *)typeColor;

@end

NS_ASSUME_NONNULL_END
