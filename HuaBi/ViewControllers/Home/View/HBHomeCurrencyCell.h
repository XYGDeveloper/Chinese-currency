//
//  HBHomeCurrencyCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ListModel;


typedef void (^HBHomeCurrencyCellQuotationDidSelectBlock)(ListModel *model);

@interface HBHomeCurrencyCell : UITableViewCell

@property (nonatomic, copy)  NSArray<ListModel *> *quotations;
@property (weak, nonatomic) IBOutlet UIStackView *stack0;
@property (weak, nonatomic) IBOutlet UIStackView *stack1;

@property (weak, nonatomic) IBOutlet UIStackView *stack2;


@property (nonatomic,strong)HBHomeCurrencyCellQuotationDidSelectBlock quotationDidSelectBlock;

@end

NS_ASSUME_NONNULL_END
