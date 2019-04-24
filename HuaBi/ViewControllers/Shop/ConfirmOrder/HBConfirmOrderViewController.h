//
//  HBConfirmOrderViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/9.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HBShopCartModel;
@interface HBConfirmOrderViewController : YJBaseViewController

@property (nonatomic, copy) NSString *cartIDs;
@property (nonatomic, copy) NSString *spec_array;
@property (nonatomic, assign) BOOL isFromCart;//是否从购物车? 1：是，2：立即购买跳转而来

+ (instancetype)fromStoryboard;

@end

NS_ASSUME_NONNULL_END
