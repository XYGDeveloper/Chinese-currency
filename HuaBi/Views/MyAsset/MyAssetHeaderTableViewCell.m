//
//  MyAssetHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyAssetHeaderTableViewCell.h"

@implementation MyAssetHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 8; //设置imageView的圆角
    self.bgView.userInteractionEnabled = YES;
//    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    self.bgView.layer.shadowOpacity = 0.4;//设置阴影的透明度
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
    self.bgView.layer.shadowRadius = 3;//设置阴影的圆角
    // Initialization code
}

- (IBAction)HiddeAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (self.hid) {
        self.hid(btn.selected);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
