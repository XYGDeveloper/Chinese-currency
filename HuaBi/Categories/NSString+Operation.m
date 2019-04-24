//
//  NSString+Operation.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "NSString+Operation.h"
#import "HBUserDefaults.h"

@implementation NSString (Operation)

- (NSString *)resultByDividingByNumber:(NSString *)text roundingScale:(NSInteger)scale {
    if (!text || text.length == 0) {
        text = @"0";
        return @"0";
    }
    
    NSString *text1 = self;
    if (!text1 || text1.length == 0) {
        text1 = @"0";
        return @"0";
    }
    
    if ([text floatValue] == 0 || [text1 floatValue] == 0) {
        return @"0";
    }
    
    NSDecimalNumber *dn1 = [self toDecimalNumber];
    NSDecimalNumber *dn2 = [text toDecimalNumber];
    NSDecimalNumber *resultDN = [dn1 decimalNumberByDividingBy:dn2];
    if (scale > 0) {
        NSDecimalNumberHandler *roundingBehavior = [NSString decimalNumberHandlerByScale:scale];
        resultDN = [resultDN decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    }
    
    return resultDN.stringValue;
}
- (NSString *)resultByDividingByNumber:(NSString *)text {
    return [self resultByDividingByNumber:text roundingScale:0];
}

- (NSString *)resultByMultiplyingByNumber:(NSString *)text {
    if (!text || text.length == 0) {
        text = @"0";
    }
    
    NSString *text1 = self;
    if (!text1 || text1.length == 0) {
        text1 = @"0";
    }
    
    NSDecimalNumber *dn1 = [self toDecimalNumber];
    NSDecimalNumber *dn2 = [text toDecimalNumber];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                      scale:6
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    NSDecimalNumber *resultDN = [dn1 decimalNumberByMultiplyingBy:dn2];
    resultDN = [resultDN decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return resultDN.stringValue;
}

- (NSString *)resultBySubtractingByNumber:(NSString *)text {
    if (!text || text.length == 0) {
        text = @"0";
    }
    
    NSString *text1 = self;
    if (!text1 || text1.length == 0) {
        text1 = @"0";
    }
    
    NSDecimalNumber *dn1 = [self toDecimalNumber];
    NSDecimalNumber *dn2 = [text toDecimalNumber];
    NSDecimalNumberHandler *roundingBehavior = [NSString decimalNumberHandlerByScale:6];
    
    NSDecimalNumber *resultDN = [dn1 decimalNumberBySubtracting:dn2];
    resultDN = [resultDN decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return resultDN.stringValue;
}

- (NSString *)resultByAddingByNumber:(NSString *)text {
    if (!text || text.length == 0) {
        text = @"0";
    }
    
    NSString *text1 = self;
    if (!text1 || text1.length == 0) {
        text1 = @"0";
    }
    
    NSDecimalNumber *dn1 = [self toDecimalNumber];
    NSDecimalNumber *dn2 = [text toDecimalNumber];
    NSDecimalNumberHandler *roundingBehavior = [NSString decimalNumberHandlerByScale:6];
    
    NSDecimalNumber *resultDN = [dn1 decimalNumberByAdding:dn2];
    resultDN = [resultDN decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return resultDN.stringValue;
}

- (NSString *)rouningDownByScale:(NSInteger)scale {
    if (!self) {
        return nil;
    }
    
    NSDecimalNumber *dn = [self toDecimalNumber];
    NSDecimalNumberHandler *roundingBehavior = [NSString decimalNumberRoundDownHandlerByScale:6];
    dn = [dn decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return dn.stringValue;
}

+ (NSDecimalNumberHandler *)decimalNumberRoundDownHandlerByScale:(NSInteger)scale {
    return [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                  scale:scale
                                                       raiseOnExactness:NO
                                                        raiseOnOverflow:NO
                                                       raiseOnUnderflow:NO
                                                    raiseOnDivideByZero:NO];
}

+ (NSDecimalNumberHandler *)decimalNumberHandlerByScale:(NSInteger)scale {
    return [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                  scale:scale
                                                       raiseOnExactness:NO
                                                        raiseOnOverflow:NO
                                                       raiseOnUnderflow:NO
                                                    raiseOnDivideByZero:NO];
}

- (NSDecimalNumber *)toDecimalNumber {
    NSString *text = self;
    if (!text || text.length == 0) {
        text = @"0";
    }
    
    return [NSDecimalNumber decimalNumberWithString:text];
}



- (NSString *)roundWithScale:(NSInteger)scale {
     NSDecimalNumber *n = [self toDecimalNumber];
    NSDecimalNumberHandler *handler = [NSString decimalNumberHandlerByScale:scale];
    n = [n decimalNumberByRoundingAccordingToBehavior:handler];
    
    return n.stringValue;
}

- (NSString *)_addPreCNYSymbol {
    return [NSString stringWithFormat:@"￥%@", self ?: @""];
}

- (NSString *)_addSuffix:(NSString *)suffix {
    return [NSString stringWithFormat:@"%@ %@", self ?: @"", suffix ?: @""];
}

- (NSString *)_addPrefix:(NSString *)prefix {
    return [NSString stringWithFormat:@"%@%@", prefix ?: @"" , self ?: @""];
}

- (NSString *)_addPrefixCurrentCurrencySymbol {
    NSString *currentCurrency = [HBUserDefaults getCurrentCurrency];
    if ([currentCurrency isEqualToString:kUSD]) {
        return [self _addPrefix:@"$"];
    } else if ([currentCurrency isEqualToString:kCNY]) {
        return [self _addPrefix:@"￥"];
    }
    
    return self;
}
- (NSString *)_addSuffixCurrentCurrency {
    NSString *currentCurrency = [HBUserDefaults getCurrentCurrency];
    return [self _addSuffix:currentCurrency];
}

@end
