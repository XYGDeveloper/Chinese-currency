//
//  HBMoneyInterestRecordsViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

typedef NS_ENUM(NSInteger, HBMoneyInterestRecordsViewControllerType) {
    HBMoneyInterestRecordsViewControllerInterset = 1,
    HBMoneyInterestRecordsViewControllerDividend = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface HBMoneyInterestRecordsViewController : YJBaseViewController

@property (nonatomic, assign) HBMoneyInterestRecordsViewControllerType recordsType;

@end

NS_ASSUME_NONNULL_END
