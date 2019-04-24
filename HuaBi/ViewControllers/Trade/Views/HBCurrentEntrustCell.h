//
//  HBCurrentEntrustCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YTTradeUserOrderModel;
typedef void(^HBCurrentEntrustCellCancelBlock)(YTTradeUserOrderModel *model);

NS_ASSUME_NONNULL_BEGIN



@interface HBCurrentEntrustCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIStackView *statusStackView;

@property (nonatomic, strong) YTTradeUserOrderModel *model;
@property (nonatomic, copy) HBCurrentEntrustCellCancelBlock cancelBlock;

@end

NS_ASSUME_NONNULL_END
