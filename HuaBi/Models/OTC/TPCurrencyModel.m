//
//  TPCurrencyModel.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPCurrencyModel.h"

@implementation TPCurrencyModel


+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"currencyID" :@"currency_id",
             @"currencyName" :@"currency_name"
             };
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.currencyID = [aDecoder decodeObjectForKey:@"currencyID"];
        self.currencyName = [aDecoder decodeObjectForKey:@"currencyName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.currencyName forKey:@"currencyName"];
    [aCoder encodeObject:self.currencyID forKey:@"currencyID"];
}




@end
