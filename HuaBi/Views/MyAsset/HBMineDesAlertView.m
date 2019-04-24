//
//  HBMineDesAlertView.m
//  HuaBi
//
//  Created by l on 2018/11/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMineDesAlertView.h"
@interface HBMineDesAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@end

@implementation HBMineDesAlertView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.bgview.layer.cornerRadius = 8;
    self.bgview.layer.masksToBounds = YES;
}
+ (void)AlertWith:(NSString *)title
           detail:(NSString *)detail
  buttonTextLabel:(NSString *)buttonTextLabel
       controller:(UIViewController *)controller
      sureAction:(sureEvent)sure{
    HBMineDesAlertView *alert = [[NSBundle mainBundle]loadNibNamed:@"HBMineDesAlertView" owner:nil options:nil][0];
    alert.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    alert.titleLabel.text = title;
    alert.detailLabel.text = detail;
    alert.sure = sure;
    [alert.sureButton setTitle:buttonTextLabel forState:UIControlStateNormal];
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


- (IBAction)confirAction:(id)sender {
    if (self.sure) {
        self.sure();
    }
    [self removeFromSuperview];
}


@end
