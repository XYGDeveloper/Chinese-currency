//
//  YTTradeViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ListModel;

/**
 交易 主界面
 */
@interface YTTradeViewController : YJBaseViewController


@property (nonatomic, strong) ListModel *currentListModel;
@property (nonatomic, assign) BOOL isTypeOfBuy;

//- (void)tapButtonWithIsBuy:(BOOL)isbuy;

@end

NS_ASSUME_NONNULL_END
