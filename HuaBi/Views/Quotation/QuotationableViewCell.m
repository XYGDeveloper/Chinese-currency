//
//  QuotationableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "QuotationableViewCell.h"
#import "YTData_listModel.h"
#import "NSString+Operation.h"

@implementation QuotationableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.headImg.layer.cornerRadius = 15;
//    self.headImg.layer.masksToBounds = YES;
//    self.endV.layer.cornerRadius = 4;
//    self.endV.layer.masksToBounds = YES;
    // Initialization code
}

- (void)refreshWithModel:(ListModel *)model currencyName:(NSString *)currencyName{
//    [self.headImg setImageWithURL:[NSURL URLWithString:model.currency_logo] placeholder:[UIImage imageNamed:@""]];
    self.currName.text = model.currency_mark;
    self.currName.font = [PFRegularFont(16) fontWithBold];
    self.currName.adjustsFontSizeToFitWidth = YES;
    self.coinType.text = [NSString stringWithFormat:@"/%@",currencyName];
    self.topV.text = model.price;
    self.topV.font = [PFRegularFont(16) fontWithBold];
    self.h24Label.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"k_line_amout"),model.done_num_24H];
    self.endV.text = model.change24String;
    self.bottomV.text = [model.price_current_currency _addPrefixCurrentCurrencySymbol];
    self.endV.backgroundColor = model.statusColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
