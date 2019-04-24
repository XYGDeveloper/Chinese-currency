//
//  HBAddAddressViewController.h
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
@class HBAddressModel;
@interface HBAddAddressViewController : YJBaseViewController
@property (nonatomic,strong)NSString *currencyName;
@property (nonatomic,strong)NSString *currencyid;
@property (nonatomic,strong)HBAddressModel *model;
@property (nonatomic,strong)NSString *type;
@end
