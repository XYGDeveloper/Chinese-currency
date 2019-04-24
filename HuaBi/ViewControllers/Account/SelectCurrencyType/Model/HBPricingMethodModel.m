
//
//  HBCurrencyTypeModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBPricingMethodModel.h"
#import "HBUserDefaults.h"

@implementation HBPricingMethodModel

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@(%@)", self.name, self.currencyString];
}

- (BOOL)isSelected {
    NSString *selectedCurrency = [HBPricingMethodModel _selectedCurrencyString];
    return [self.currencyString isEqualToString:selectedCurrency];
}

- (void)setSelected:(BOOL)isSelected {
    if (isSelected) {
        [HBUserDefaults setCurrentCurrency:self.currencyString];
    }
}

+ (NSArray<HBPricingMethodModel *> *)allModels {
    HBPricingMethodModel *cnyModel = [HBPricingMethodModel new];
    cnyModel.name = kLocat(@"HBSelectCurrencyTypeTableViewController.Renminbi");
    cnyModel.currencyString = kCNY;

    HBPricingMethodModel *usdModel = [HBPricingMethodModel new];
    usdModel.name = kLocat(@"HBSelectCurrencyTypeTableViewController.Usd");
    usdModel.currencyString = kUSD;
    return @[cnyModel, usdModel];
}

+ (NSString *)_selectedCurrencyString {
    NSString *selectedCurrencyString = [HBUserDefaults getCurrentCurrency];
    return selectedCurrencyString;
}

@end
