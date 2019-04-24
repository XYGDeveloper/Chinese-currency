//
//  NSString+FloatPreciseCalculation.m
//  FloatPreciseCalculation
//
//  Created by Rainy on 2018/3/23.
//  Copyright © 2018年 WealthOnline_iOS_team. All rights reserved.
//

#import "NSString+FloatPreciseCalculation.h"
#import "NSString+Operation.h"

@implementation NSString (FloatPreciseCalculation)

+ (NSString *)floatOne:(NSString *)floatOne
       calculationType:(CalculationType)calculationType
              floatTwo:(NSString *)floatTwo
{
    if ([floatOne isEqualToString:@""] || [floatOne isKindOfClass:[NSNull class]]) {
        floatOne = @"0";
    }
    if ([floatTwo isEqualToString:@""]) {
        floatTwo = @"0";
    }
    
    
    NSDecimalNumber *_floatOne = [NSDecimalNumber decimalNumberWithString:floatOne];
    NSDecimalNumber *_floatTwo = [NSDecimalNumber decimalNumberWithString:floatTwo];
    
    NSDecimalNumber *results = nil;
    
    switch (calculationType) {
        case 0:
        {
            results = [_floatOne decimalNumberByAdding:_floatTwo];
        }
            break;
        case 1:
        {
            results = [_floatOne decimalNumberBySubtracting:_floatTwo];
        }
            break;
        case 2:
        {
            results = [_floatOne decimalNumberByMultiplyingBy:_floatTwo];
        }
            break;
        case 3:
        {
            results = [_floatOne decimalNumberByDividingBy:_floatTwo];
        }
            break;
            
        default:
            break;
    }
    
    return results.stringValue;
}

- (NSString *)getAddFactor {
    return [self getFactor];
}

- (NSString *)getMinusFactor {
    NSString *factor = [self getFactor];
    return  [NSString stringWithFormat:@"-%@", factor];
}

- (NSString *)getFactor {
    NSString *text = self;
    NSArray<NSString *> *array = [text componentsSeparatedByString:@"."];
    double factor = 1;
    if (array.count > 1) {
        NSInteger count = array.lastObject.length;
        factor = 1. / pow(10, count);
    }
    
    return [NSString stringWithFormat:@"%@", @(factor)];
}

- (NSInteger)getCountOfDecimal {
    NSArray<NSString *> *array = [self componentsSeparatedByString:@"."];

    if (array.count > 1) {
        return array.lastObject.length;
    } else {
        return 0;
    }
}

- (NSDecimalNumberHandler *)decimalNumberHandler {
    return [NSString decimalNumberHandlerByScale:[self getCountOfDecimal]];
}

@end
