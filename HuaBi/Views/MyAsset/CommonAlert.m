//
//  CommonAlert.m
//  HuaBi
//
//  Created by l on 2019/2/26.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "CommonAlert.h"
@interface CommonAlert()
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
//@property (weak, nonatomic) IBOutlet UIButton *canButton;
//@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end
@implementation CommonAlert

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
}

+ (void)AlertWith:(NSString *)title detail:(NSString *)detail buttonTextLabel:(NSString *)buttonTextLabel controller:(UIViewController *)controller sureAction:(sureEvent)sure cancelEvent:(cancelEvent)cancel{
    CommonAlert *alert = [[NSBundle mainBundle]loadNibNamed:@"CommonAlert" owner:nil options:nil][0];
    alert.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    alert.titleLabel.text = title;
    alert.detailLabel.text = detail;
    alert.sure = sure;
    [alert.sureButton setTitle:buttonTextLabel forState:UIControlStateNormal];
    [alert.cancelButton setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    alert.bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    alert.bgview.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        alert.bgview.transform = transform;
        alert.bgview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)cancelAction:(id)sender {
    if (self.cancel) {
        self.cancel();
    }
    
    [self removeFromSuperview];
    
}

- (IBAction)sureAction:(id)sender {
    
    if (self.sure) {
        self.sure();
    }
    [self removeFromSuperview];
}

@end
