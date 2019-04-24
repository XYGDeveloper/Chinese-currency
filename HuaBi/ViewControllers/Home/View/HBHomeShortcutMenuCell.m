//
//  HBHomeShortcutMenuCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeShortcutMenuCell.h"

@interface HBHomeShortcutMenuCell ()

@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyInterestLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIStackView) NSArray<UIView *> *menuStackViews;

@end

@implementation HBHomeShortcutMenuCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
    
    [self.menuStackViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenuAction:)];
        [obj addGestureRecognizer:tapRecognizer];
    }];
    
    self.subscriptionLabel.text = kLocat(@"Subscription");
    self.inviteLabel.text = kLocat(@"Invite");
    self.moneyInterestLabel.text = kLocat(@"Money Interest title");
}

#pragma mark - Action

- (void)tapMenuAction:(UIGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(homeShortcutMenuCell:selectedMenuType:)]) {
        [self.delegate homeShortcutMenuCell:self selectedMenuType:[sender.view tag]];
    }
}

@end
