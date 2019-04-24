


//
//  TPOTCADDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCADDetailController.h"
#import "TPOTCADListMidCell.h"
#import "TPOTCADDoneTopCell.h"
#import "TPOTCADCurrentTopCell.h"
#import "TPOTCADDetailListCell.h"
#import "TPOTCSingleOrderModel.h"
#import "TPOTCOrderDetailController.h"
#import "TPOTCTradeListModel.h"
#import "HBMyADDetailHeaderView.h"
#import "HBChatWebViewController.h"
#import "HBOTCTradeInfoDetailTableViewController.h"

@interface TPOTCADDetailController ()<UITableViewDelegate,UITableViewDataSource, HBMyADDetailHeaderViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

//@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isNew;
@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *rightLabel;
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *rightView;

/**  新消息  */
@property(nonatomic,strong)NSMutableArray<TPOTCSingleOrderModel *> *nwOrderArray;
/**  已完成  */
@property(nonatomic,strong)NSMutableArray<TPOTCSingleOrderModel *> *doneOrderArray;
@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,assign)NSInteger nwPage;
@property(nonatomic,assign)NSInteger donePage;

@property (nonatomic, strong) HBMyADDetailHeaderView *detailHeaderView;

@end

@implementation TPOTCADDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _dataArray = [NSMutableArray array];
    _isNew = YES;
    _nwPage = 1;
    _donePage = 1;
    _nwOrderArray = [NSMutableArray array];
    _doneOrderArray = [NSMutableArray array];
    [self setupUI];


    [self loadDataWith:_nwPage];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"kUserDidPermitTheOrderKey" object:nil];

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
}

