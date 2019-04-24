//
//  TPOTCOrderDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCOrderDetailController.h"
#import "TPOTCBuyDetailBottomCell.h"
#import "TPOTCAppealViewController.h"
#import "TPOTCBuyConfirmOrderController.h"
#import "TPOTCBuyOrderDetailController.h"
#import "TPBaseOTCViewController.h"
#import "TPOTCOrderListController.h"
#import "TPOTCOrderBaseController.h"
#import "TPOTCBaseADController.h"
#import "ZJPayPopupView.h"
#import "HBOTCOrderDetailAlertView.h"
#import "HBChatWebViewController.h"

@interface TPOTCOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,NTESVerifyCodeManagerDelegate, ZJPayPopupViewDelegate, HBOTCOrderDetailAlertViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UILabel *tipsLabel;

@property(nonatomic,strong)NSArray *topArr;
@property(nonatomic,strong)NSArray *midArr;
@property(nonatomic,strong)NSArray *bottomArr;

@property(nonatomic,strong)NSDictionary *dataInfo;

@property(nonatomic,strong)UIButton *confirmCancelButton;

@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)NSTimer *timer;


@property(nonatomic,strong)UIButton *appealButton;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property (nonatomic, strong) ZJPayPopupView *payPopupView;
@property (nonatomic, strong) HBOTCOrderDetailAlertView *tipsAlertView;


@end

@implementation TPOTCOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)setupUI
{
    self.title = kLocat(@"OTC_order_orderdetail");
    self.view.backgroundColor = kColorFromStr(@"#171F34");

    if (_type == TPOTCOrderDetailControllerTypeCancel) {
        
        UIView *view = [self setupHeadView];
        view.y = (239 - 64)* kScreenHeightRatio;
        [self.view addSubview:view];
        self.tipsLabel.bottom = kScreenH - 137 *kScreenHeightRatio;
        [self.view addSubview:self.tipsLabel];
    }else{
        
        
        _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消多余的小灰线
        _tableView.tableFooterView = [UIView new];
        
        _tableView.backgroundColor = kColorFromStr(@"#171F34");
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"TPOTCBuyDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"TPOTCBuyDetailBottomCell"];
        
        _tableView.tableHeaderView = [self setupHeadView];
        
      
        
        if (_type == TPOTCOrderDetailControllerTypePaid) {
//            UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 115)];
//            footerView.backgroundColor = kColorFromStr(@"171F34");
//            [footerView addSubview:self.tipsLabel];
//            self.tipsLabel.y = 15;
//
//            UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 65, kScreenW, 12) text:@"付款成功15分鐘后才能發起申訴" font:PFRegularFont(12) textColor:kColorFromStr(@"#707589") textAlignment:1 adjustsFont:YES];
//            [footerView addSubview:tipsLabel];
//
//            UILabel *timeLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 35, kScreenW, 20) text:@"" font:PFRegularFont(14) textColor:kRedColor textAlignment:1 adjustsFont:YES];
//            [footerView addSubview:timeLabel];
//
//            _timeLabel = timeLabel;
//            _second = 10;
//            _timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(configureTimeLabel) userInfo:nil repeats:YES];
//
//            _tableView.tableFooterView = footerView;

        }else{
            UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 115)];
            footerView.backgroundColor = kColorFromStr(@"171F34");
            [footerView addSubview:self.tipsLabel];
            
            self.tipsLabel.y = 35;
            _tableView.tableFooterView = footerView;
        }
        
        CGFloat h ;
        if (_type == TPOTCOrderDetailControllerTypeDone) {//已完成
            h = kScreenH-kNavigationBarHeight;
        }else{
            h = kScreenH-kNavigationBarHeight - 45;
        }
        if (_type == TPOTCOrderDetailControllerTypeNotPay && [_model.type isEqualToString:@"sell"]) {
            h = kScreenH-kNavigationBarHeight;
        }
        
        _tableView.height = h;

        [self setupBottomView];
    }

    [self addRightBarButtonWithFirstImage:kImageFromStr(@"mai_icon_xxi") action:@selector(showMsgVC)];
    [self initBackButton];
    
}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (_model) {
        
        param[@"trade_id"] = _model.trade_id;
    }else{
        param[@"trade_id"] = _tradeID;
    }
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/trade_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            _dataInfo = [responseObj ksObjectForKey:kData];
            NSLog(@"%@",_dataInfo);
            [self.tableView reloadData];

            if (_type == TPOTCOrderDetailControllerTypePaid) {
                UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 115)];
                footerView.backgroundColor = kColorFromStr(@"171F34");
                [footerView addSubview:self.tipsLabel];
                self.tipsLabel.y = 15;
                
                UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 65, kScreenW, 12) text:[NSString stringWithFormat:@"%@%@%@",kLocat(@"OTC_order_paysuccess"),_dataInfo[@"appeal_minute"],kLocat(@"OTC_order_afterminutetoappeal")] font:PFRegularFont(12) textColor:kColorFromStr(@"#707589") textAlignment:1 adjustsFont:YES];
                [footerView addSubview:tipsLabel];
                
                UILabel *timeLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 35, kScreenW, 20) text:@"" font:PFRegularFont(14) textColor:kRedColor textAlignment:1 adjustsFont:YES];
                [footerView addSubview:timeLabel];
                
                _timeLabel = timeLabel;
                _second = [_dataInfo[@"appeal_wait"] integerValue];
                _timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(configureTimeLabel) userInfo:nil repeats:YES];
                
                _tableView.tableFooterView = footerView;
            }
            
