//
//  TPOTCBuyOrderDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyOrderDetailController.h"
#import "TPOTCBuyDetaiHeadView.h"
#import "TPOTCBuyDetailPayWayNotCardCell.h"
#import "TPOTCBuyDetailPayWayCardCell.h"
#import "TPOTCBuyDetailBottomCell.h"
#import "TPOTCBuyConfirmOrderController.h"
#import "TPOTCProfileViewController.h"
#import "WeakTimeObject.h"
#import "HBChatWebViewController.h"

@interface TPOTCBuyOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)TPOTCBuyDetaiHeadView *headView;

@property(nonatomic,strong)NSDictionary *tradeInfo;

@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,strong)UIButton *confirmCancelButton;

@property(nonatomic,assign)NSInteger limitTime;
@property(nonatomic,strong)NSTimer *timer;


@end

@implementation TPOTCBuyOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    _selectedIndex = 100;
    [self setupUI];

    [self loadData];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


-(void)setupUI
{

    self.title = kLocat(@"OTC_buyDetail_buydetail");
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH - 45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kColorFromStr(@"#171f34");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCBuyDetailPayWayNotCardCell" bundle:nil] forCellReuseIdentifier:@"TPOTCBuyDetailPayWayNotCardCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCBuyDetailPayWayCardCell" bundle:nil] forCellReuseIdentifier:@"TPOTCBuyDetailPayWayCardCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCBuyDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"TPOTCBuyDetailBottomCell"];

    
    
    
    TPOTCBuyDetaiHeadView *headView =  [[[NSBundle mainBundle] loadNibNamed:@"TPOTCBuyDetaiHeadView" owner:nil options:nil] lastObject];
    headView.frame = kRectMake(0, 0, kScreenW, 90);
    _tableView.tableHeaderView = headView;
    _headView = headView;
    [self createBottomView];
}


-(void)createBottomView
{
    __weak typeof(self)weakSelf = self;

    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH - 45 - kNavigationBarHeight, kScreenW, 45)];
    bgView.backgroundColor = kColorFromStr(@"6B758F");
    UIButton *msgButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 65*kScreenWidthRatio, 45) title:nil titleColor:nil font:PFRegularFont(12) titleAlignment:0];
    [bgView addSubview:msgButton];
    msgButton.backgroundColor = kClearColor;

    [msgButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        BaseWebViewController *vc = [[BaseWebViewController alloc] init];
//        vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,@"/Api/Jim/chat"];
//        vc.showNaviBar = YES;
//        vc.webViewFrame = kRectMake(0, 0, kScreenW, kScreenH -kNavigationBarHeight);
//        NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
//        NSString *lang = nil;
//        if ([currentLanguage containsString:@"en"]) {//英文
//            lang = @"en-us";
//        }else if ([currentLanguage containsString:@"Hant"]){//繁体
//            lang = @"zh-tw";
//        }else{//简体
//            lang = ThAI;
//        }
//        vc.cookieValue = [NSString stringWithFormat:@"document.cookie = 'odrtoken1=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';document.cookie = 'odrtrade_id=%@';document.cookie = 'odruserId=%@'",kUserInfo.token,[Utilities randomUUID],lang,_trade_id,@(kUserInfo.uid)];
//        vc.titleString = kLocat(@"OTC_buyDetail_chat");
        HBChatWebViewController *vc = [HBChatWebViewController new];
        vc.tradeID = _trade_id;
        kNavPushSafe(vc);
    }];
    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:kImageFromStr(@"mai_icon_xxi")];
    [msgButton addSubview:img];
    [img alignHorizontal];
    [img alignVertical];

    
    
    CGFloat w = (kScreenW - 65 * kScreenWidthRatio)/2.0;
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(65 * kScreenWidthRatio, 0, w, bgView.height) title:kLocat(@"OTC_buyDetail_canceldeal") titleColor:kColorFromStr(@"#9BBBEB") font:PFRegularFont(16) titleAlignment:0];
    cancelButton.backgroundColor = kColorFromStr(@"#434A5D");
    [bgView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(checkCancelTime) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *dealButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, 0, w, bgView.height) title:kLocat(@"OTC_buyDetail_topay") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    dealButton.backgroundColor = kColorFromStr(@"#11B1ED");
    [bgView addSubview:dealButton];
    

    [dealButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {

        if (weakSelf.limitTime <= 0) {
            [weakSelf showTips:kLocat(@"OTC_buyDetail_paydelay")];
        }else{
            [weakSelf toPayAction];
        }

    }];

    [self.view addSubview:bgView];
}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _trade_id;
    __weak typeof(self)weakSelf = self;

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/trade_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            if ([dic[@"type"] isEqualToString:@"sell"]) {
                weakSelf.headView.currencyNameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_sell"),dic[@"currency_name"]];
            }else{
                weakSelf.headView.currencyNameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_buy"),dic[@"currency_name"]];
            }
            _tradeInfo = dic;
            
            [weakSelf.tableView reloadData];
            
            _limitTime = [_tradeInfo[@"limit_time"] integerValue];

