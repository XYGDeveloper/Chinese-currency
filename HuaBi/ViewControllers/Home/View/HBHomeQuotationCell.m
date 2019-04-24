//
//  HBHomeQuotationCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeQuotationCell.h"
#import "NSString+Operation.h"
#import "YTData_listModel.h"

@interface HBHomeQuotationCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *currencyMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeCurrencyMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usdPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeOf24HLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDoneOf24HLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameChangeOf24HLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *change24WidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *rightValueLabel;

@property (nonatomic, assign) HBHomeQuotationCellStyle cellStyle;

@property (nonatomic, strong) ListModel *model;

@end

@implementation HBHomeQuotationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
    self.nameChangeOf24HLabel.text = kLocat(@"k_line_amout");
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.changeOf24HLabel.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    switch (self.cellStyle) {
        case HBHomeQuotationCellStyleDefault: {
            self.changeOf24HLabel.backgroundColor = [self.model statusColor];;
        }
            break;
            
        case HBHomeQuotationCellStyleOther:
            self.changeOf24HLabel.backgroundColor = [UIColor clearColor];
            break;
    }
    self.numberLabel.backgroundColor = kGreenColor;
}

#pragma mark - Setters

- (void)setModel:(ListModel *)model {
    
    
    self.currencyMarkLabel.text = model.currency_mark;
    self.tradeCurrencyMarkLabel.text = [NSString stringWithFormat:@"/%@", model.trade_currency_mark];
    self.priceLabel.text = model.price;
    self.usdPriceLabel.text = [model.price_current_currency _addPrefixCurrentCurrencySymbol];
    self.numberOfDoneOf24HLabel.text = model.done_num_24H ?: @"0";
    self.changeOf24HLabel.text = [NSString stringWithFormat:@"%@%@", model.inall, model.inall_symbol];
    self.rightValueLabel.text = [NSString stringWithFormat:@"%@%@", model.inall, model.inall_symbol];
    _model = model;
    
}

- (void)configWithModel:(ListModel *)model
              indexPath:(NSIndexPath *)indexPath
              cellStyle:(HBHomeQuotationCellStyle)cellStyle {
    
    self.model = model;
    self.numberLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row + 1)];
    self.cellStyle = cellStyle;
    switch (cellStyle) {
        case HBHomeQuotationCellStyleDefault: {
            self.rightValueLabel.hidden = YES;
            self.changeOf24HLabel.hidden = NO;
        }
            break;
            
        case HBHomeQuotationCellStyleOther: {
            self.rightValueLabel.hidden = NO;
            self.changeOf24HLabel.hidden = YES;
        }
            break;
    }
    
}

@end
