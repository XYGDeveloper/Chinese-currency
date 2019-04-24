//
//  NSDictionary+HBWrapperParameters.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/13.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (HBWrapperParameters)

+ (NSDictionary *)_wrappedParametersFor:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
