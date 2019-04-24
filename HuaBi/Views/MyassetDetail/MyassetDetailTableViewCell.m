//
//  MyassetDetailTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyassetDetailTableViewCell.h"

@implementation MyassetDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.bgview.layer.cornerRadius = 8; //设置imageView的圆角
//    self.bgview.userInteractionEnabled = YES;
    //    self.bgView.layer.masksToBounds = YES;
    self.bgview.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    self.bgview.layer.shadowOpacity = 0.4;//设置阴影的透明度
    self.bgview.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
    self.bgview.layer.shadowRadius = 3;//设置阴影的圆角
//    self.leftBtn.layer.cornerRadius = 8;
//    self.leftBtn.layer.masksToBounds = YES;
//    self.rightBtn.layer.cornerRadius = 8;
//    self.rightBtn.layer.masksToBounds = YES;
    self.moreButton.userInteractionEnabled = YES;
    self.plabel.text = kLocat(@"k_MyassetDetailViewController_tableview_header_middle");
    self.p2label.text = kLocat(@"k_MyassetDetailViewController_tableview_header_right");
//    [self.leftBtn setTitle:kLocat(@"k_MyassetDetailViewController_tableview_header_left_Button") forState:UIControlStateNormal];
//    [self.rightBtn setTitle:kLocat(@"k_MyassetDetailViewController_tableview_header_right_Button") forState:UIControlStateNormal];
    self.desLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_header_label");
    self.rlabel.text = kLocat(@"k_MyassetViewController_tableview_list_cell_right_label1");
    self.rblabel.text = kLocat(@"");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
