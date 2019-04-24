//
//  HBMoneyInterestModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBPickerModelProtocol.h"

@class HBMoneyInterestModel;
NS_ASSUME_NONNULL_BEGIN
@interface HBMoneyInterestSettingModel : NSObject <HBPickerModel>

@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * months;
@property (nonatomic ,assign)double min_num;
@property (nonatomic ,assign)double max_num;
@property (nonatomic ,copy)NSString * rate;
@property (nonatomic ,copy)NSString * start_time;
@property (nonatomic ,copy)NSString * end_time;

@property (nonatomic, copy, readonly) NSString *rateOfPrecent;

@property (nonatomic, weak) HBMoneyInterestModel *interestModel;

- (NSString *)name;

/**
 检查转入数量是否有效

 @param number 转入数量
 @return 错误信息 为 nil 时表示有效。
 */
- (NSString *)errorMessageWithCheckTransferNumber:(NSString *)number;

@end


@interface HBMoneyInterestModel : NSObject

@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * currency_name;
@property (nonatomic ,strong)NSArray<HBMoneyInterestSettingModel *> * setting;
@property (nonatomic ,copy)NSString * user_num;

@property (nonatomic, copy, readonly) NSString *numAndCurrency;

@end

NS_ASSUME_NONNULL_END
