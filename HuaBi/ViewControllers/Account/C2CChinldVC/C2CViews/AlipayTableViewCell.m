//
//  AlipayTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AlipayTableViewCell.h"
#import "PayModel.h"
@implementation AlipayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     [self.debutton setTitle:kLocat(@"k_c2c_now_default") forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)todel:(id)sender {
    if (self.del) {
        self.del();
    }
}

- (IBAction)tosetdefau:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (self.defau) {
        self.defau();
    }
}


- (void)refreshWithmodel:(AlipayModel *)model{
//    self.typeLabel.text = kLocat(@"k_PAYViewController_typea");
//    self.nameLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"k_PAYViewController_typea"),model.alipay];
//    if ([model.status isEqualToString:@"0"]) {
//        [self.debutton setImage:[UIImage imageNamed:@"c_normal"] forState:UIControlStateNormal];
//    }else{
//        [self.debutton setImage:[UIImage imageNamed:@"c_sele"] forState:UIControlStateSelected];
//    }
}

-(void)refreshWithWechatmodel:(WechatModel *)model{
//    self.typeLabel.text = kLocat(@"k_PAYViewController_typew");
//    self.nameLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"k_PAYViewController_typew"),model.wechat];
//    if ([model.status isEqualToString:@"0"]) {
//        [self.debutton setImage:[UIImage imageNamed:@"c_normal"] forState:UIControlStateNormal];
//    }else{
//        [self.debutton setImage:[UIImage imageNamed:@"c_sele"] forState:UIControlStateSelected];
//    }
}

@end
