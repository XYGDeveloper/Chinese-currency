//
//  HBAddressListViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBPullBaseTableViewController.h"

@class HBMallAddressModel;
typedef void(^HBAddressListViewControllerDidSelectAddressBlock)(HBMallAddressModel *model);

NS_ASSUME_NONNULL_BEGIN

@interface HBAddressListViewController : HBPullBaseTableViewController

@property (nonatomic, copy) HBAddressListViewControllerDidSelectAddressBlock didSelectAddressBlock;

@end

NS_ASSUME_NONNULL_END
