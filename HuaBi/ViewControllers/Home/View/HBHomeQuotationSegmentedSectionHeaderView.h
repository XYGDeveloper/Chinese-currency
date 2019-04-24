//
//  HBHomeQuotationSegmentedSectionHeaderView.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/1.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@class YTData_listModel;
@interface HBHomeQuotationSegmentedSectionHeaderView : UIView


@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;
@property (nonatomic, strong) NSArray<YTData_listModel *> *allRankingArray;

- (void)setSelectedSegmentIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
