//
//  HBOTCOrderDetailAlertView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/4.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCOrderDetailAlertView.h"

@interface HBOTCOrderDetailAlertView ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation HBOTCOrderDetailAlertView

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = kLocat(@"OTC.HBOTCOrderDetailAlertView.confirmPass");
    self.tipsLabel.text = kLocat(@"OTC.HBOTCOrderDetailAlertView.tips");
    [self.cancelButton setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    [self.sureButton setTitle:kLocat(@"Confirm") forState:UIControlStateNormal];
    __weak typeof(self) wself = self;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [wself checkBoxAction:self.checkBoxButton];
    }];
    self.tipsLabel.userInteractionEnabled = YES;
    [self.tipsLabel addGestureRecognizer:tapGR];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(self.containerView.frame, point)) {
        [self hide];
    }
    
}


#pragma mark - Actions

- (IBAction)checkBoxAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)cancelAction:(id)sender {
    [self hide];
}

- (IBAction)sureAction:(id)sender {
    if (self.checkBoxButton.selected) {
        if ([self.delegate respondsToSelector:@selector(didSelectSureWithOrderDetailAlertView:)]) {
            [self.delegate didSelectSureWithOrderDetailAlertView:self];
        }
        [self hide];
    }
}
#pragma mark - Public

+ (instancetype)loadNibView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}



- (void)showInWindow {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.checkBoxButton.selected = NO;
    self.alpha = 0.;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
