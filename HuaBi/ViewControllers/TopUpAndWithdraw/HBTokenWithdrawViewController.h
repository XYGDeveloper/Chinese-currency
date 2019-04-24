//
//  HBTokenWithdrawTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBTokenWithdrawViewController : YJBaseViewController

@property (nonatomic,strong)NSString *currency;
@property (nonatomic,strong)NSString *currency_id;

+ (instancetype)fromStoryboard;

@end

NS_ASSUME_NONNULL_END
