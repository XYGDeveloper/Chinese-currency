//
//  TPOTCBuyConfirmOrderController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyConfirmOrderController.h"
#import "TPOTCBuyConfirmOrderView.h"
#import "TPOTCQRViewController.h"
#import "TPOTCProfileViewController.h"
#import "TPBaseOTCViewController.h"
#import "TPOTCAppealViewController.h"
#import "TPOTCOrderBaseController.h"
#import "TPOTCOrderDetailController.h"
#import "TPOTCTradeListModel.h"


@interface TPOTCBuyConfirmOrderController ()

@property(nonatomic,strong)NSDictionary *tradeInfo;

@property(nonatomic,strong)UIButton *bottomButton;

@property(nonatomic,assign)NSInteger limitTime;

@property(nonatomic,strong)UILabel *tipsLabel;

@property(nonatomic,strong)UILabel *leftLabel;

@property(nonatomic,strong)UILabel *statusLabel;

@property(nonatomic,strong)UIButton *confirmButton;
@property(nonatomic,strong)UILabel *bottomTipsLabel;

/**  是否付款  */
@property(nonatomic,assign)BOOL isPaid;



@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSTimer *appealTimer;
@property(nonatomic,assign)NSInteger appealSecond;
@property(nonatomic,strong)UIButton *appealButton;
@property(nonatomic,strong)UILabel *timeLabel;



@end

@implementation TPOTCBuyConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self initBackButton];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}




-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _trade_id;
    kShowHud;
    __weak typeof(self)weakSelf = self;

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/trade_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            _tradeInfo = dic;
            _limitTime = [_tradeInfo[@"limit_time"] integerValue];
            [weakSelf setupUI];
            
            weakSelf.timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

