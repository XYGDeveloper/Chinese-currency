//
//  BCBitemTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BCBitemTableViewCell.h"
#import "C2cModel.h"
@implementation BCBitemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)refreshWithModel:(order_sellModel *)model{
    
    self.label1.text = model.phone;
    self.label2.text = model.number;
    if ([model.type isEqualToString:@"1"]) {
        self.label3.text = kLocat(@"k_bcbViewController_sellin");
    }else{
        self.label3.text = kLocat(@"k_bcbViewController_sellout");
    }
    self.label4.text = kLocat(@"k_bcbViewController_dd");
    
}

- (void)refreshWithModel1:(order_buyModel *)model{
    
    self.label1.text = model.phone;
    self.label2.text = model.number;
    if ([model.type isEqualToString:@"1"]) {
        self.label3.text = kLocat(@"k_bcbViewController_sellin");
    }else{
        self.label3.text = kLocat(@"k_bcbViewController_sellout");
    }
    self.label4.text = kLocat(@"k_bcbViewController_dd");
    
}

@end
