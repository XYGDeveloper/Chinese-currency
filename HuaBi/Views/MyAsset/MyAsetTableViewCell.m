//
//  MyAsetTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyAsetTableViewCell.h"
#import "MyAssetModel.h"

@interface MyAsetTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *tipsButton;
@property (nonatomic, strong) current_userModel *model;

@end

@implementation MyAsetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.bgview.layer.cornerRadius = 8;
//    self.bgview.layer.masksToBounds = YES;
    self.sumLabel.text = kLocat(@"k_MyassetViewController_tableview_list_cell_middle_label");
    self.freezeLabel.text = kLocat(@"k_MyassetViewController_tableview_list_cell_right_label");
    self.availableLabel.text = kLocat(@"k_MyassetViewController_tableview_list_cell_middle_avali");
    // Initialization code
}

- (void)refreshWithModel:(current_userModel *)model{
    self.model = model;
    self.coinType.text = model.currency_name;
    self.sumContentLabel.text = model.sum;
    self.freezecontent.text = model.forzen_num;
    self.avaliableContentLabel.text = model.num;

    self.sumContentLabel.adjustsFontSizeToFitWidth = YES;
    self.freezecontent.adjustsFontSizeToFitWidth = YES;
    self.avaliableContentLabel.adjustsFontSizeToFitWidth = YES;
    
    self.tipsButton.hidden = ![model shouldShowTips];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action

- (IBAction)showTipsAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myAsetTableViewCell:showTipsWithModel:)]) {
        [self.delegate myAsetTableViewCell:self showTipsWithModel:self.model];
    }
}
@end