//            self.tipsLabel.text = [NSString stringWithFormat:@"%@%@%%和%@%%%@",kLocat(@"OTC_order_otcwillgetfee"),@([_dataInfo[@"currency_otc_buy_fee"]doubleValue]),@([_dataInfo[@"currency_otc_sell_fee"] doubleValue]),kLocat(@"OTC_order__fee")];
            
            self.tipsLabel.text = [NSString stringWithFormat:@"%@%@%%%@",kLocat(@"OTC_order_otcwillgetfee"),@([_dataInfo[@"currency_otc_buy_fee"]doubleValue]),kLocat(@"OTC_order__fee")];
            
        }
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.topArr.count;
    }else if (section == 1){
        return self.midArr.count;
    }else{
        return self.bottomArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *rid = @"TPOTCBuyDetailBottomCell";
    TPOTCBuyDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.cpyButton.hidden = YES;
    cell.cpyLabel.hidden = YES;
    cell.infoLabel.hidden = NO;
    cell.lineView.hidden = indexPath.row;
    if (indexPath.section == 0) {
        cell.lineView.hidden = indexPath.row == self.topArr.count-1;
        cell.itemLabel.text = self.topArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.infoLabel.text = _dataInfo[@"username"];
        }else{
            cell.infoLabel.text = _model.currency_name;
        }

    }else if (indexPath.section == 1){
        cell.lineView.hidden = indexPath.row == self.midArr.count-1;
        cell.itemLabel.text = self.midArr[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_dataInfo[@"money"]];
        }else if (indexPath.row == 1){
            cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@",_dataInfo[@"num"],_model.currency_name];
        }else if (indexPath.row == 2){
            cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@",_dataInfo[@"fee"],_model.currency_name];
        }else{
            cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@",_dataInfo[@"real_num"],_model.currency_name];
        }
        
    }else{
        cell.lineView.hidden = indexPath.row == self.bottomArr.count-1;
        cell.itemLabel.text = self.bottomArr[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.infoLabel.text = [NSString stringWithFormat:@"%@",_dataInfo[@"pay_number"]];
        }else if (indexPath.row == 1){
            cell.infoLabel.text = [NSString stringWithFormat:@"#%@",_dataInfo[@"only_number"]];
        }else if (indexPath.row == 2){
            cell.infoLabel.text = _dataInfo[@"add_time"];
        }else{
            
            if ([_dataInfo[@"money_type"] isEqualToString:kZFB]) {
                cell.infoLabel.text = kLocat(@"k_popview_select_payalipay");
            }else if ([_dataInfo[@"money_type"] isEqualToString:kWechat]){
                cell.infoLabel.text = kLocat(@"k_popview_select_paywechat");
            }else if([_dataInfo[@"money_type"] isEqualToString:kYHK]){
                cell.infoLabel.text = kLocat(@"k_popview_select_paybank");
            }else{
                cell.infoLabel.text = kLocat(@"OTC_order_nochoose");
            }
        }
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return 5;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


/**  订单取消视图  */
-(UIView *)setupHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 160 - 64)];
    view.backgroundColor = kColorFromStr(@"#171F34");
    
    NSString *str;
    NSString *image;
    if (_type == TPOTCOrderDetailControllerTypeCancel) {
        str = kLocat(@"OTC_order_ordercancel");
        image = @"did_icon_yqxiao";
    }else if (_type == TPOTCOrderDetailControllerTypePaid){
        str = kLocat(@"OTC_order_orderpaid");
        image = @"did_icon_yfk";
    }else if (_type == TPOTCOrderDetailControllerTypeNotPay){
        str = kLocat(@"OTC_order_ordernotpay");
        image = @"did_icon_wfk";
    }else if (_type == TPOTCOrderDetailControllerTypeDone){
        str = kLocat(@"OTC_order_orderdone");
        image = @"did_icon_wac";
    }else if (_type == TPOTCOrderDetailControllerTypeAppleal){
        str = kLocat(@"OTC_order_orderappleal");
        image = @"did_icon_ss";
    }

    UIImageView *icon = [[UIImageView alloc] initWithFrame:kRectMake(0, 30, 30, 39)];
    icon.image = kImageFromStr(image);
    [view addSubview:icon];
    [icon alignHorizontal];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, icon.bottom + 6, kScreenW  - 24, 14) text:str font:PFRegularFont(14) textColor:kColorFromStr(@"#CDD2E3") textAlignment:1 adjustsFont:YES];
    [view addSubview:label];

    return view;
}
-(void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH - 45 - kNavigationBarHeight, kScreenW, 45)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = kClearColor;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, bottomView.width/2, bottomView.height) title:kLocat(@"OTC_order_topay") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [bottomView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:kRectMake(leftButton.right, 0, bottomView.width/2, bottomView.height) title:kLocat(@"OTC_order_cancelorder") titleColor:kColorFromStr(@"#9BBBEB") font:PFRegularFont(16) titleAlignment:0];
    [bottomView addSubview:rightButton];
    

     if (_type == TPOTCOrderDetailControllerTypePaid){
        if ([_model.type isEqualToString:@"buy"]) {
            
            _appealButton = leftButton;
            [leftButton setTitle:kLocat(@"OTC_order_appleal") forState:UIControlStateNormal];
            [leftButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [leftButton setTitleColor:kColorFromStr(@"#8D92A0") forState:UIControlStateDisabled];
            leftButton.enabled = NO;

            [leftButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"11B1ED")] forState:UIControlStateNormal];
            [leftButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#656B7B")] forState:UIControlStateDisabled];

            leftButton.width = kScreenW;

            rightButton.hidden = YES;
        }else{
            [leftButton setTitle:kLocat(@"OTC_order_discharged") forState:UIControlStateNormal];
            [leftButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
            leftButton.backgroundColor = kColorFromStr(@"11B1ED");
            
            [rightButton setTitle:kLocat(@"OTC_order_appleal") forState:UIControlStateNormal];
            [rightButton setTitleColor:kColorFromStr(@"#8D92A0") forState:UIControlStateDisabled];
            [rightButton setTitleColor:kColorFromStr(@"#9BBBEB") forState:UIControlStateNormal];
            [rightButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#656B7B")] forState:UIControlStateDisabled];
            [rightButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"434A5D")] forState:UIControlStateNormal];

            _appealButton = rightButton;
        }
    }else if(_type == TPOTCOrderDetailControllerTypeNotPay){
        if ([_model.type isEqualToString:@"buy"]) {
            [leftButton setTitle:kLocat(@"OTC_order_topay") forState:UIControlStateNormal];
            [leftButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
            leftButton.backgroundColor = kColorFromStr(@"11B1ED");
            [rightButton setTitle:kLocat(@"OTC_order_cancelorder") forState:UIControlStateNormal];
            [rightButton setTitleColor:kColorFromStr(@"#9BBBEB") forState:UIControlStateNormal];
            rightButton.backgroundColor = kColorFromStr(@"434A5D");
        }else{
//            [leftButton setTitle:@"放行" forState:UIControlStateNormal];
//            [leftButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
//            leftButton.backgroundColor = kColorFromStr(@"11B1ED");
//            [rightButton setTitle:@"申诉" forState:UIControlStateNormal];
//            [rightButton setTitleColor:kColorFromStr(@"#9BBBEB") forState:UIControlStateNormal];
//            rightButton.backgroundColor = kColorFromStr(@"434A5D");
            rightButton.hidden = YES;
            leftButton.hidden = YES;
            
        }
    }else if(_type == TPOTCOrderDetailControllerTypeDone){
        leftButton.hidden = YES;
        rightButton.hidden = YES;
    }else if (_type == TPOTCOrderDetailControllerTypeAppleal){
        bottomView.hidden = YES;
    }
    
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];

}




