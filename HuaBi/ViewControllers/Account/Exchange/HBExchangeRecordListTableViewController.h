//
//  HBExchangeRecordListTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBExchangeRecordListTableViewController : HBBaseTableViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, assign) NSInteger status;// -1兑换失败 0审核中 1兑换成功

+ (instancetype)fromStoryboard;

@end

NS_ASSUME_NONNULL_END
