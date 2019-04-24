//
//  HBTokenTopUpRecordDetailTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/19.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HBChongCurrencyRecorModel;

@interface HBTokenTopUpRecordDetailTableViewController : HBBaseTableViewController
+ (instancetype)fromStoryboard;
@property (nonatomic,strong)HBChongCurrencyRecorModel *model;
@property (nonatomic,strong)NSString *type;

@end

NS_ASSUME_NONNULL_END
