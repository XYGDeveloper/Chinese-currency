//
//  HBSubscribeModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HBSubscribeModelStatus) {
    HBSubscribeModelStatusComingSoon = 0,
    HBSubscribeModelStatusCrowdfunding = 1,
    HBSubscribeModelStatusDone = 2,
    HBSubscribeModelStatusCancel = 3,
};

@interface HBSubscribeModel : NSObject

@property (nonatomic ,copy)NSString * ID;
@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * num;
@property (nonatomic ,copy)NSString * price;
@property (nonatomic ,copy)NSString * deal;
@property (nonatomic ,copy)NSString * ctime;
@property (nonatomic ,copy)NSString * money;
@property (nonatomic ,assign)HBSubscribeModelStatus status;
@property (nonatomic ,copy)NSString * min_limit;
@property (nonatomic ,copy)NSString * limit;
@property (nonatomic ,copy)NSString * limit_count;
@property (nonatomic ,copy)NSString * title;
@property (nonatomic ,copy)NSString * info;
@property (nonatomic ,copy)NSString * url1;
@property (nonatomic ,copy)NSString * url2;
@property (nonatomic ,copy)NSString * url3;
@property (nonatomic ,copy)NSString * num_nosell;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * release_time;
@property (nonatomic ,copy)NSString * end_time;
@property (nonatomic ,copy)NSString * release_bili;
@property (nonatomic ,copy)NSString * zhongchou_success_bili;
@property (nonatomic ,copy)NSString * buy_currency_id;
@property (nonatomic ,copy)NSString * is_forzen;
@property (nonatomic ,copy)NSString * sort;
@property (nonatomic ,copy)NSString * admin_num;
@property (nonatomic ,copy)NSString * admin_deal;
@property (nonatomic ,copy)NSString * name;
@property (nonatomic ,copy)NSString * logo;
@property (nonatomic ,copy)NSString  *bl;
@property (nonatomic ,copy)NSString *peoples;
@property (nonatomic ,copy)NSString *website;
@property (nonatomic ,copy)NSString *white_paper;
@property (nonatomic ,copy)NSString * buy_name;

@property (nonatomic, copy, readonly) NSString *statusString;
@property (nonatomic, strong, readonly) UIColor *statusColor;
@property (nonatomic, copy, readonly) NSString *priceAndCurrency;
@property (nonatomic, copy, readonly) NSString *blAndPrecent;

@end

NS_ASSUME_NONNULL_END
