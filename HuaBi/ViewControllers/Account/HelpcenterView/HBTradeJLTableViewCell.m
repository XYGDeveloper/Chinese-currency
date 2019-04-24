//
//  HBTradeJLTableViewCell.m
//  HuaBi
//
//  Created by l on 2018/10/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBTradeJLTableViewCell.h"
#import "HBGetCListModel.h"
@implementation HBTradeJLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeLabel.text = kLocat(@"k_HBTradeJLViewController_time");
    self.typeLabel.text = kLocat(@"k_HBTradeJLViewController_type");
    self.numberLabel.text = kLocat(@"k_HBTradeJLViewController_number");
    self.countLabel.text = kLocat(@"k_HBTradeJLViewController_count");
    self.priceLabel.text = kLocat(@"k_HBTradeJLViewController_price");
    self.sumPriceLabel.text = kLocat(@"k_HBTradeJLViewController_sumprice");
    self.statusLabel.text = kLocat(@"k_HBTradeJLViewController_status");
    self.operationLabel.text = kLocat(@"k_HBTradeJLViewController_operation");
    [self.operationContent addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)refreshWithModel:(HBGetCListModel *)model{
    //
    self.timeContent.text = model.add_time;
    if ([model.type isEqualToString:@"1"]) {
        self.typeContent.text = [NSString stringWithFormat:@"%@%@/CNY",kLocat(@"k_TradeViewController_seg01"),model.currency_mark];
        self.typeContent.textColor = kColorFromStr(@"#03C086");
        [self.operationContent setTitle:kLocat(@"k_in_c2c_tips_payinfo") forState:UIControlStateNormal];
        [self.operationContent setTitleColor:kColorFromStr(@"#BD2D36") forState:UIControlStateNormal];
    }else{
        self.typeContent.text = [NSString stringWithFormat:@"%@%@/CNY",kLocat(@"k_TradeViewController_seg02"),model.currency_mark];
        self.typeContent.textColor = kColorFromStr(@"#E96E44");
        [self.operationContent setTitle:@"--" forState:UIControlStateNormal];
        [self.operationContent setTitleColor:kColorFromStr(@"#E96E44") forState:UIControlStateNormal];
    }
    self.numberContent.text = model.order_sn;
    self.countContent.text = model.number;
    self.priceContent.text = model.price;
    self.sumPriceContent.text = model.money;
    self.statusContent.text = model.orderStatus;
    self.statusContent.textColor = kColorFromStr(@"#4173C8");
    
}

- (void)payAction:(UIButton *)sender{
    if (self.pay) {
        self.pay();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
