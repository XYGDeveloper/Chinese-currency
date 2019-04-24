//
//  HBOTCCurrentADListViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/3.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBPullBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBOTCCurrentADListViewController : HBPullBaseTableViewController <ZJScrollPageViewChildVcDelegate>

@property(nonatomic,strong)TPCurrencyModel *model;

@property(nonatomic,assign)BOOL isHistory;


@end

NS_ASSUME_NONNULL_END
