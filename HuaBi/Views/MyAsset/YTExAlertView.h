//
//  YTExAlertView.h
//  YJOTC
//
//  Created by XI YANGUI on 2018/10/7.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YTAlertViewLeftEvent)(NSString *btcCount,NSString *scaleContent,NSString *atCount,NSString *mulCount,NSString *pwd);
typedef void (^YTAlertViewMiddleEvent)(void);
typedef void (^YTAlertViewRightEvent)(void);

@interface YTExAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *BTCLabel;
@property (weak, nonatomic) IBOutlet UILabel *BTCCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *EXchangeScaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *EXchangeContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ExchangeDesLabel;
@property (weak, nonatomic) IBOutlet UITextField *ExchangeInputText;
@property (weak, nonatomic) IBOutlet UILabel *MulLabel;
@property (weak, nonatomic) IBOutlet UILabel *MulContent;
@property (weak, nonatomic) IBOutlet UILabel *pwdDes;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *CommitBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, copy) YTAlertViewLeftEvent left;
@property (nonatomic, copy) YTAlertViewMiddleEvent middle;
@property (nonatomic, copy) YTAlertViewRightEvent right;
@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *atfree;
@property (nonatomic, copy) NSString *maxValue;

/**
 *  IdentityAuthenticationAlertView
 *
 *  @param controller 要呈现控制器
 *  @param BTCtitle     BTC量
 *  @param BTCcontent   BTC量内容
 *  @param EXScale      兑换比例
 *  @param EXContent    兑换比例内容
 *  @param EXAT         ATcount
 *  @param EXATMul      兑换消耗
 *  @param EXATMulcontent 兑换AT消耗量
 *  @param EXATPWD      交易密码
 *  @param leftTitle    左边按钮文字
 *  @param middleTitle  中间按钮文字
 *  @param rightTitle   右边按钮文字
 *  @param leftEvent  左边按钮执行的Block
 *  @param middleEvent 中间按钮执行的Block
 *  @param rightEvent 右边按钮执行的Block
 */
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
                            Max:(NSString *)maxValue;

@end
