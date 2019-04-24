//
//  TPOTCBuyListController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"


/**
 OTC 购买\售出列表
 */
@interface TPOTCBuyOrSellListController : YJBaseViewController<ZJScrollPageViewChildVcDelegate>


@property(nonatomic,strong)TPCurrencyModel *model;

@property (nonatomic, assign) BOOL isTypeOfBuy;

@end
