//
//  HBShopCategoryModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/1.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopCategoryModel.h"

@implementation HBShopCategoryModel

+ (instancetype)createRecommendCategoryModel {
    
    HBShopCategoryModel *model = [HBShopCategoryModel new];
    model.cat_id = @"-1";
    model.cat_name = @"推荐";
    return model;
}

@end
