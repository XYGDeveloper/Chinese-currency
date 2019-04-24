//
//  HBKlineTradeHeaderView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBKlineTradeHeaderView.h"


@interface HBKlineTradeHeaderView ()




@end

@implementation HBKlineTradeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.segmentedControl.sectionTitles = @[kLocat(@"Deal"), kLocat(@"Intro")];
    self.segmentedControl.backgroundColor = kThemeColor;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 2;
    self.segmentedControl.selectionIndicatorColor = kColorFromStr(@"#11B1ED");
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:16],NSFontAttributeName, [UIColor colorWithHexString:@"7582A4"], NSForegroundColorAttributeName,nil];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:16],NSFontAttributeName, kColorFromStr(@"#11B1ED"), NSForegroundColorAttributeName,nil];
    self.segmentedControl.titleTextAttributes = attributesNormal;
    self.segmentedControl.selectedTitleTextAttributes = attributesSelected;
    self.backgroundColor = kThemeBGColor;
}

@end