-(void)setupUI
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.title = kLocat(@"OTC_ad_addetail");
    self.view.backgroundColor = kColorFromStr(@"#171F34");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStylePlain];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADDoneTopCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADDoneTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADListMidCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADListMidCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADCurrentTopCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADCurrentTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADDetailListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADDetailListCell"];

    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isRefresh = YES;
        if (_isNew) {
            _nwPage = 1;
            [weakSelf loadDataWith:_nwPage];
        }else{
            _donePage = 1;
            [weakSelf loadDataWith:_donePage];
        }
    }];
    self.detailHeaderView = [HBMyADDetailHeaderView viewLoadNib];
    _tableView.tableHeaderView = self.detailHeaderView;
    [self.detailHeaderView configureCellWithModel:self.model isHistory:self.isHistory];
    self.detailHeaderView.delegate = self;
    
}
-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"page"] = @(page);
    param[@"orders_id"] = _model.orders_id;
    
    if (_isNew) {
        param[@"complete"] = @"0";
    }else{
        param[@"complete"] = @"1";
    }
    
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/orders_trade_log"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            if (_isNew) {
                if (datas.count == 0 && _nwOrderArray.count == 0) {
                    [self showTips:kLocat(@"OTC_order_norecord")];
                    [weakSelf.tableView reloadData];
                    return ;
                }
                if (page == 1) {
                    [_nwOrderArray removeAllObjects];
                }
                for (NSDictionary *dic in datas) {
                    TPOTCSingleOrderModel *model = [TPOTCSingleOrderModel modelWithJSON:dic];
                    [self.nwOrderArray addObject:model];
                }
            }else{
                if (datas.count == 0 && _doneOrderArray.count == 0) {
                    [self showTips:kLocat(@"OTC_order_norecord")];
                    [weakSelf.tableView reloadData];
                    return ;
                }
                if (page == 1) {
                    [_doneOrderArray removeAllObjects];
                }
                for (NSDictionary *dic in datas) {
                    TPOTCSingleOrderModel *model = [TPOTCSingleOrderModel modelWithJSON:dic];
                    [self.doneOrderArray addObject:model];
                }
            }
            
            [weakSelf.tableView reloadData];
            
            _isRefresh = NO;
            if (datas.count >= 10) {
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        
                        if (_isNew) {
                            _nwPage ++;
                            [weakSelf loadDataWith:_nwPage];
                        }else{
                            _donePage++;
                            [weakSelf loadDataWith:_donePage];
                        }
                    }
                    _isRefresh = YES;
                }];
                [footer setTitle:kLocat(@"R_Loading") forState:MJRefreshStateRefreshing];
                _tableView.mj_footer = footer;
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                //                _tableView.mj_footer = nil;
            }
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isNew) {
        return self.nwOrderArray.count;
    }else{
        return self.doneOrderArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPOTCADDetailListCell";
    TPOTCADDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    if (_isNew) {//新消息
        cell.model = self.nwOrderArray[indexPath.row];
    }else{//已完成
        cell.model = self.doneOrderArray[indexPath.row];
    }
    cell.msgButton.tag = indexPath.row;
    [cell.msgButton addTarget:self action:@selector(showMsgVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

-(void)showMsgVC:(UIButton *)button
{
    NSString *tradeId;
    if (_isNew) {
        tradeId = self.nwOrderArray[button.tag].trade_id;
    }else{
        tradeId = self.doneOrderArray[button.tag].trade_id;
    }
//
//    BaseWebViewController *vc = [[BaseWebViewController alloc] init];
//    vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,@"/Api/Jim/chat"];
//    vc.showNaviBar = YES;
//    vc.webViewFrame = kRectMake(0, 0, kScreenW, kScreenH -kNavigationBarHeight);
//    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
//    NSString *lang = nil;
//    if ([currentLanguage containsString:@"en"]) {//英文
//        lang = @"en-us";
//    }else if ([currentLanguage containsString:@"Hant"]){//繁体
//        lang = @"zh-tw";
//    }else{//简体
//        lang = ThAI;
//    }
//    vc.cookieValue = [NSString stringWithFormat:@"document.cookie = 'odrtoken1=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';document.cookie = 'odrtrade_id=%@';document.cookie = 'odruserId=%@'",kUserInfo.token,[Utilities randomUUID],lang,tradeId,@(kUserInfo.uid)];
//    vc.titleString = kLocat(@"OTC_buyDetail_chat");
    HBChatWebViewController *vc = [HBChatWebViewController new];
    vc.tradeID = tradeId;
    kNavPush(vc);
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130 + 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 40)];
    view.backgroundColor = kColorFromStr(@"#0B132A");
    
    UIView *lineView111 = [[UIView alloc] initWithFrame:CGRectMake(0, 38, kScreenW, 3)];
    lineView111.backgroundColor = kColorFromStr(@"#171F34");
    [view addSubview:lineView111];
    
    
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:kRectMake(95 *kScreenWidthRatio, 0, 48, view.height) text:kLocat(@"OTC_ad_newmsg") font:PFRegularFont(16) textColor:kColorFromStr(@"#979CAD") textAlignment:1 adjustsFont:YES];
    [view addSubview:leftLabel];
    leftLabel.userInteractionEnabled = YES;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, leftLabel.width, 2)];
    lineView.backgroundColor = kColorFromStr(@"#DFB900");
    [view addSubview:lineView];
    lineView.centerX = leftLabel.centerX;
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:kRectMake(95 *kScreenWidthRatio, 0, 48, view.height) text:kLocat(@"OTC_order_done") font:PFRegularFont(16) textColor:kColorFromStr(@"#979CAD") textAlignment:1 adjustsFont:YES];
    [view addSubview:rightLabel];
    rightLabel.right = kScreenW - 95 *kScreenWidthRatio;
    rightLabel.userInteractionEnabled = YES;
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 38, leftLabel.width, 2)];
    lineView1.backgroundColor = kColorFromStr(@"#DFB900");
    [view addSubview:lineView1];
    lineView1.centerX = rightLabel.centerX;
    
    [leftLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTapAction:)]];
    [rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTapAction:)]];
    
    _leftView = lineView;
    _rightView = lineView1;
    _leftLabel = leftLabel;
    _rightLabel = rightLabel;
    _leftLabel.tag = 0;
    _rightLabel.tag = 1;
    
    if (_isNew) {
        _rightLabel.textColor = kDarkGrayColor;
        _leftLabel.textColor = kColorFromStr(@"#DFB900");
    }else{
        _rightLabel.textColor = kColorFromStr(@"#DFB900");
        _leftLabel.textColor = kDarkGrayColor;
    }
    
    _leftView.hidden = !_isNew;
    _rightView.hidden = _isNew;
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 5)];
    view.backgroundColor = kColorFromStr(@"#171F34");
    return view;
}
-(void)headViewTapAction:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 0) {
        if (_isNew) {
            return;
        }else{
            _isNew = YES;

            [self.tableView reloadData];
        }
    }else{
        if (_isNew) {
            _isNew = NO;
            
            if (_doneOrderArray.count == 0) {
                [self loadDataWith:_donePage];
            }else{
                
                [self.tableView reloadData];
            }
            
        }else{
            return;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TPOTCSingleOrderModel *model;
        if (_isNew) {
            model = self.nwOrderArray[indexPath.row];
        }else{
            model = self.doneOrderArray[indexPath.row];
        }
        
        HBOTCTradeInfoDetailTableViewController *svc = [HBOTCTradeInfoDetailTableViewController fromStoryboard];
        svc.tradeID = model.trade_id;
        kNavPush(svc);
    }
}





-(void)cancelAdAction:(UIButton *)button
{
    [button.superview.superview removeFromSuperview];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"orders_id"] = _model.orders_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {

            [self showTips:[responseObj ksObjectForKey:kMessage]];
            
            TPCurrencyModel *model = [TPCurrencyModel new];
            model.currencyID = _currencyID;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuserDidCancelAdActionKey" object:model];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });

        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}



-(void)showTipsView:(UIButton *)button
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 190 *kScreenHeightRatio, kScreenW - 56, 195)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 63) text:kLocat(@"OTC_ad_cancel_warning") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
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
    confirmlButton.tag = button.tag;
    [confirmlButton addTarget:self action:@selector(cancelAdAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *tips = kLocat(@"OTC_ad_canceltips1");
    tips = [tips stringByReplacingOccurrencesOfString:@"XXX" withString:self.model.currency_otc_cancel_fee];
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom-15, midView.width - 56, midView.height - 45 - titleLabel.height) text:tips font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
}



-(void)refreshData
{
    _nwPage = 1;
    [self loadDataWith:_nwPage];
}

#pragma mark - HBMyADDetailHeaderViewDelegate

- (void)cancelWithMyADDetailHeaderView:(HBMyADDetailHeaderView *)view {
    [self showTipsView:view.cancelButton];
}

@end