-(void)setupUI
{
    __weak typeof(self)weakSelf = self;

    self.view.backgroundColor = kColorFromStr(@"#171f34");
    
    TPOTCBuyConfirmOrderView *midView = [[[NSBundle mainBundle] loadNibNamed:@"TPOTCBuyConfirmOrderView" owner:nil options:nil] lastObject];
    
    
    midView.frame = kRectMake(12,  91 * kScreenHeightRatio, kScreenW - 24, 256+10);
    [self.view addSubview:midView];
    
    midView.dataDic = _tradeInfo;
    
    [midView.qrButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        TPOTCQRViewController *vc = [TPOTCQRViewController new];
        vc.qrString = weakSelf.tradeInfo[@"bank"][@"img"];
        
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [midView.namebutton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
       
        [UIPasteboard generalPasteboard].string = weakSelf.tradeInfo[@"bank"][@"truename"];
        [weakSelf showTips:kLocat(@"OTC_copySuccess")];
    }];
    [midView.accountbutton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        [UIPasteboard generalPasteboard].string = weakSelf.tradeInfo[@"bank"][@"cardnum"];
        [weakSelf showTips:kLocat(@"OTC_copySuccess")];
    }];
    [midView.referenceButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        [UIPasteboard generalPasteboard].string = weakSelf.tradeInfo[@"pay_number"];
        [weakSelf showTips:kLocat(@"OTC_copySuccess")];
    }];
 
    
    
    
    
    UILabel *cnyLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 28 , kScreenW - 24, 20) text:[NSString stringWithFormat:@"%@ CNY",_tradeInfo[@"money"]] font:PFRegularFont(20) textColor:kColorFromStr(@"#CDD2E3") textAlignment:1 adjustsFont:YES];
    
    [self.view addSubview:cnyLabel];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:kRectMake(114 *kScreenWidthRatio, 60 , 19, 19)];
    icon.image = kImageFromStr(@"fu_icon_shijian");
    [self.view addSubview:icon];
    
    UILabel * statusLabel = [[UILabel alloc] initWithFrame:kRectMake(icon.right + 6, 0, 48, 15) text:kLocat(@"OTC_notPay") font:PFRegularFont(14) textColor:kColorFromStr(@"#EA6E44") textAlignment:0 adjustsFont:YES];
    [self.view addSubview:statusLabel];
    statusLabel.centerY = icon.centerY;
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:kRectMake(statusLabel.right + 11, 0, 120, 13) text:[NSString stringWithFormat:@"%@15%@00%@",kLocat(@"OTC_left"),kLocat(@"OTC_minute"),kLocat(@"OTC_second")] font:PFRegularFont(12) textColor:kColorFromStr(@"#CDD2E3") textAlignment:0 adjustsFont:YES];
    [self.view addSubview:timeLabel];
    timeLabel.centerY = icon.centerY;
    
 
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:kRectMake(0, kScreenH - 45  - kNavigationBarHeight, kScreenW, 45) title:kLocat(@"OTC_buy_hasPaied") titleColor:kColorFromStr(@"#8D92A0") font:PFRegularFont(16) titleAlignment:1];
    [self.view addSubview:bottomButton];
    [bottomButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#656B7B")] forState:UIControlStateNormal];
    _bottomButton = bottomButton;
    [bottomButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#11B1ED")] forState:UIControlStateSelected];
    [bottomButton addTarget:self action:@selector(confirmPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
    
    UIButton *confirmBurron = [[UIButton alloc] initWithFrame:kRectMake(0, kScreenH - 75-27-5-kNavigationBarHeight, 38, 38)];
    [self.view addSubview:confirmBurron];
    [confirmBurron setImage:kImageFromStr(@"fu_icon_xno") forState:UIControlStateNormal];
    [confirmBurron setImage:kImageFromStr(@"fu_icon_xpre") forState:UIControlStateSelected];
    [confirmBurron addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
        sender.selected = !sender.isSelected;
        weakSelf.bottomButton.selected = sender.selected;
    }];
    
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(confirmBurron.right + 5, 0, kScreenW - confirmBurron.right - 5 - 12, 40) text:kLocat(@"OTC_buyconfirm_tips") font:PFRegularFont(12) textColor:kColorFromStr(@"#707589") textAlignment:0 adjustsFont:YES];
    [self.view addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    tipsLabel.y = kScreenH - 75  - 27 - kNavigationBarHeight;
    
    _leftLabel = timeLabel;
    _tipsLabel = midView.tipsLabel;
    
    
    _confirmButton = confirmBurron;
    _statusLabel = statusLabel;
    _bottomTipsLabel = tipsLabel;
    
}

-(void)countDown
{
    _limitTime--;
    
//    NSLog(@"%zd",_limitTime);
    
    __weak typeof(self)weakSelf = self;

    if (_limitTime > 0) {
        
        _leftLabel.text = [NSString stringWithFormat:@"剩%@",[Utilities returnTimeWithSecond:_limitTime formatter:@"mm分ss秒"]];
        
        if ([_leftLabel.text containsString:@"剩"]) {
            _leftLabel.text = [_leftLabel.text stringByReplacingOccurrencesOfString:@"剩" withString:kLocat(@"OTC_left")];
        }
        if ([_leftLabel.text containsString:@"分"]) {
            _leftLabel.text = [_leftLabel.text stringByReplacingOccurrencesOfString:@"分" withString:kLocat(@"OTC_minute")];
        }
        if ([_leftLabel.text containsString:@"秒"]) {
            _leftLabel.text = [_leftLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:kLocat(@"OTC_second")];
        }
        
//        _leftLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_left"),[Utilities returnTimeWithSecond:_limitTime formatter:[NSString stringWithFormat:@"mm%@ss%@",kLocat(@"OTC_minute"),kLocat(@"OTC_second")]]];
        
        
//        _tipsLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ CNY",kLocat(@"OTC_buyconfirm_plseasein"),[Utilities returnTimeWithSecond:_limitTime formatter:[NSString stringWithFormat:@"mm%@ss%@",kLocat(@"OTC_minute"),kLocat(@"OTC_second")]],kLocat(@"OTC_buyconfirm_payup"),_tradeInfo[@"money"]];

        _tipsLabel.text = [NSString stringWithFormat:@"請在 %@ 內向以上收款方式支付 %@ CNY",[Utilities returnTimeWithSecond:_limitTime formatter:@"mm分ss秒"],_tradeInfo[@"money"]];
        
        _tipsLabel.text = [_tipsLabel.text stringByReplacingOccurrencesOfString:@"請在" withString:kLocat(@"OTC_buyconfirm_plseasein")];
        _tipsLabel.text = [_tipsLabel.text stringByReplacingOccurrencesOfString:@"內向以上收款方式支付" withString:kLocat(@"OTC_buyconfirm_payup")];

        
        
        if ([_tipsLabel.text containsString:@"分"]) {
            _tipsLabel.text = [_tipsLabel.text stringByReplacingOccurrencesOfString:@"分" withString:kLocat(@"OTC_minute")];
        }
        if ([_tipsLabel.text containsString:@"秒"]) {
            _tipsLabel.text = [_tipsLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:kLocat(@"OTC_second")];
        }
        
    }else{
        _tipsLabel.text = kLocat(@"OTC_buyconfirm_paytimeisover");
//        _leftLabel.text = @"剩0分0秒";
      _leftLabel.text = [NSString stringWithFormat:@"%@0%@0%@",kLocat(@"OTC_left"),kLocat(@"OTC_minute"),kLocat(@"OTC_second")];
        [weakSelf.timer invalidate];
    }
}



-(void)confirmPayAction:(UIButton *)button
{
    if (button.selected) {
        [self showTipsView];
    }

}


-(void)showTipsView
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 190 *kScreenHeightRatio, kScreenW - 56, 195)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 70) text:kLocat(@"OTC_buyconfirm_payconfirm") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 150, midView.width/2, 45) title:kLocat(@"net_alert_load_message_cancel") titleColor:kColorFromStr(@"#31AAD7") font:PFRegularFont(16) titleAlignment:YES];
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*   sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, 150, midView.width/2, 45) title:kLocat(@"net_alert_load_message_sure") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");

    [confirmlButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom-5, midView.width - 56, midView.height - 45 - titleLabel.height + 10) text:kLocat(@"OTC_buyconfirm_paytips") font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    
}


