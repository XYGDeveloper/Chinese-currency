//
//  HBShopCategoryModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/1.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBShopCategoryModel : NSObject

@property (nonatomic ,copy)NSString * cat_id;
@property (nonatomic ,copy)NSString * cat_name;
@property (nonatomic ,copy)NSString * keywords;
@property (nonatomic ,copy)NSString * cat_desc;
@property (nonatomic ,copy)NSString * parent_id;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * sort;
@property (nonatomic ,copy)NSString * status;
@property (nonatomic ,copy)NSString * image;
@property (nonatomic ,copy)NSArray<HBShopCategoryModel *> * list;


+ (instancetype)createRecommendCategoryModel;

@end

NS_ASSUME_NONNULL_END
