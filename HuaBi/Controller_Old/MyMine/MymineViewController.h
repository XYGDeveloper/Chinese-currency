//
//  MymineViewController.h
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@interface MymineViewController : YJBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, copy) NSString *type;//62  交易  63 团队 64  分红

@end
