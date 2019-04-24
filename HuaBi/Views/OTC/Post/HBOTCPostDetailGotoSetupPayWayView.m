//
//  HBOTCPostDetailGotoSetupPayWayView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/12.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCPostDetailGotoSetupPayWayView.h"

@interface HBOTCPostDetailGotoSetupPayWayView ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *addLabel;


@end

@implementation HBOTCPostDetailGotoSetupPayWayView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = kThemeColor;
    
    self.tipsLabel.text = kLocat(@"OTC.HBOTCPostDetailGotoSetupPayWayView.tips");
    self.addLabel.text = kLocat(@"OTC.HBOTCPostDetailGotoSetupPayWayView.add");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
