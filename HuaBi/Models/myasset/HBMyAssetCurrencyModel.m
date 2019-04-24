//
//  HBMyAssetCurrencyModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetCurrencyModel.h"

@implementation HBMyAssetCurrencyModel

- (BOOL)canExchange {
    return self.exchange_switch == 1;
}

- (BOOL)canRecharge {
    return self.recharge_switch == 1;
}

- (BOOL)canRelease {
    return self.release_switch == 1;
}

- (BOOL)canTake {
    return self.take_switch == 1;
}

- (BOOL)canReleaseOfAward {
    return self.release_switch_award == 1;
}

@end
