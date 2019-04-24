//
//  HBShoppingCartItemCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/26.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class HBShopCartModel, HBShoppingCartItemCell;

@protocol HBShoppingCartItemCellDelegate <NSObject>

- (void)checkBoxChangedWithShoppingCartItemCell:(HBShoppingCartItemCell *)cell;

- (void)shoppingCartItemCell:(HBShoppingCartItemCell *)cell changedNumber:(NSInteger)number model:(HBShopCartModel *)model;

@end

@interface HBShoppingCartItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (nonatomic, strong) HBShopCartModel *model;

@property (nonatomic, weak) id<HBShoppingCartItemCellDelegate> delegate;

- (void)updateNumber;

@end

NS_ASSUME_NONNULL_END
