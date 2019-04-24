//
//  HBMyAssetDetailTopView.m
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetDetailTopView.h"
#import "MyAssetModel.h"

@interface HBMyAssetDetailTopView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *frozen;
@property (weak, nonatomic) IBOutlet UILabel *avi;
@property (weak, nonatomic) IBOutlet UILabel *lock;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *frozenLabel;

@property (weak, nonatomic) IBOutlet UILabel *awardLabel;
@property (weak, nonatomic) IBOutlet UILabel *award;


@property (weak, nonatomic) IBOutlet UILabel *aviLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end


@implementation HBMyAssetDetailTopView

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    current_userModel *currency_user = [current_userModel mj_objectWithKeyValues:_dataDic];
    
    _awardLabel.text = currency_user.num_award;
    _frozenLabel.text = currency_user.forzen_num;
    _sumLabel.text = currency_user.sum;
    _aviLabel.text = currency_user.num;
    _lockLabel.text = currency_user.lock_num;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = [UIColor colorWithRed:0.09 green:0.12 blue:0.20 alpha:1.00];
    _bgView.backgroundColor = [UIColor colorWithRed:0.18 green:0.21 blue:0.30 alpha:1.00];
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    
    _currencyName.textColor = kColorFromStr(@"#DFB900");
    _currencyName.font = PFRegularFont(23);
    
    _sum.textColor = kColorFromStr(@"#7582A4");
    _sum.font = PFRegularFont(12);
    
    _frozen.textColor = kColorFromStr(@"#7582A4");
    _frozen.font = PFRegularFont(12);
    
    _award.textColor = kColorFromStr(@"#7582A4");
    _award.font = PFRegularFont(12);
    
    _avi.textColor = kColorFromStr(@"#7582A4");
    _avi.font = PFRegularFont(12);
    
    _lock.textColor = kColorFromStr(@"#7582A4");
    _lock.font = PFRegularFont(12);
    
    
    
    _sumLabel.textColor = kColorFromStr(@"#DEE5FF");
    _sumLabel.font = PFRegularFont(12);
    
    _awardLabel.textColor = kColorFromStr(@"#DEE5FF");
    _awardLabel.font = PFRegularFont(12);
    
    _frozenLabel.textColor = kColorFromStr(@"#DEE5FF");
    _frozenLabel.font = PFRegularFont(12);
    
    _aviLabel.textColor = kColorFromStr(@"#DEE5FF");
    _aviLabel.font = PFRegularFont(12);
    
    _lockLabel.textColor = kColorFromStr(@"#DEE5FF");
    _lockLabel.font = PFRegularFont(12);
    _leftMargin.constant = 190 * kScreenWidthRatio;
    _currencyName.text = @"";
    
    _sum.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_label")];
    _frozen.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_right_label")];
    _avi.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_avali")];
    _lock.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_right_label1")];
    _award.text = [NSString stringWithFormat:@"%@:",kLocat(@"Award")];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
