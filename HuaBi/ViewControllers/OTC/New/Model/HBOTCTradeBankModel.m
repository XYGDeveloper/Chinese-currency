//
//  HBOTCTradeBankModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/16.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCTradeBankModel.h"

@implementation HBOTCTradeBankModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)bankTypeString {
    if ([self.bankname isEqualToString:kZFB]) {
        return kLocat(@"k_popview_select_payalipay");
    }else if ([self.bankname isEqualToString:kWechat]){
        return kLocat(@"k_popview_select_paywechat");
    }else if([self.bankname isEqualToString:kYHK]){
        return kLocat(@"k_popview_select_paybank");
    }else{
        return nil;
    }
}

- (NSString *)bankIconString {
    if ([self.bankname isEqualToString:kZFB]) {
        return @"gmxq_icon_zfb";
    }else if ([self.bankname isEqualToString:kWechat]){
        return @"gmxq_icon_wx";
    }else if([self.bankname isEqualToString:kYHK]){
        return @"gmxq_icon_yhk";
    }else{
        return nil;
    }
}

- (BOOL)isYHK {
    return [self.bankname isEqualToString:kYHK];
}

- (NSString *)last4CharactersOfCardNumber {
    NSString *result = self.cardnum;
    if (self.cardnum.length > 4) {
        result = [self.cardnum substringFromIndex:self.cardnum.length - 4];
    }
    
    return result;
}

@end
