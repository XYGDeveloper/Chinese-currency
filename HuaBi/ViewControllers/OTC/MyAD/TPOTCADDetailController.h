//
//  TPOTCADDetailController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
@interface TPOTCADDetailController : YJBaseViewController

@property(nonatomic,strong)TPOTCMyADModel *model;

@property(nonatomic,assign)BOOL isHistory;

@property(nonatomic,copy)NSString *currencyID;


@end
