//
//  HBHomeShortcutMenuCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HBHomeShortcutMenuCellType) {
    HBHomeShortcutMenuCellTypeSubscription = 0,
    HBHomeShortcutMenuCellTypeKOK = 1,
    HBHomeShortcutMenuCellTypeInvite = 2,
    HBHomeShortcutMenuCellTypeMoneyInterest = 3,
    HBHomeShortcutMenuCellTypeC2C = 4,
};

@class HBHomeShortcutMenuCell;
@protocol HBHomeShortcutMenuCellDelegate <NSObject>

- (void)homeShortcutMenuCell:(HBHomeShortcutMenuCell *)cell selectedMenuType:(HBHomeShortcutMenuCellType)menuType;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HBHomeShortcutMenuCell : UITableViewCell

@property (nonatomic, weak) id<HBHomeShortcutMenuCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
