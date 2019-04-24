//
//  TPOTCBuyListCellDelegate.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPOTCBuyListCell.h"
#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPOTCBuyListCellDelegate : NSObject<TPOTCBuyListCellDelegate>

- (instancetype)initWithViewController:(YJBaseViewController *)vc;

#pragma mark - Public
- (void)requestMyPaywas;

@end

NS_ASSUME_NONNULL_END
