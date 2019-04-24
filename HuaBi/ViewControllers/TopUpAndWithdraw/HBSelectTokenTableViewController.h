//
//  HBSelectTokenTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HBTokenListModel;

typedef void (^selectCurrency)(HBTokenListModel *model);

@interface HBSelectTokenTableViewController : HBBaseTableViewController
@property (nonatomic,strong)selectCurrency select;

@end

NS_ASSUME_NONNULL_END
