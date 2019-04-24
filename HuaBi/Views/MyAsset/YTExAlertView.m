//
//  YTExAlertView.m
//  YJOTC
//
//  Created by XI YANGUI on 2018/10/7.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTExAlertView.h"

@implementation YTExAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    self.contentView.layer.cornerRadius = 8;
    self.contentView.layer.masksToBounds = YES;
    
    self.CommitBtn.layer.cornerRadius = 10;
    self.CommitBtn.layer.masksToBounds = YES;
    
    self.resetBtn.layer.cornerRadius = 10;
    self.resetBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 10;
    self.cancelBtn.layer.masksToBounds = YES;
    
    [self.ExchangeInputText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

+ (void)alertControllerAppearIn:(UIViewController *)controller
                       BTCtitle:(NSString *)BTCtitle
                     BTCcontent:(NSString *)BTCcontent
                        EXScale:(NSString *)EXScale
                      EXContent:(NSString *)EXContent
                           EXAT:(NSString *)EXAT
                        EXATMul:(NSString *)EXATMul
                 EXATMulcontent:(NSString *)EXATMulcontent
                        EXATPWD:(NSString *)EXATPWD
                      leftTitle:(NSString *)leftTitle
                      leftEvent:(YTAlertViewLeftEvent)leftEvent
                    middleTitle:(NSString *)middleTitle
                    middleEvent:(YTAlertViewMiddleEvent)middleEvent
                     rightTitle:(NSString *)rightTitle
                     rightEvent:(YTAlertViewRightEvent)rightEvent
                           free:(NSString *)free
                         atFree:(NSString *)Atfree
                            Max:(NSString *)maxValue{
    YTExAlertView *alert = [[NSBundle mainBundle]loadNibNamed:@"YTExAlertView" owner:nil options:nil][0];
    
    alert.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    
    alert.BTCLabel.text = BTCtitle;
    alert.BTCCountLabel.text = BTCcontent;
    alert.EXchangeScaleLabel.text = EXScale;
    alert.EXchangeContentLabel.text = EXContent;
    alert.ExchangeDesLabel.text = EXAT;
    alert.MulLabel.text = EXATMul;
    alert.MulContent.text = EXATMulcontent;
    alert.pwdDes.text = EXATPWD;
    [alert.CommitBtn setTitle:leftTitle forState:UIControlStateNormal];
    [alert.resetBtn setTitle:middleTitle forState:UIControlStateNormal];
    [alert.cancelBtn setTitle:rightTitle forState:UIControlStateNormal];
    alert.left = leftEvent;
    alert.middle = middleEvent;
    alert.right = rightEvent;
    alert.free = free;
    alert.atfree = Atfree;
    alert.maxValue = maxValue;
    [controller.view addSubview:alert];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    alert.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    alert.contentView.alpha = 0;
    /**
     *  usingSpringWithDamping：0-1 数值越小，弹簧振动效果越明显
     *  initialSpringVelocity ：数值越大，一开始移动速度越快
     */
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        alert.contentView.transform = transform;
        alert.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}

- (IBAction)leftAction:(id)sender {
    if (self.left) {
        if (self.ExchangeInputText.text.length <= 0) {
            [self showWarning:@"请输入兑换数量"];
            return;
        }
        if (self.pwdText.text.length <= 0) {
            [self showWarning:@"请输入兑换密码"];
            return;
        }
        self.left(self.BTCCountLabel.text, self.EXchangeContentLabel.text,self.ExchangeInputText.text, self.MulContent.text, self.pwdText.text);
    }
    [self removeFromSuperview];
}

- (IBAction)middleAction:(id)sender {
    self.ExchangeInputText.text = @"";
    self.pwdText.text = @"";
    self.MulContent.text = @"";
}

- (IBAction)rightAction:(id)sender {
    if (self.right) {
        self.right();
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    NSLog(@"%@",self.maxValue);
    CGFloat temp;
    if (theTextField.text.length <= 0) {
        self.MulContent.text = @"";
    }else if ([theTextField.text intValue] >= [self.maxValue intValue]){
        temp = ([self.atfree floatValue] * [theTextField.text floatValue])/[self.free floatValue];
        self.MulContent.text = [NSString stringWithFormat:@"%f",temp];
    }else{
        temp = ([self.atfree floatValue] * [theTextField.text floatValue])/[self.free floatValue];
        self.MulContent.text = [NSString stringWithFormat:@"%f",temp];
    }
}

@end
