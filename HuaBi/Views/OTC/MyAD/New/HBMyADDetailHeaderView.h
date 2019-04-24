//
//  HBMyADDetailHeaderView.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/4.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TPOTCMyADModel, HBMyADDetailHeaderView;

@protocol HBMyADDetailHeaderViewDelegate <NSObject>

@optional
- (void)cancelWithMyADDetailHeaderView:(HBMyADDetailHeaderView *)view;

@end

@interface HBMyADDetailHeaderView : UIView

@property (nonatomic, strong) TPOTCMyADModel *model;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, weak) id<HBMyADDetailHeaderViewDelegate> delegate;

- (void)configureCellWithModel:(TPOTCMyADModel *)model isHistory:(BOOL)isHistory;

@end

NS_ASSUME_NONNULL_END