//            weakSelf.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
//                [weakSelf countDown];
//            } userInfo:nil repeats:YES];
//
//            [weakSelf.timer fire];
            
            weakSelf.timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];

            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_tradeInfo) {
            return [_tradeInfo[@"bank_list"] count];
        }else{
            return 0;
        }
    }
    if (_tradeInfo) {
        return self.titleArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
//        if (indexPath.row < 2) {
        
            static NSString *rid = @"TPOTCBuyDetailPayWayNotCardCell";
            TPOTCBuyDetailPayWayNotCardCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
        NSString *type = _tradeInfo[@"bank_list"][indexPath.row];
        
        if ([type hasPrefix:kWechat]) {
            cell.icon.image = kImageFromStr(@"gmxq_icon_wx");
            cell.wayLabel.text = kLocat(@"k_PAYViewController_typew");
        }else if ([type hasPrefix:kZFB]){
            cell.icon.image = kImageFromStr(@"gmxq_icon_zfb");
            cell.wayLabel.text = kLocat(@"k_PAYViewController_typea");
        }else{
            cell.icon.image = kImageFromStr(@"gmxq_icon_yhk");
            cell.wayLabel.text = kLocat(@"k_PAYViewController_typec");
        }
        
        cell.lineView.hidden = indexPath.row == [_tradeInfo[@"bank_list"] count]-1;
 
        if (_selectedIndex == indexPath.row) {
            cell.wayButton.selected = YES;
        }else{
            cell.wayButton.selected = NO;
        }
 
        
            return cell;
//        }else{
//            static NSString *rid = @"TPOTCBuyDetailPayWayCardCell";
//            TPOTCBuyDetailPayWayCardCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//            if (cell == nil) {
//                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
//            }
//
//            return cell;
//        }
  
    }else{
        static NSString *rid = @"TPOTCBuyDetailBottomCell";
        TPOTCBuyDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.itemLabel.text = self.titleArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.cpyLabel.textColor = kColorFromStr(@"#9BBBEB");
        }else{
            cell.cpyLabel.textColor = kColorFromStr(@"#CDD2E3");
        }
        
        if (indexPath.row == 0) {
            
            [self confirgureCell:cell SubViewsWithButton:NO imageStr:@"fu_icon_fuzhi" infoLabelIsHidden:YES infoStr:@"" copyString:[NSString stringWithFormat:@"%@ CNY",_tradeInfo[@"money"]] copyLabelIsHidden:NO];
//            cell.cpyLabel.textColor = kColorFromStr(@"#9BBBEB");
            
        }else if (indexPath.row == 1){
            [self confirgureCell:cell SubViewsWithButton:YES imageStr:@"fu_icon_fuzhi" infoLabelIsHidden:NO infoStr:[NSString stringWithFormat:@"%@ CNY/%@",_tradeInfo[@"price"],_tradeInfo[@"currency_name"]] copyString:@"25,890.23 CNY" copyLabelIsHidden:YES];
        }else if (indexPath.row == 2){
            [self confirgureCell:cell SubViewsWithButton:YES imageStr:@"fu_icon_fuzhi" infoLabelIsHidden:NO infoStr:[NSString stringWithFormat:@"%@ %@",_tradeInfo[@"num"],_tradeInfo[@"currency_name"]] copyString:@"25,890.23 CNY" copyLabelIsHidden:YES];
        }else if (indexPath.row == 3){
            [self confirgureCell:cell SubViewsWithButton:NO imageStr:@"fu_icon_fuzhi" infoLabelIsHidden:YES infoStr:@"" copyString:[NSString stringWithFormat:@"#%@",_tradeInfo[@"only_number"]] copyLabelIsHidden:NO];
        }else if (indexPath.row == 4){
             [self confirgureCell:cell SubViewsWithButton:NO imageStr:@"fu_icon_fuzhi" infoLabelIsHidden:YES infoStr:@"" copyString:[NSString stringWithFormat:@"%@",_tradeInfo[@"pay_number"]] copyLabelIsHidden:NO];
        }else if (indexPath.row == 5){
            [self confirgureCell:cell SubViewsWithButton:YES imageStr:@"fu_icon_fuzhi" infoLabelIsHidden:NO infoStr:[NSString stringWithFormat:@"%@",[_tradeInfo ksObjectForKey:@"add_time"]] copyString:@"25,890.23 CNY" copyLabelIsHidden:YES];
        }else if (indexPath.row == 6){
            
            [self confirgureCell:cell SubViewsWithButton:NO imageStr:@"user_icon_getin" infoLabelIsHidden:YES infoStr:@"" copyString:[_tradeInfo ksObjectForKey:@"username"] copyLabelIsHidden:NO];
        }
        
        cell.cpyButton.tag = indexPath.row;
        [cell.cpyButton addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
}
-(void)confirgureCell:(TPOTCBuyDetailBottomCell*)cell SubViewsWithButton:(BOOL)isHidden imageStr:(NSString *)image infoLabelIsHidden:(BOOL)infoLabelHiddden infoStr:(NSString *)infoStr copyString:(NSString *)copyStr copyLabelIsHidden:(BOOL)copyLabelHidden
{
    cell.cpyButton.hidden = isHidden;
    [cell.cpyButton setImage:kImageFromStr(image) forState:UIControlStateNormal];
    
    cell.infoLabel.hidden = infoLabelHiddden;
    cell.infoLabel.text = infoStr;
    
    cell.cpyLabel.hidden = copyLabelHidden;
    cell.cpyLabel.text = copyStr;
}


