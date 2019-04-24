//
//  HBTokenTopUpTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBTokenTopUpTableViewController : HBBaseTableViewController

@property (nonatomic,strong)NSString *currencyid;
@property (nonatomic,strong)NSString *currencyname;
+ (instancetype)fromStoryboard;

@end

NS_ASSUME_NONNULL_END
