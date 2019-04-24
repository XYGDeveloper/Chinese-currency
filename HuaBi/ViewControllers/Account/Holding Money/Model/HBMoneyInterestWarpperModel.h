//
//  HBMoneyInterestWarpperModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBMoneyInterestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBMoneyInterestInfoModel : NSObject

@property (nonatomic ,copy)NSString * feature;
@property (nonatomic ,copy)NSArray<NSString *> *advantage;

@end

@interface HBMoneyInterestWarpperModel : NSObject

@property (nonatomic, strong) NSArray<HBMoneyInterestModel *> *currency_setting;
@property (nonatomic, strong) HBMoneyInterestInfoModel *info;

@end

NS_ASSUME_NONNULL_END
