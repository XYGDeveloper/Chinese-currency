//
//  HBCurrentEntrustEmptyCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCurrentEntrustEmptyCell.h"

@interface HBCurrentEntrustEmptyCell ()
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation HBCurrentEntrustEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.noRecordLabel.text = kLocat(@"noRecord");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