-(void)payAction:(UIButton *)button
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _trade_id;
    kShowHud;
    __weak typeof(self)weakSelf = self;

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/TradeOtc/pay"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [button.superview.superview removeFromSuperview];
//            [self showTips:[responseObj ksObjectForKey:kMessage]];
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            
            [weakSelf.timer invalidate];
            
            
            _statusLabel.text = kLocat(@"OTC_toallow");
            _tipsLabel.text = kLocat(@"OTC_toallow");
            _confirmButton.hidden = YES;
            _bottomTipsLabel.hidden = YES;
            _leftLabel.hidden = YES;
            
            self.enablePanGesture = NO;
            _isPaid = YES;
            
//            [self getOrderInfo];
            
            TPOTCOrderDetailController *vc = [TPOTCOrderDetailController new];
            TPOTCTradeListModel *model = [TPOTCTradeListModel new];
            model.type = @"buy";
            model.trade_id = _trade_id;
            model.currency_name = _tradeInfo[@"currency_name"];
            vc.enablePanGesture = NO;
            vc.model = model;
            vc.type = TPOTCOrderDetailControllerTypePaid;
            vc.isFromBuyConfirmOrderVC = YES;
            kNavPush(vc);
            
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];

}


//以下不调用
-(void)getOrderInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _trade_id;
    kShowHud;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/trade_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            _tradeInfo = dic;
       
            
            [self setupAppealView];
            
            
        }else{
//            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
    
}

-(void)setupAppealView
{
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, kScreenH - 45, kScreenW, 45) title:@"申訴" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:1];
    [self.view addSubview:button];
    _appealButton = button;
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [button setTitleColor:kColorFromStr(@"#8D92A0") forState:UIControlStateDisabled];
    button.enabled = NO;
    [button setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"11B1ED")] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#656B7B")] forState:UIControlStateDisabled];
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 65, kScreenW, 12) text:[NSString stringWithFormat:@"付款成功%@分鐘后才能發起申訴",_tradeInfo[@"appeal_minute"]] font:PFRegularFont(12) textColor:kColorFromStr(@"#707589") textAlignment:1 adjustsFont:YES];
    [self.view addSubview:tipsLabel];
    tipsLabel.bottom = button.y - 30;

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 35, kScreenW, 20) text:@"" font:PFRegularFont(14) textColor:kRedColor textAlignment:1 adjustsFont:YES];
    
    [self.view addSubview:tipsLabel];
    _timeLabel = timeLabel;

    timeLabel.bottom = button.y - 60;

    _appealSecond = [_tradeInfo[@"appeal_wait"] integerValue];
    self.appealTimer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(configureTimeLabel) userInfo:nil repeats:YES];
    
    __weak typeof(self)weakSelf = self;
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        TPOTCAppealViewController *vc = [TPOTCAppealViewController new];
        vc.trade_id = weakSelf.trade_id;
        vc.isBuy = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];

}





-(void)backAction
{
    if (_isPaid == NO) {
        [super backAction];
    }else{
        for (UIViewController *vc in self.navigationController.viewControllers) {
//            NSLog(@"%@",vc);
            if ([vc isKindOfClass:[TPBaseOTCViewController class]]) {//购买首页
                [self.navigationController popToViewController:vc animated:YES];
            }else if ([vc isKindOfClass:[TPOTCOrderBaseController class]]){//去订单列表
                
                #pragma mark - 发通知刷新数据
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    NSLog(@"=====");
    
}




-(void)configureTimeLabel
{
    _appealSecond--;
    NSString *str;
    if (_appealSecond > 0) {
        str = [NSString stringWithFormat:@"您還需等待  %@",[Utilities returnTimeWithSecond:_appealSecond formatter:@"mm分ss秒"]];
        _appealButton.enabled = NO;
    }else{
        str = @"您還需等待  0分0秒";
        [self.timer invalidate];
        _appealButton.enabled = YES;
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range1 = [str rangeOfString:@"您還需等待  "];
    [attr addAttribute:NSForegroundColorAttributeName value:kLightGrayColor range:range1];
    [attr addAttribute:NSFontAttributeName value:PFRegularFont(14) range:range1];
    
    NSRange range2 = NSMakeRange(7, str.length - 7);
    [attr addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#F52657") range:range2];
    [attr addAttribute:NSFontAttributeName value:PFRegularFont(19) range:range2];
    
    _timeLabel.attributedText = attr;
}
@end
