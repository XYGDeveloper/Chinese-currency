//
//  HBHomeQuotationSegmentedSectionHeaderView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/1.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBHomeQuotationSegmentedSectionHeaderView.h"
#import "YTData_listModel.h"
#import "SafeCategory.h"

@interface HBHomeQuotationSegmentedSectionHeaderView ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *contianerViews;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;

@end

@implementation HBHomeQuotationSegmentedSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contianerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    self.backgroundColor = kThemeBGColor;
    
    [self _setupSegmentedControl];
  
    self.nameLabel.text = kLocat(@"HBQuotationListHeaderView_name");
    self.latestLabel.text = kLocat(@"HBQuotationListHeaderView_Latest price");
}

#pragma mark - Public

- (void)setSelectedSegmentIndex:(NSInteger)index {
    self.segmentedControl.selectedSegmentIndex = index;
}

#pragma mark - Private

- (void)_setupSegmentedControl {
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:16.],NSFontAttributeName, [UIColor colorWithHexString:@"#7582A4"], NSForegroundColorAttributeName,nil];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:16.],NSFontAttributeName, kColorFromStr(@"#DEE5FF"), NSForegroundColorAttributeName,nil];
    self.segmentedControl.titleTextAttributes = attributesNormal;
    self.segmentedControl.selectedTitleTextAttributes = attributesSelected;
//    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
//    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 16, 0, 16);
    __weak typeof(self) weakSelf = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        if (weakSelf.indexChangeBlock) {
            weakSelf.indexChangeBlock(index);
        }
        [weakSelf _updateRightLabel];
    };
}

- (void)_updateRightLabel {
    YTData_listModel *model = [self.allRankingArray safeObjectAtIndex:self.segmentedControl.selectedSegmentIndex];
    self.rightLabel.text = model.right_name;
}

#pragma mark - Setter

- (void)setAllRankingArray:(NSArray<YTData_listModel *> *)allRankingArray {
    _allRankingArray = allRankingArray;
    
    NSMutableArray *titleArray = [NSMutableArray array];
    [allRankingArray enumerateObjectsUsingBlock:^(YTData_listModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray addObject:obj.name ?: @""];
    }];
    self.segmentedControl.sectionTitles = titleArray.copy;
    [self _updateRightLabel];
}

@end
