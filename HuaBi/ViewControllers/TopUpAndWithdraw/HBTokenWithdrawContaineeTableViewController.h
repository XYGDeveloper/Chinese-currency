//
//  HBTokenWithdrawContaineeTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBTokenWithdrawContaineeTableViewController : UITableViewController

@property (nonatomic, copy) NSString *currencyNameString;
@property(nonatomic,copy)NSString *currency_id;

- (void)submitAction;

@end

NS_ASSUME_NONNULL_END
