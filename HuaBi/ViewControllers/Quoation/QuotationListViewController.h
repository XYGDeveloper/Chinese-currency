//
//  QuotationListViewController.h
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@class ListModel;
typedef void(^QuotationListViewControllerDidSelectCellBlock)(ListModel *model);


/**
 行情列表
 */
@interface QuotationListViewController : YJBaseViewController

@property (nonatomic,strong)NSString *tag;
@property (nonatomic,strong)NSArray  *list;

@property (nonatomic, assign) BOOL isTypeOfMenu;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, copy) QuotationListViewControllerDidSelectCellBlock didSelectCellBlock;

@end
