//
//  MybounsHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MybounsHeaderTableViewCell.h"

@implementation MybounsHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.startTime.userInteractionEnabled = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (IBAction)start:(id)sender {
    NSLog(@"dddddddd");
    if (self.startAction) {
        self.startAction();
    }
}

- (IBAction)end:(id)sender {
    if (self.endAction) {
        self.endAction();
    }
}

- (IBAction)query:(id)sender {
    if (self.queryAction) {
        self.queryAction();
    }
}




@end
