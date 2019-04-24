//
//  TPOTCBuyListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyListCell.h"

@interface TPOTCBuyListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;

@end

@implementation TPOTCBuyListCell


-(void)setModel:(TPOTCOrderModel *)model
{
    _model = model;
    
    if (_isProfile) {
        _name.text = @"";
        if (model.name.length > 1) {
            _name.text = [model.currencyName substringWithRange:NSMakeRange(0, 1)];
        } else {
            _name.text = @"";
        }
        _nameLabel.text = model.currencyName;
        _infoLabel.text = @"";
        _name.hidden = YES;
        [_currencyImageView setImageURL:[NSURL URLWithString:model.currency_logo]];
    }else{
      
        if (model.name.length == 0) {
            _name.text = @"";
        }else{
            _name.text = [model.name substringWithRange:NSMakeRange(0, 1)];
        }
        _nameLabel.text = model.name;
        
        _infoLabel.text = [NSString stringWithFormat:@"%@ %@丨%@ %@%%",kLocat(@"Deal"),model.trade_allnum,kLocat(@"OTC_view_dealrate"),model.evaluate_num];
    }

    
    
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ CNY",model.price];
    
    _limitLabel.text = [NSString stringWithFormat:@"%@ %@-%@ CNY",kLocat(@"OTC_view_limtesum"),model.min_money,model.max_money];
    _volumeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"k_HBTradeJLViewController_count"),model.avail,model.currencyName];
    
    
    BOOL isShowAlipay = [model.money_type containsObject:kZFB];
    BOOL isShowWechatpay = [model.money_type containsObject:kWechat];
    BOOL isShowBank = [model.money_type containsObject:kYHK];
    
    self.alipayImageView.hidden = !isShowAlipay;
    self.wechatImageView.hidden = !isShowWechatpay;
    self.bankImageView.hidden = !isShowBank;

//    "OTC_main_buy" = "購買";
//    "OTC_main_sell" = "出售";
    NSString *titleOfOperationButton = [model.type isEqualToString:@"sell"] ? kLocat(@"OTC_main_buy") : kLocat(@"OTC_main_sell");
    
    [self.operationButton setTitle:titleOfOperationButton forState:UIControlStateNormal];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");
    self.lineView.backgroundColor = kThemeBGColor;
    _topView.backgroundColor = kColorFromStr(@"0B132A");
    self.priceNameLabel.text = kLocat(@"OTC_sinleprice");

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (IBAction)operateAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buyListCell:didSelectModel:)]) {
        [self.delegate buyListCell:self didSelectModel:_model];
    }
}
@end
