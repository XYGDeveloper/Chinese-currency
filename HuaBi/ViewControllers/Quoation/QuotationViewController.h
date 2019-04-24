//
//  QuotationViewController.h
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "QuotationListViewController.h"


/**
 行情 主界面
 */
@interface QuotationViewController : YJBaseViewController

@property (nonatomic, assign) BOOL isTypeOfMenu;

@property (nonatomic, copy) QuotationListViewControllerDidSelectCellBlock didSelectCellBlock;
- (instancetype)initWithWidth:(CGFloat)width;

- (void)loadData;

@end
