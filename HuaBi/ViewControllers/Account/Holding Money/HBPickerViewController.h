//
//  HBPickerViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBPickerModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^HBPickerViewControllerDidSelectModelBlock)(id model);

@interface HBPickerViewController : UIViewController


@property (nonatomic, strong) NSArray<id<HBPickerModel>> *models;
@property (nonatomic, copy) HBPickerViewControllerDidSelectModelBlock didSelectModelBlock;

+ (instancetype)fromStoryboard;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
