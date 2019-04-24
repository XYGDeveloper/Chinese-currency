//
//  HBCountryCodeModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBCountryCodeModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *countrycode;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
