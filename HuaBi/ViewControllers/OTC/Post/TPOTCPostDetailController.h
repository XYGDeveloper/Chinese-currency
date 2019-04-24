//
//  TPOTCPostDetailController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum {
    TPOTCPostDetailControllerBuy,
    TPOTCPostDetailControllerSell
}TPOTCPostDetailControllerType;

@interface TPOTCPostDetailController : YJBaseViewController


@property(nonatomic,assign)TPOTCPostDetailControllerType type;


//@property(nonatomic,strong)TPCurrencyModel *currencyModel;
@property(nonatomic,strong)NSDictionary *currencyInfo;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *volume;
@property(nonatomic,copy)NSString *maxDeal;
@property(nonatomic,copy)NSString *minDeal;
@property(nonatomic,copy)NSString * sum;
@property(nonatomic,copy)NSString * remark;



@end
