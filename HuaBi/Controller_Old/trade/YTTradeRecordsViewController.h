//
//  YTTradeRecordsViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ListModel;
@interface YTTradeRecordsViewController : YJBaseViewController

@property (nonatomic, strong) ListModel *model;

+ (instancetype)fromStoryboard;

@end

NS_ASSUME_NONNULL_END
