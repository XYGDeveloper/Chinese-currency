//
//  HBResumeModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBIconInfoModel : NSObject

@property (nonatomic, copy) NSString *china_name;
@property (nonatomic, copy) NSString *english_short;
@property (nonatomic, copy) NSString *english_name;
@property (nonatomic, copy) NSString *release_date;
@property (nonatomic, copy) NSString *raise_price;
@property (nonatomic, copy) NSString *daibi_turnover;
@property (nonatomic, copy) NSString *feature;
@property (nonatomic, copy) NSString *total_circulation;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *white_paper;
@property (nonatomic, copy) NSString *block_query;

@property (nonatomic, copy, readonly) NSString *name;

@end

NS_ASSUME_NONNULL_END
