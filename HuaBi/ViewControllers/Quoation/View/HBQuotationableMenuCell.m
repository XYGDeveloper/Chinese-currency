//
//  HBQuotationableMenuCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBQuotationableMenuCell.h"
#import "YTData_listModel.h"

@interface HBQuotationableMenuCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;


@end

@implementation HBQuotationableMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = kThemeColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.nameLabel.text = nil;
    self.priceLabel.text = nil;
    self.changeLabel.text = nil;
}

- (void)setModel:(ListModel *)model {
    _model = model;
    
    self.nameLabel.text = model.currency_mark;
    self.priceLabel.text = model.price;
    self.priceLabel.textColor = model.statusColor;
    self.changeLabel.text = model.change24String;
    self.changeLabel.textColor = model.statusColor;
}

@end
