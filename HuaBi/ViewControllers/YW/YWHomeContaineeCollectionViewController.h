//
//  YWHomeContaineeCollectionViewController
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeCanScrollConatineeProtocol.h"



static NSInteger sizeOfPage = 10;

@class HBShopGoodModel, HBShopCategoryModel;
@interface YWHomeContaineeCollectionViewController : UICollectionViewController <YWHomeCanScrollConatineeProtocol>

@property (nonatomic, strong) HBShopCategoryModel *categoryModel;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) NSArray<HBShopGoodModel *> *models;

@property (nonatomic, assign) BOOL isCommended;

@property (nonatomic, copy) HomeContaineeVCRequestDidCompleteBlock requestDidComplete;

- (void)refresh;

@end