-(void)leftButtonAction
{
    if (_type == TPOTCOrderDetailControllerTypeNotPay) {
        //去付款
        if ([_dataInfo[@"type"] isEqualToString:@"buy"]) {
            if ([_dataInfo[@"money_type"] length] < 2) {//未选择付款方式
                TPOTCBuyOrderDetailController *vc = [TPOTCBuyOrderDetailController new];
                vc.trade_id = _model.trade_id;
                kNavPush(vc);
            }else{
                TPOTCBuyConfirmOrderController *vc = [TPOTCBuyConfirmOrderController new];
                vc.trade_id = _model.trade_id;
                kNavPush(vc);
            }
        }else{//放行
//            [self showVerifyInfo];
        }
    }else if (_type == TPOTCOrderDetailControllerTypePaid){
    
        if ([_dataInfo[@"type"] isEqualToString:@"buy"]) {//申诉
            TPOTCAppealViewController *vc = [TPOTCAppealViewController new];
            vc.isBuy = YES;
            vc.trade_id = _model.trade_id;
            vc.model = _model;
            kNavPush(vc);
        }else{//放行
            [self _discharged];
        }
    }
}

- (void)_discharged {
    [self.tipsAlertView showInWindow];
}

-(void)rightButtonAction
{
    if (_type == TPOTCOrderDetailControllerTypeNotPay) {
        //取消订单
        if ([_dataInfo[@"type"] isEqualToString:@"buy"]) {
            [self checkCancelTime];

        }else{//申诉
            TPOTCAppealViewController *vc = [TPOTCAppealViewController new];
            vc.model = _model;
            vc.isBuy = NO;
            vc.trade_id = _model.trade_id;
            kNavPush(vc);
        }
    }else if (_type == TPOTCOrderDetailControllerTypePaid){
        if ([_dataInfo[@"type"] isEqualToString:@"buy"]) {//无事件
        }else{//申诉
            TPOTCAppealViewController *vc = [TPOTCAppealViewController new];
            vc.isBuy = NO;
            vc.trade_id = _model.trade_id;
            vc.model = _model;

            kNavPush(vc);
        }
    }
}

