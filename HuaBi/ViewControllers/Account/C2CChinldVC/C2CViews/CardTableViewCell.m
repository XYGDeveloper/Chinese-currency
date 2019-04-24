//
//  CardTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "CardTableViewCell.h"
#import "PayModel.h"
@implementation CardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.defaubutton setTitle:kLocat(@"k_c2c_now_default") forState:UIControlStateNormal];
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,kScreenW, 21) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.bottomView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
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


- (IBAction)tosetdefault:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.defau) {
        self.defau();
    }
}



- (void)refreshWithModel:(bankModel *)model{
//    self.bankname.text = model.name;
//    self.nameLabel.text = model.truename;
//    self.bankNumber.text = model.bankcard;
//    self.countlabel.text = kLocat(@"k_popview_list_cat4");
//    self.lastLabel.text = kLocat(@"k_popview_list_cat5");
//    [self.delButton setTitle:kLocat(@"k_popview_list_cat6") forState:UIControlStateNormal];
//    if ([model.status isEqualToString:@"0"]) {
//        [self.defaubutton setImage:[UIImage imageNamed:@"c_normal"] forState:UIControlStateNormal];
//    }else{
//        [self.defaubutton setImage:[UIImage imageNamed:@"c_sele"] forState:UIControlStateSelected];
//    }
    
}

@end
