
//
//  TPOTCOrderListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCOrderListCell.h"

@implementation TPOTCOrderListCell



-(void)setModel:(TPOTCTradeListModel *)model
{
    _model = model;
    if (model.username.length > 1) {
        _name.text = [model.username substringWithRange:NSMakeRange(0, 1)];
    } else {
        _name.text = @"";
    }
    _nameLabel.text = model.username;
    
    _timeLbel.text = model.add_time;
    
    _statusLabel.text = model.status_txt;
    
    if ([model.type isEqualToString:@"buy"]) {
        
        _currencyNameLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_main_buy"),model.currency_name];
    }else{
        _currencyNameLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_main_sell"),model.currency_name];
    }
    
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ CNY",model.money];
    
   // 0未付款 1已付款 2已取消 3已完成 4申诉中
//0未付款 1待放行 2申诉中 3已完成 4已取消
    if (model.allege_status == -1) {
        switch (model.status.intValue) {
            case 0:
                _statusLabel.textColor = kColorFromStr(@"#17FF69");
                break;
            case 1:
                _statusLabel.textColor = kColorFromStr(@"#EA6E44");
                break;
            case 2:
                _statusLabel.textColor = kColorFromStr(@"#7458ED");
                break;
            case 3:
                _statusLabel.textColor = kColorFromStr(@"#CDD2E3");
                break;
            case 4:
                _statusLabel.textColor = kColorFromStr(@"#707589");
                break;
            default:
                break;
        }
    } else {
        switch (model.allege_status) {
            case 0:
                _statusLabel.textColor = kColorFromStr(@"#EA6E44");
                break;
            case 1:
                _statusLabel.textColor = kColorFromStr(@"#17FF69");
                break;
            default:
                break;
        }
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");
    
    
    _name.textColor = kLightGrayColor;
    _name.font = PFRegularFont(14);
    
    _nameLabel.textColor = kLightGrayColor;
    _nameLabel.font = PFRegularFont(14);
    
    _timeLbel.textColor = kDarkGrayColor;
    _timeLbel.font = PFRegularFont(12);
    
    _currencyNameLabel.textColor = kDarkGrayColor;
    _currencyNameLabel.font = PFRegularFont(12);
    
    _priceLabel.textColor = kLightGrayColor;
    _priceLabel.font = PFRegularFont(18);
    
    _statusLabel.textColor = kLightGrayColor;
    _statusLabel.font = PFRegularFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