#pragma mark - 放行
-(void)permitActionWithPwd:(NSString *)pwd
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _model.trade_id;
    param[@"pwd"] = pwd;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/TradeOtc/fangxing"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        // 刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidPermitTheOrderKey" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
                kNavPop;
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}



#pragma mark - 取消订单
-(void)cancelOrderAction:(UIButton *)button flag:(BOOL)toDelete
{
    if (toDelete == NO && _confirmCancelButton.selected == NO) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _model.trade_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/TradeOtc/cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:kLocat(@"OTC_buyDetail_orderhasbeencancel")];
            if (button) {
                [button.superview.superview removeFromSuperview];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
                #pragma mark - 发通知刷新界面
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


#pragma mark - 聊天

-(void)showMsgVC
{
    NSString *tradeId = _model.trade_id;
//    
//    BaseWebViewController *vc = [[BaseWebViewController alloc] init];
//    vc.titleString = kLocat(@"OTC_buyDetail_chat");
////    vc.urlStr = [kBasePath stringByAppendingPathComponent:@"Api/Jim/chat"];
//    vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,@"/Api/Jim/chat"];
//
//
//    vc.showNaviBar = YES;
//    vc.webViewFrame = kRectMake(0, 0, kScreenW, kScreenH -kNavigationBarHeight);
//
//    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
//    NSString *lang = nil;
//    if ([currentLanguage containsString:@"en"]) {//英文
//        lang = @"en-us";
//    }else if ([currentLanguage containsString:@"Hant"]){//繁体
//        lang = @"zh-tw";
//    }else{//简体
//        lang = ThAI;
//    }
//
//    vc.cookieValue = [NSString stringWithFormat:@"document.cookie = 'odrtoken1=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';document.cookie = 'odrtrade_id=%@';document.cookie = 'odruserId=%@'",kUserInfo.token,[Utilities randomUUID],lang,tradeId,@(kUserInfo.uid)];
    HBChatWebViewController *vc = [HBChatWebViewController new];
    vc.tradeID = tradeId;
    kNavPush(vc);
    
}


#pragma mark - 查询事件
/**  查询可用取消次数  */
-(void)checkCancelTime
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/day_cancel_count"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSInteger count = [[responseObj ksObjectForKey:kData][@"flag"]integerValue];
            if (count > 1) {
                [self showCancelTipsViewWith:count];
                
            }else if (count == 1){
                [self showCancelTipsViewWith:count];
            }else{
                [self showTips:kLocat(@"OTC_buyDetail_reachmaxcount")];
            }
        }
    }];
}



