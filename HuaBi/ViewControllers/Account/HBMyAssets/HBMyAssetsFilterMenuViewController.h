//
//  HBMyAssetsFilterMenuViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBMyAssetsFilterModel;

typedef void(^HBMyAssetsFilterMenuViewControllerDidSelectModelBlock)(HBMyAssetsFilterModel *model);

@interface HBMyAssetsFilterMenuViewController : UIViewController

+ (instancetype)fromStoryboard;

@property (nonatomic, copy) HBMyAssetsFilterMenuViewControllerDidSelectModelBlock didSelectModelBlock;

- (void)show;

- (void)hide;


@end

