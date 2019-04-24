//
//  HBCardTableViewCell.m
//  HuaBi
//
//  Created by l on 2019/2/26.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBCardTableViewCell.h"

@implementation HBCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = kLocat(@"HBHomeViewController_address_alert_title");
    self.detailLabel.text = kLocat(@"HBHomeViewController_address_alert_detail");
    [self.mButton setTitle:kLocat(@"HBHomeViewController_address_alert_miaodong") forState:UIControlStateNormal];
    [self.kefuButton setTitle:kLocat(@"HBHomeViewController_address_alert_kefu") forState:UIControlStateNormal];
    
}

- (IBAction)LeftAction:(id)sender {
    if (self.leftMen) {
        self.leftMen();
    }
}
- (IBAction)rightTopAction:(id)sender {
    if (self.topMenu) {
        self.topMenu();
    }
}

- (IBAction)rightBottomAction:(id)sender {
    if (self.bottomMenu) {
        self.bottomMenu();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
