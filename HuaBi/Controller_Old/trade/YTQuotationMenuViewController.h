//
//  YTQuotationMenuViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ListModel;
typedef void(^YTQuotationMenuViewControllerDidSelectModelBlock)(ListModel *model);

@interface YTQuotationMenuViewController : UIViewController

@property (nonatomic, copy) YTQuotationMenuViewControllerDidSelectModelBlock didSelectModelBlock;

+ (instancetype)fromStoryboard;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
