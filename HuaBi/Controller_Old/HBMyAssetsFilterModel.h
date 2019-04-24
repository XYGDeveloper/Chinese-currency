//
//  HBMyAssetsFilterModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBMyAssetsFilterModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;

+ (instancetype)createAllModel;

@end

NS_ASSUME_NONNULL_END