-(void)showCancelTipsViewWith:(NSInteger)count
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 211 *kScreenHeightRatio, kScreenW - 56, 210)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 67) text:kLocat(@"OTC_buyDetail_canceldeal") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, midView.height - 45, midView.width/2, 45) title:kLocat(@"net_alert_load_message_cancel") titleColor:kColorFromStr(@"#31AAD7") font:PFRegularFont(16) titleAlignment:YES];
    __weak typeof(self)weakSelf = self;

    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*   sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, midView.height - 45, midView.width/2, 45) title:kLocat(@"net_alert_load_message_sure") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");
    
    [confirmlButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [weakSelf cancelOrderAction:sender flag:NO];
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom, midView.width - 56, 40) text:kLocat(@"OTC_buyDetail_maxcounttips") font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    
    UIButton *midButton = [[UIButton alloc] initWithFrame:kRectMake(0, 125, 170, 16) title:kLocat(@"OTC_buyDetail_notyetpay") titleColor:kColorFromStr(@"#707589") font:PFRegularFont(14) titleAlignment:YES];
    [midView addSubview:midButton];
    [midButton setImage:kImageFromStr(@"fu_icon_xno") forState:UIControlStateNormal];
    [midButton setImage:kImageFromStr(@"fu_icon_xpre") forState:UIControlStateSelected];
    [midButton alignHorizontal];
    [midButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        sender.selected = !sender.selected;
    }];
    _confirmCancelButton = midButton;
    
    if (count > 1) {
        tipsLabel.hidden = YES;
        midButton.y = 100;
    }
}

-(UILabel *)tipsLabel
{
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 0, kScreenW - 24, 12) text:@"" font:PFRegularFont(12) textColor:kColorFromStr(@"#979CAD") textAlignment:1 adjustsFont:YES];
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}


