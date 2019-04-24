//
//  HBRecorderDetailViewController.h
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HBChongCurrencyRecorModel;

@interface HBRecorderDetailViewController : YJBaseViewController
@property (nonatomic,strong)HBChongCurrencyRecorModel *model;
@property (nonatomic,strong)NSString *type;

@end

NS_ASSUME_NONNULL_END
