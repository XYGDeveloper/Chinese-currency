//
//  TPOTCADListMidCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCADListMidCell.h"


@interface TPOTCADListMidCell ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;


@end

@implementation TPOTCADListMidCell

-(void)setModel:(TPOTCMyADModel *)model
{
    _model = model;
//    _volumeLabel.text = model.num;
//    _priceLabel.text = model.price;
//    _totalMoney.text = model.money;
    
    _volumeLabel.text = ConvertToString(@(model.num.doubleValue));

    _priceLabel.text = ConvertToString(@(model.price.doubleValue));

    _totalMoney.text = ConvertToString(@(model.money.doubleValue));

    
//    _volumeLabel.text = model.num;
    

    
    
    
    
    if (model.money_type.count == 3) {
        _icon1.hidden = NO;
        _icon2.hidden = NO;
        _icon3.hidden = NO;
        _icon1.image = kImageFromStr(@"gmxq_icon_yhk");
        _icon2.image = kImageFromStr(@"gmxq_icon_zfb");
        _icon3.image = kImageFromStr(@"gmxq_icon_wx");
    }else if (model.money_type.count == 2){
        _icon1.hidden = YES;
        _icon2.hidden = NO;
        _icon3.hidden = NO;
        if (![model.money_type containsObject:kZFB]) {
            _icon2.image = kImageFromStr(@"gmxq_icon_yhk");
            _icon3.image = kImageFromStr(@"gmxq_icon_wx");
        }else if (![model.money_type containsObject:kWechat]){
            _icon2.image = kImageFromStr(@"gmxq_icon_yhk");
            _icon3.image = kImageFromStr(@"gmxq_icon_zfb");
        }else{
            _icon2.image = kImageFromStr(@"gmxq_icon_zfb");
            _icon3.image = kImageFromStr(@"gmxq_icon_wx");
        }
    }else{
        _icon1.hidden = YES;
        _icon2.hidden = NO;
        _icon3.hidden = YES;
        if ([model.money_type containsObject:kZFB]) {
            _icon2.image = kImageFromStr(@"gmxq_icon_zfb");
        }else if ([model.money_type containsObject:kWechat]){
            _icon2.image = kImageFromStr(@"gmxq_icon_wx");
        }else{
            _icon2.image = kImageFromStr(@"gmxq_icon_yhk");
        }
    }
    
 
//    _exchangeVolumeLabel.text = ConvertToString(@(model.trade_num.doubleValue));
//    _exchangeMoney.text = ConvertToString(@(model.trade_money.doubleValue));
//    _leftVolumeLabel.text = ConvertToString(@(model.avail.doubleValue));
//    _leftMoneyLabel.text = ConvertToString(@(model.avail_money.doubleValue));
    
    
        _exchangeVolumeLabel.text = model.trade_num;
        _exchangeMoney.text = model.trade_money;
        _leftVolumeLabel.text = model.avail;
        _leftMoneyLabel.text = model.avail_money;
    

    
}




- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");

    self.cancelButton.backgroundColor = kColorFromStr(@"#434A5D");
    self.cancelButton.titleLabel.font = PFRegularFont(13);
    [self.cancelButton setTitleColor:kColorFromStr(@"#9BBBEB") forState:UIControlStateNormal];
    
    _leftMargin.constant = 205 * kScreenWidthRatio;
    _midMargin.constant = 303 *kScreenWidthRatio;
    
    
    [_cancelButton setTitle:kLocat(@"OTC_view_cancelAd") forState:UIControlStateNormal];
    _label1.text = kLocat(@"OTC_view_exchangevolume");
    _label2.text = kLocat(@"Price");
    _label3.text = kLocat(@"k_popview_1");
    _label4.text = kLocat(@"OTC_view_sum");
    _label5.text = kLocat(@"OTC_view_exvolume");
    _label6.text = kLocat(@"OTC_view_exsum");
    _label7.text = kLocat(@"OTC_view_leftvolume");
    _label8.text = kLocat(@"OTC_view_leftsum");
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
