//
//  HBMyAssetReleaseController.h
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBMyAssetReleaseController : YJBaseViewController
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,copy)NSString * currencyID;
@property(nonatomic,copy)NSString * currencyName;
@property (nonatomic, assign) BOOL isPresentation;//是否为赠送释放

@end

NS_ASSUME_NONNULL_END
