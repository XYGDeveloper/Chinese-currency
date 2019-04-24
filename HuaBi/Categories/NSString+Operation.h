//
//  NSString+Operation.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Operation)

+ (NSDecimalNumberHandler *)decimalNumberHandlerByScale:(NSInteger)scale;

- (NSString *)resultByDividingByNumber:(NSString *)text roundingScale:(NSInteger)scale;

- (NSString *)resultByDividingByNumber:(NSString *)text;

- (NSString *)resultByMultiplyingByNumber:(NSString *)text;

- (NSString *)resultByAddingByNumber:(NSString *)text;

- (NSDecimalNumber *)toDecimalNumber;


- (NSString *)roundWithScale:(NSInteger)scale;

- (NSString *)rouningDownByScale:(NSInteger)scale;

- (NSString *)resultBySubtractingByNumber:(NSString *)text;

- (NSString *)_addPreCNYSymbol;
- (NSString *)_addPrefix:(NSString *)prefix;

- (NSString *)_addSuffix:(NSString *)suffix;

- (NSString *)_addPrefixCurrentCurrencySymbol;

- (NSString *)_addSuffixCurrentCurrency;

@end

NS_ASSUME_NONNULL_END
