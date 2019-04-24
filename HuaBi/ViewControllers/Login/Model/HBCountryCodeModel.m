//
//  HBCountryCodeModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCountryCodeModel.h"

@implementation HBCountryCodeModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.countrycode forKey:@"countrycode"];
    [aCoder encodeObject:self.name forKey:@"name"];
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.countrycode = [aDecoder decodeObjectForKey:@"countrycode"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