#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        _selectedIndex = indexPath.row;
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 6) {
            TPOTCProfileViewController *vc = [TPOTCProfileViewController new];
            vc.memberID = _tradeInfo[@"other_member"];
            kNavPush(vc);
        }
    }
}
/**  复制  */
-(void)copyAction:(UIButton *)button
{
    if (button.tag == 0) {
        [UIPasteboard generalPasteboard].string = _tradeInfo[@"money"];
    }else if(button.tag == 3){
        [UIPasteboard generalPasteboard].string = _tradeInfo[@"only_number"];

    }else if (button.tag == 4){
        [UIPasteboard generalPasteboard].string = _tradeInfo[@"pay_number"];
    }
    [self showTips:kLocat(@"OTC_copySuccess")];

}

/**  去支付  */
-(void)toPayAction
{
    if (_selectedIndex > 10) {
        [self showTips:kLocat(@"OTC_buyDetail_choosepayway")];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _trade_id;
    
    param[@"money_type"] = _tradeInfo[@"bank_list"][_selectedIndex];
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/choose_bank"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            TPOTCBuyConfirmOrderController *vc = [TPOTCBuyConfirmOrderController new];
            vc.trade_id = _trade_id;
            kNavPush(vc);
            
        }else{
            [self showTips: [responseObj ksObjectForKey:kMessage]];
        }
    }];
}


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

