//
//  HBAddressDetailContaineeTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HBAddressDetailViewControllerType) {
    HBAddressDetailViewControllerTypeShow,
    HBAddressDetailViewControllerTypeEdit,
    HBAddressDetailViewControllerTypeAdd,
};

@class HBMallAddressModel;
@interface HBAddressDetailContaineeTableViewController : UITableViewController


- (void)configureWithModel:(HBMallAddressModel *)model type:(HBAddressDetailViewControllerType)type;

- (void)submit;

@end

NS_ASSUME_NONNULL_END
