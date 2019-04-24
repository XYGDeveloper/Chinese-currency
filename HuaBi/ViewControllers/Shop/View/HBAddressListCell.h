//
//  HBAddressListCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBAddressListCell, HBMallAddressModel;
@protocol HBAddressListCellDelegate <NSObject>

- (void)addressListCell:(HBAddressListCell *)cell deleteWithModel:(HBMallAddressModel *)model;
- (void)addressListCell:(HBAddressListCell *)cell editWithModel:(HBMallAddressModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN
@class HBMallAddressModel;
@interface HBAddressListCell : UITableViewCell

@property (nonatomic, weak) id<HBAddressListCellDelegate> delegate;
@property (nonatomic, strong) HBMallAddressModel *model;

@end

NS_ASSUME_NONNULL_END
