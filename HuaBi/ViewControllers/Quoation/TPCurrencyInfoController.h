//
//  TPCurrencyInfoController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "YTData_listModel.h"


/**
 K线图
 */
@interface TPCurrencyInfoController : YJBaseViewController

@property (nonatomic, strong) ListModel *model;

@property(nonatomic,assign)BOOL isETH;

@end
