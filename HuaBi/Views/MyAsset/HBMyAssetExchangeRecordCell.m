//
//  HBMyAssetExchangeRecordCell.m
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetExchangeRecordCell.h"

@interface HBMyAssetExchangeRecordCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *volume;

@property (weak, nonatomic) IBOutlet UILabel *voulemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receive;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation HBMyAssetExchangeRecordCell


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _voulemeLabel.text = [NSString stringWithFormat:@"%@KOK",dataDic[@"money"]];
    _receiveLabel.text = ConvertToString(dataDic[@"tmember_id"]);
    _timeLabel.text = dataDic[@"time"];
    _nameLabel.text = dataDic[@"tname"];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kThemeBGColor;
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    _bgView.backgroundColor = [UIColor colorWithRed:0.05 green:0.08 blue:0.16 alpha:1.00];
    
    _volume.textColor = kColorFromStr(@"#7582A4");
    _volume.font = PFRegularFont(12);
    
    _voulemeLabel.textColor = kColorFromStr(@"#DEE5FF");
    _voulemeLabel.font = PFRegularFont(14);
    
    _name.textColor = kColorFromStr(@"#7582A4");
    _name.font = PFRegularFont(12);
    
    _nameLabel.textColor = kColorFromStr(@"#DEE5FF");
    _nameLabel.font = PFRegularFont(14);
    
    _receive.textColor = kColorFromStr(@"#7582A4");
    _receive.font = PFRegularFont(12);
    
    _receiveLabel.textColor = kColorFromStr(@"#DEE5FF");
    _receiveLabel.font = PFRegularFont(14);
    
    _time.textColor = kColorFromStr(@"#7582A4");
    _time.font = PFRegularFont(12);
    
    _timeLabel.textColor = kColorFromStr(@"#DEE5FF");
    _timeLabel.font = PFRegularFont(14);
    
    
    _volume.text = kLocat(@"k_HBTradeJLViewController_count");
    _receive.text = kLocat(@"Assert_detail_changeintoid");
    _name.text = kLocat(@"Assert_detail_name");
    _time.text = kLocat(@"Assert_detail_dealtime");
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
