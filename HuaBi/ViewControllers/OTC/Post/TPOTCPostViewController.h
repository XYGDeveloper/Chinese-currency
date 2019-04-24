//
//  TPOTCPostViewController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"



typedef enum {
    TPOTCPostViewControllerTypeBuy,
    TPOTCPostViewControllerTypeSell
}TPOTCPostViewControllerType;


/**
 出售：发布广告
 */
@interface TPOTCPostViewController : YJBaseViewController<ZJScrollPageViewChildVcDelegate>

@property(nonatomic,assign)TPOTCPostViewControllerType type;

@property(nonatomic,strong)TPCurrencyModel *model;



@end
