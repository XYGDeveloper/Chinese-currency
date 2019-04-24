//
//  HBResetPasswordTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBResetPasswordTableViewController : HBBaseTableViewController

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *phone;

@end

NS_ASSUME_NONNULL_END