-(NSArray *)topArr
{
    if (_topArr == nil) {
        
        if ([_model.type isEqualToString:@"buy"]) {
//            _topArr = @[@"賣出方",@"幣種"];
            _topArr = @[kLocat(@"OTC_order_seller"),kLocat(@"OTC_order_currency")];

        }else{
//            _topArr = @[@"買入方",@"幣種"];
            _topArr = @[kLocat(@"OTC_order_buyer"),kLocat(@"OTC_order_currency")];

        }
    }
    return _topArr;
}
-(NSArray *)midArr
{
    if (!_midArr) {
//        _midArr = @[@"訂單金額",@"交易數量",@"手續費",@"實際扣除"];
        _midArr = @[kLocat(@"OTC_ordersum"),kLocat(@"OTC_order_dealvolume"),kLocat(@"OTC_fee"),kLocat(@"OTC_order_realcost")];

    }
    return _midArr;
}
-(NSArray *)bottomArr
{
    if (!_bottomArr) {
//        _bottomArr = @[@"付款參考號",@"訂單號",@"訂單時間",@"支付方式"];
        _bottomArr = @[kLocat(@"OTC_payreference"),kLocat(@"OTC_ordernumber"),kLocat(@"OTC_ordertime"),kLocat(@"k_popview_1"),];

    }
    return _bottomArr;
}



-(void)configureTimeLabel
{
    _second--;
    NSString *str;
    if (_second > 0) {
        

        str = [NSString stringWithFormat:@"您還需等待  %@",[Utilities returnTimeWithSecond:_second formatter:@"mm分ss秒"]];
        _appealButton.enabled = NO;
        
        str = [str stringByReplacingOccurrencesOfString:@"您還需等待" withString:kLocat(@"OTC_order_youneedtowait")];
        str = [str stringByReplacingOccurrencesOfString:@"分" withString:kLocat(@"OTC_minute")];
        str = [str stringByReplacingOccurrencesOfString:@"秒" withString:kLocat(@"OTC_second")];

//        str = [NSString stringWithFormat:@"%@  %@",kLocat(@"OTC_order_youneedtowait"),[Utilities returnTimeWithSecond:_second formatter:[NSString stringWithFormat:@"mm%@ss%@",kLocat(@"OTC_minute"),kLocat(@"OTC_second")]]];
        
        
        
        _appealButton.enabled = NO;
    }else{
//        str = @"您還需等待  0分0秒";
        str = [NSString stringWithFormat:@"%@  0%@0%@",kLocat(@"OTC_order_youneedtowait"),kLocat(@"OTC_minute"),kLocat(@"OTC_second")];
        [self.timer invalidate];
        _appealButton.enabled = YES;
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range1 = [str rangeOfString:[NSString stringWithFormat:@"%@  ",kLocat(@"OTC_order_youneedtowait")]];
    [attr addAttribute:NSForegroundColorAttributeName value:kLightGrayColor range:range1];
    [attr addAttribute:NSFontAttributeName value:PFRegularFont(14) range:range1];
    
    NSRange range2 = NSMakeRange(kLocat(@"OTC_order_youneedtowait").length + 2, str.length- kLocat(@"OTC_order_youneedtowait").length - 2);
    [attr addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#F52657") range:range2];
    [attr addAttribute:NSFontAttributeName value:PFRegularFont(19) range:range2];
    
    _timeLabel.attributedText = attr;
}


-(void)dealloc
{
    [_timer invalidate];
}
-(void)backAction
{
    if (_isFromBuyConfirmOrderVC) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[TPBaseOTCViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }else{
        
        if (_type == TPOTCOrderDetailControllerTypeAppleal) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[TPOTCOrderBaseController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[TPOTCBaseADController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[TPBaseOTCViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            
            [super backAction];
        }else{
            [super backAction];
        }
    }

}

#pragma mark - ZJPayPopupViewDelegate

- (void)didPasswordInputFinished:(NSString *)password {
    [self.payPopupView hidePayPopView];
    if (password.length > 0) {
        [self permitActionWithPwd:password];
    }
    
}

#pragma mark - HBOTCOrderDetailAlertViewDelegate

- (void)didSelectSureWithOrderDetailAlertView:(HBOTCOrderDetailAlertView *)view {
    self.payPopupView = [ZJPayPopupView new];
    self.payPopupView.delegate = self;
}


#pragma mark - Getters

- (HBOTCOrderDetailAlertView *)tipsAlertView {
    if (!_tipsAlertView) {
        _tipsAlertView = [HBOTCOrderDetailAlertView loadNibView];
        _tipsAlertView.delegate = self;
    }
    
    return _tipsAlertView;
}

@end
