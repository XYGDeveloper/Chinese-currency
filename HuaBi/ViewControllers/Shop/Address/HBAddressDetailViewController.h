//
//  HBAddressDetailViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN



@class HBMallAddressModel;
@interface HBAddressDetailViewController : YJBaseViewController

+ (instancetype)fromStoryboard;

+ (instancetype)getShowedVCWithModel:(HBMallAddressModel *)model;

+ (instancetype)getEditVCWithModel:(HBMallAddressModel *)model;

+ (instancetype)getAddVC;

@end

NS_ASSUME_NONNULL_END
