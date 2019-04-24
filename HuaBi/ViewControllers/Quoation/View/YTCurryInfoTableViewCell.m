//
//  YTCurryInfoTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTCurryInfoTableViewCell.h"

@implementation YTCurryInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.label1.text = kLocat(@"kcurrentuantity_labl1");
    self.label2.text = kLocat(@"kcurrentuantity_labl2");
    self.label3.text = kLocat(@"kcurrentuantity_labl3");
    self.label4.text = kLocat(@"kcurrentuantity_labl4");
    self.label5.text = kLocat(@"kcurrentuantity_labl5");
    self.label6.text = kLocat(@"kcurrentuantity_labl6");
    self.label7.text = kLocat(@"kcurrentuantity_labl7");

    // Initialization code
}


- (void)refresh:(NSDictionary *)dic name:(NSString *)name{
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
