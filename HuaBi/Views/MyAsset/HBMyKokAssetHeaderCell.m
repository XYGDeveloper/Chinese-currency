//
//  HBMyKokAssetHeaderCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/6.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyKokAssetHeaderCell.h"
#import "MyAssetModel.h"

@interface HBMyKokAssetHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;


//values
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *frozenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

//names
@property (weak, nonatomic) IBOutlet UILabel *sumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *frozenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardNameLabel;


@end

@implementation HBMyKokAssetHeaderCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sumNameLabel.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_label")];
    self.availableNameLabel.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_avali")];
    self.exchangeNameLabel.text = [NSString stringWithFormat:@"%@:",kLocat(@"Assert_detail_exchange")];
    self.frozenNameLabel.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_right_label")];
    self.lockNameLabel.text = [NSString stringWithFormat:@"%@:",kLocat(@"k_MyassetViewController_tableview_list_cell_right_label1")];
    self.awardNameLabel.text = [NSString stringWithFormat:@"%@:",kLocat(@"Award")];
    
    self.containerView.backgroundColor = [UIColor colorWithRed:0.18 green:0.21 blue:0.30 alpha:1.00];
}

#pragma mark - Setter

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    current_userModel *currency_user = [current_userModel mj_objectWithKeyValues:_dataDic];
    self.sumLabel.text = currency_user.sum;
    self.availableLabel.text = currency_user.num;
    self.frozenLabel.text = currency_user.forzen_num;
    self.lockLabel.text = currency_user.lock_num;
    self.exchangeLabel.text = currency_user.exchange_num;
    self.awardLabel.text = currency_user.num_award;
}
@end
