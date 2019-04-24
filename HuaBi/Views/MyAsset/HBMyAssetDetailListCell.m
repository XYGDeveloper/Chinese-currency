
//
//  HBMyAssetDetailListCell.m
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetDetailListCell.h"
#import "FinModel.h"

@interface HBMyAssetDetailListCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inoutLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end





@implementation HBMyAssetDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //#0B132A
    self.selectionStyle = 0;
    self.contentView.backgroundColor = [UIColor colorWithRed:0.09 green:0.12 blue:0.20 alpha:1.00];
    _bgView.backgroundColor = [UIColor colorWithRed:0.05 green:0.08 blue:0.16 alpha:1.00];
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    
    _typeLabel.textColor = kColorFromStr(@"#7582A4");
    _typeLabel.font = PFRegularFont(14);
    
    _timeLabel.textColor = kColorFromStr(@"#DEE5FF");
    _timeLabel.font = PFRegularFont(14);
    
    _statusLabel.textColor = kColorFromStr(@"#DEE5FF");
    _statusLabel.font = PFRegularFont(14);
    
    _volumeLabel.textColor = kColorFromStr(@"#DEE5FF");
    _volumeLabel.font = PFRegularFont(14);

    _status.textColor = kColorFromStr(@"#7582A4");
    _status.font = PFRegularFont(12);
    _time.textColor = kColorFromStr(@"#7582A4");
    _time.font = PFRegularFont(12);
    
    
    _status.text = kLocat(@"");
    _time.text = kLocat(@"Assert_detail_dealtime");
    
    
    
    
    _inoutLabel.textColor = kColorFromStr(@"#03C086");
    _inoutLabel.font = PFRegularFont(12);
    _inoutLabel.text = kLocat(@"k_FinsetViewController_type6");
    
    //支出 #E96E44  收入03C086 k_FinsetViewController_type7
    
}

- (void)refreshWithModel:(FinModel *)model{
    if ([model.operation intValue] == IncomeAndExpenditureTypeIncome) {
        self.inoutLabel.text = kLocat(@"k_FinsetViewController_type6");
        self.inoutLabel.textColor = kColorFromStr(@"#03C086");
    }else{
        self.inoutLabel.text = kLocat(@"k_FinsetViewController_type7");
        self.inoutLabel.textColor = kColorFromStr(@"#E96E44");
    }
    self.volumeLabel.text = model.amount;
    self.status.text = kLocat(@"k_popview_input_branchbank_confirm_orderstatus");
    self.statusLabel.text = model.currency_field_text;
    self.time.text = kLocat(@"Assert_detail_dealtime");
    self.timeLabel.text = [Utilities timestampSwitchTime:[model.create_time intValue] andFormatter:@"HH:mm MM/dd"];
    self.typeLabel.text = model.type_text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
