//
//  HBTakenTokenAddressViewController.h
//  HuaBi
//
//  Created by l on 2019/2/22.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HBAddressModel;

typedef void (^getAddress)(HBAddressModel *model);

@interface HBTakenTokenAddressViewController : YJBaseViewController
@property (nonatomic,strong)NSString *currency_id;
@property (nonatomic,strong)NSString *currencyName;
@property (nonatomic,strong)getAddress address;

@end

NS_ASSUME_NONNULL_END
