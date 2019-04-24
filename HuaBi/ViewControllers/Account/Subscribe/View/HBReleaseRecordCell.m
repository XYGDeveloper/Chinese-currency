//
//  HBReleaseRecordCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReleaseRecordCell.h"
#import "HBReleaseRecordModel.h"

@interface HBReleaseRecordCell ()

// Values
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// Names
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;

@end

@implementation HBReleaseRecordCell

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
    
    self.numberNameLabel.text = kLocat(@"Relase Number");
    self.statusNameLabel.text = kLocat(@"Relase Status");
    self.timeNameLabel.text = kLocat(@"Relase Time");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setters

- (void)setModel:(HBReleaseRecordModel *)model {
    _model = model;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@ %@", model.release_num, model.currency_name];
    self.timeLabel.text = model.add_time;
    self.statusLabel.text = kLocat(@"Assert_detail_releaseSuccess");
}

@end
