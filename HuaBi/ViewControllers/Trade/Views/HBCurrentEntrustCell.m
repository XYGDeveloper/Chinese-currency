//
//  HBCurrentEntrustCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCurrentEntrustCell.h"
#import "YTTradeUserOrderModel.h"
#import "NSString+RemoveZero.h"

@interface HBCurrentEntrustCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showDoneImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberMarkLabel;

@end

@implementation HBCurrentEntrustCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
    self.contentView.backgroundColor = kThemeBGColor;
    
    self.timeNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_time");
    self.priceNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_wtj");
    self.numberNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_wtl");
    self.sumNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_wtze");
    self.averagePriceNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_cjjj");
    self.tradeNumberNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_cjl");
    
    [self.cancelButton setTitle:kLocat(@"k_TradeViewController_seg03") forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock(self.model);
    }
}

- (void)setModel:(YTTradeUserOrderModel *)model {
    _model = model;
    self.priceLabel.text = model.price;
    self.numberLabel.text = model.num;
    self.tradeNumberLabel.text = model.trade_num;
    self.sumLabel.text = model.totalMeney;
    self.averagePriceLabel.text = model.avgcPrice;
    NSString *key = [NSString stringWithFormat:@"%@_2", model.type];
    self.typeLabel.text = kLocat(key);
    self.typeLabel.textColor = [model typeColor];
    self.timeLabel.text = [Utilities returnTimeWithSecond:[model.add_time integerValue] formatter:@"HH:mm MM/dd"];
    self.statusLabel.text = model.statusString;
    self.showDoneImageView.hidden = ![model isDone];
    self.currencyNameLabel.text = model.comMarkName;
    
    self.priceMarkLabel.text = [NSString stringWithFormat:@"(%@)", model.trade_currency_mark];
    self.numberMarkLabel.text = [NSString stringWithFormat:@"(%@)", model.currenc_mark];
    self.sumMarkLabel.text = [NSString stringWithFormat:@"(%@)", model.trade_currency_mark];
    self.averagePriceMarkLabel.text = [NSString stringWithFormat:@"(%@)", model.trade_currency_mark];
    self.tradeNumberMarkLabel.text = [NSString stringWithFormat:@"(%@)", model.currenc_mark];;
}

@end
