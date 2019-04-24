
//
//  TPOTCADDetailListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCADDetailListCell.h"

@interface TPOTCADDetailListCell ()

@property (weak, nonatomic) IBOutlet UIView *bottomSeparateLineView;


@end

@implementation TPOTCADDetailListCell


-(void)setModel:(TPOTCSingleOrderModel *)model
{
    _model = model;
    
    if (model.name.length > 1) {
        _name.text = [model.name substringWithRange:NSMakeRange(0, 1)];
    } else {
        _name.text = @"";
    }
    _nameLabel.text = model.name;
    
    _timeLabel.text = model.add_time;
    
    if ([_model.type isEqualToString:@"buy"]) {
        _currencyName.text = [NSString stringWithFormat:@"%@%@",kLocat(@"k_MyassetDetailViewController_wt_mr"),model.currency_name];
    }else{
        _currencyName.text = [NSString stringWithFormat:@"%@%@",kLocat(@"k_MyassetDetailViewController_wt_mc"),model.currency_name];
    }
    
    _statusLabel.text = model.status_txt;
    
    _cnyLabel.text = [NSString stringWithFormat:@"%@ CNY",model.money];
    
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
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");
    self.lineView.backgroundColor = kColorFromStr(@"#2C303C");

    
    self.name.textColor = kLightGrayColor;
    self.name.font = PFRegularFont(16);
    
    self.nameLabel.textColor = kLightGrayColor;
    self.nameLabel.font = PFRegularFont(16);
    
    self.timeLabel.textColor = kDarkGrayColor;
    self.timeLabel.font = PFRegularFont(12);
    
    self.currencyName.textColor = kDarkGrayColor;
    self.currencyName.font = PFRegularFont(12);
    
    self.cnyLabel.textColor = kLightGrayColor;
    self.cnyLabel.font = PFRegularFont(18);
    
//    self.statusLabel.textColor = kLightGrayColor;
    self.statusLabel.textColor = kOrangeColor;
    self.statusLabel.font = PFRegularFont(15);
    
    self.bottomSeparateLineView.backgroundColor = kThemeBGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
