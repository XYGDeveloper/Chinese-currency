//
//  HBBaseTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBBaseTableViewController : UITableViewController

-(void)showTips:(NSString *)msg;

-(void)gotoLoginVC;

@end

NS_ASSUME_NONNULL_END
