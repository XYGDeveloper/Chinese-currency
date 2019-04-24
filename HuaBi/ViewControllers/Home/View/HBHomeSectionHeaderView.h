//
//  HBHomeSectionHeaderView.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^HBHomeSectionHeaderViewTapBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HBHomeSectionHeaderView : UIView

+ (instancetype)loadNibView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (nonatomic, copy) HBHomeSectionHeaderViewTapBlock tapBlock;

@end

NS_ASSUME_NONNULL_END
