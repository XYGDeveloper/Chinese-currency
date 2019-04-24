//
//  HBHomeSectionHeaderView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeSectionHeaderView.h"

@interface HBHomeSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;



@end

@implementation HBHomeSectionHeaderView

+ (instancetype)loadNibView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.backgroundColor = kThemeColor;
    self.titleLabel.text = kLocat(@"k_HomeViewController_tableview_header_title");
//    UITapGestureRecognizer *tapGR = [UITapGestureRecognizer alloc]
    self.backgroundColor = kThemeBGColor;
}

@end
