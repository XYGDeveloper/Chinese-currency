//
//  HBKlineInfoHeaderView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBKlineInfoHeaderView.h"
#import "YTData_listModel.h"
#import "NSString+Operation.h"

@interface HBKlineInfoHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usdLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeOf24HLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *minNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfChangeOf24HLabel;
@property (weak, nonatomic) IBOutlet UILabel *minNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;


@end

@implementation HBKlineInfoHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = kThemeColor;
    self.maxLabel.text = kLocat(@"k_line_max");
    self.minNameLabel.text = kLocat(@"k_line_min");
    self.volumeLabel.text = kLocat(@"k_line_amout");
}

- (void)configViewWithCurrencyMessage:(id)currencyMessage {
    
    ListModel *model = [ListModel mj_objectWithKeyValues:currencyMessage];
    
    self.priceLabel.text =  model.price;
    self.priceLabel.textColor = model.statusColor;
    NSString *currencyPrice = [model.price_current_currency _addSuffixCurrentCurrency];
    self.usdLabel.text =  [currencyPrice _addPrefix:@"≈"];
    self.changeOf24HLabel.text = [NSString stringWithFormat:@"%@%%", model.H24_change];
    self.changeOf24HLabel.textColor = self.priceLabel.textColor;
    self.maxNumberLabel.text = model.max_price;
    self.minNumberLabel.text = model.min_price;
    self.numberOfChangeOf24HLabel.text = model.H24;
}

@end
