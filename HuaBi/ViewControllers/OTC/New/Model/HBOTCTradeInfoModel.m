//
//  HBOTCTradeInfoModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/15.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCTradeInfoModel.h"

@implementation HBOTCTradeInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"bank_list" : @"HBOTCTradeBankModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"banks" : @"bank",
             };
}

- (UIColor *)statusColor {
    switch (self.allege_status) {
        case 0:
            return kColorFromStr(@"#E96E44");
            break;
        case 1:
            return kColorFromStr(@"#03C086");
            break;
        default:
            return kColorFromStr(@"#DEE5FF");
            break;
    }
}


- (NSString *)moneyTypeString {
    if ([self.money_type isEqualToString:kZFB]) {
        return kLocat(@"k_popview_select_payalipay");
    }else if ([self.money_type isEqualToString:kWechat]){
        return kLocat(@"k_popview_select_paywechat");
    }else if([self.money_type isEqualToString:kYHK]){
        return kLocat(@"k_popview_select_paybank");
    }else{
        return kLocat(@"OTC_order_nochoose");
    }
}

- (NSString *)sellerOrBuyerString {
    return self.isTypeOfBuy ? kLocat(@"OTC_Seller") : kLocat(@"OTC_Buyer");
}

- (BOOL)isTypeOfBuy {
    return [self.type isEqualToString:@"buy"];
}

- (NSString *)moneyTypeIconString {
    if ([self.money_type isEqualToString:kZFB]) {
        return @"gmxq_icon_zfb";
    }else if ([self.money_type isEqualToString:kWechat]){
        return @"gmxq_icon_wx";
    }else if([self.money_type isEqualToString:kYHK]){
        return @"gmxq_icon_yhk";
    }else{
        return nil;
    }
}

@end
