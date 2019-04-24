
//
//  ICNNationalityModel.m
//  icn
//
//  Created by 周勇 on 2018/1/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ICNNationalityModel.h"

@implementation ICNNationalityModel

//+ (NSDictionary *)modelCustomPropertyMapper
//{
//    return @{@"countrycode" :@"phone_code"};
//}

- (NSString *)phone_code {
    return _phone_code ?: _countrycode;
}

- (BOOL)isChina {
    return [self.countrycode isEqualToString:@"86"];
}

@end