//                [self cancelOrderAction:nil flag:YES];
            }else if (count == 1){
                [self showCancelTipsViewWith:count];
            }else{
                [self showTips:kLocat(@"OTC_buyDetail_reachmaxcount")];
            }
        }
    }];
}
-(void)cancelOrderAction:(UIButton *)button flag:(BOOL)toDelete
{
    if (toDelete == NO && _confirmCancelButton.selected == NO) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = _trade_id;
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
            });
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
//        if (indexPath.row == 2) {
//            return 100;
//        }else{
//            return  60;
//        }
    }else{
        return 38;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 15;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, midView.height - 45, midView.width/2, 45) title:kLocat(@"net_alert_load_message_sure") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");
    
    __weak typeof(self)weakSelf = self;
    [confirmlButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [weakSelf cancelOrderAction:sender flag:NO];
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom, midView.width - 56, 40) text:kLocat(@"OTC_buyDetail_maxcounttips") font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    
    UIButton *midButton = [[UIButton alloc] initWithFrame:kRectMake(0, 125, midView.width, 16) title:kLocat(@"OTC_buyDetail_notyetpay") titleColor:kColorFromStr(@"#707589") font:PFRegularFont(14) titleAlignment:YES];
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
-(void)countDown
{
    _limitTime--;
//    NSLog(@"%zd",_limitTime);
    __weak typeof(self)weakSelf = self;
    
    if (_limitTime > 0) {
        _headView.leftTimeLabel.text = [NSString stringWithFormat:@"剩%@",[Utilities returnTimeWithSecond:_limitTime formatter:@"mm分ss秒"]];
        
        if ([_headView.leftTimeLabel.text containsString:@"剩"]) {
            _headView.leftTimeLabel.text = [_headView.leftTimeLabel.text stringByReplacingOccurrencesOfString:@"剩" withString:kLocat(@"OTC_left")];
        }
        if ([_headView.leftTimeLabel.text containsString:@"分"]) {
            _headView.leftTimeLabel.text = [_headView.leftTimeLabel.text stringByReplacingOccurrencesOfString:@"分" withString:kLocat(@"OTC_minute")];
        }
        if ([_headView.leftTimeLabel.text containsString:@"秒"]) {
            _headView.leftTimeLabel.text = [_headView.leftTimeLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:kLocat(@"OTC_second")];
        }
//        _headView.leftTimeLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_left"),[Utilities returnTimeWithSecond:_limitTime formatter:[NSString stringWithFormat:@"mm%@ss%@",kLocat(@"OTC_minute"),kLocat(@"OTC_second")]]];
        
        
    }else{
//        _headView.leftTimeLabel.text = @"剩0分0秒";
        _headView.leftTimeLabel.text = [NSString stringWithFormat:@"%@0%@0%@",kLocat(@"OTC_left"),kLocat(@"OTC_minute"),kLocat(@"OTC_second")];

        [weakSelf.timer invalidate];
    }
}

-(NSArray *)titleArray
{
    if (_titleArray == nil) {
//        _titleArray = @[@"訂單金額",@"單價",kLocat(@"k_HBTradeJLViewController_count"),@"訂單號",@"付款參考號",@"訂單時間",@"賣家"];
        
        _titleArray = @[kLocat(@"OTC_ordersum"),kLocat(@"OTC_sinleprice"),kLocat(@"k_HBTradeJLViewController_count"),kLocat(@"OTC_ordernumber"),kLocat(@"OTC_payreference"),kLocat(@"OTC_ordertime"),kLocat(@"OTC_seller")];
    }
    return _titleArray;
}

-(void)dealloc
{
//    [super dealloc];
    NSLog(@"======");
    [_timer invalidate];
    _timer = nil;
    
}

@end
