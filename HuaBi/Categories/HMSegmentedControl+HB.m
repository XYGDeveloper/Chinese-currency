//
//  HMSegmentedControl+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/5.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HMSegmentedControl+HB.h"

@implementation HMSegmentedControl (HB)

+ (instancetype)createSegmentedControl {

    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 45.)];

    [segmentedControl _configureStyle];
    return segmentedControl;
}

- (void)_configureStyle {
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.selectionIndicatorHeight = 2.5f;
    self.selectionIndicatorColor = kColorFromStr(@"#FFD401");
    
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:18],NSFontAttributeName, [UIColor colorWithHexString:@"#7582A4"], NSForegroundColorAttributeName,nil];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:18],NSFontAttributeName, kColorFromStr(@"#FFD401"), NSForegroundColorAttributeName,nil];
    self.titleTextAttributes = attributesNormal;
    self.selectedTitleTextAttributes = attributesSelected;
}


@end
