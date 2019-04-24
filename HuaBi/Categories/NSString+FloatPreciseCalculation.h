//
//  NSString+FloatPreciseCalculation.h
//  FloatPreciseCalculation
//
//  Created by Rainy on 2018/3/23.
//  Copyright © 2018年 WealthOnline_iOS_team. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CalculationType) {
    
    CalculationTypeForAdd,        //加
    CalculationTypeForSubtract,   //减
    CalculationTypeForMultiply,   //乘
    CalculationTypeForDivide,     //除
};

@interface NSString (FloatPreciseCalculation)

+ (NSString *)floatOne:(NSString *)floatOne
       calculationType:(CalculationType)calculationType
              floatTwo:(NSString *)floatTwo;

- (NSString *)getAddFactor;

- (NSString *)getMinusFactor;


/**
 获取小数位

 @return 获取小数位
 */
- (NSInteger)getCountOfDecimal;

- (NSDecimalNumberHandler *)decimalNumberHandler;

@end
