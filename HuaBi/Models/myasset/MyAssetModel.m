//
//  MyAssetModel.m
//  YJOTC
//
//  Created by l on 2018/9/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyAssetModel.h"
#import "HBUserDefaults.h"

@implementation sumModel

- (NSString *)currentCurrencyPrice {
    if ([[HBUserDefaults getCurrentCurrency] isEqualToString:kCNY]) {
        return self.cny;
    } else if ([[HBUserDefaults getCurrentCurrency] isEqualToString:kUSD]) {
        return self.usd;
    }
    return nil;
}

@end

@implementation current_userModel

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

- (BOOL)shouldShowTips {
    
    if ([self canExchange] && [self canRecharge] && [self canRelease] && [self canTake]) {
        if ([self.currency_name isEqualToString:@"KOK"] && ![self canReleaseOfAward]) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (NSString *)tipsMessage {
    NSMutableString *result = @"".mutableCopy;
    if (![self shouldShowTips]) {
        return nil;
    }
    if (![self canExchange]) {
        NSString *msg = [NSString stringWithFormat:@"%@ %@\n",self.currency_mark ?: @"", kLocat(@"Has_been_suspended_in_exchange")];
        [result appendString:msg];
    }
    if (![self canRecharge]) {
       
        NSString *msg = [NSString stringWithFormat:@"%@ %@\n",self.currency_mark ?: @"", kLocat(@"Has_been_suspended_in_recharge")];
        [result appendString:msg];
    }
    if (![self canRelease]) {
        
        NSString *msg = [NSString stringWithFormat:@"%@ %@\n",self.currency_mark ?: @"", kLocat(@"Has_been_suspended_in_release")];
        [result appendString:msg];
    }
    if (![self canTake]) {
        
        NSString *msg = [NSString stringWithFormat:@"%@ %@\n",self.currency_mark ?: @"", kLocat(@"Has_been_suspended_in_take")];
        [result appendString:msg];
    }
    
    if (![self canReleaseOfAward]) {
        
       NSString *msg = [NSString stringWithFormat:@"%@ %@\n",self.currency_mark ?: @"", kLocat(@"Has_been_suspended_in_release_award")];
        [result appendString:msg];
    }
    
    return result;
}

@end

@implementation u_infoModel

@end


@implementation MyAssetModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"currency_user" : @"current_userModel",
             @"sum" : @"sumModel",
             };
}
@end
