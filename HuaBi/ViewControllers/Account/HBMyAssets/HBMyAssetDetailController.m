//
//  HBMyAssetDetailController.m
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetDetailController.h"
#import "HBMyAssetDetailTopView.h"
#import "HBMyAssetDetailListCell.h"
#import "HBMyAssetReleaseController.h"
#import "HBMyAssetExchangeController.h"

#import "MyassetDetailItemTableViewCell.h"
#import "YTMyassetDetailModel.h"
#import "HBMyAssetsFilterMenuViewController.h"
#import "UIImage+YYAdd.h"
#import "FinLogApi.h"
#import "HBAssetDetailViewController.h"
#import "HBMyAssetsFilterModel.h"
#import "YWAlert.h"
#import "HBMyAssetCurrencyModel.h"
#import "HBToLockTableViewController.h"
#import "HBMyKokAssetHeaderCell.h"
#import "HBTokenTopUpTableViewController.h"
#import "HBTokenWithdrawViewController.h"

@interface HBMyAssetDetailController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *nwView;

@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) HBMyAssetsFilterMenuViewController *menuVC;
@property (nonatomic, strong) FinLogApi *api;
@property (nonatomic, strong) HBMyAssetCurrencyModel *myAssetCurrencyModel;

@end

static NSString *const kHBMyKokAssetHeaderCellIdentifier = @"HBMyKokAssetHeaderCell";

@implementation HBMyAssetDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _dataArray = [NSMutableArray array];
 
    [self setupUI];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCurrencyInfo) name:@"kHBMyAssetExchangeControllerUserDidExchangeSuccessKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCurrencyInfo) name:@"kHBMyAssetExchangeControllerUserDidExchangeSuccessKey" object:nil];
    
}



-(void)setupUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight - 50) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"HBMyAssetDetailTopView" bundle:nil] forCellReuseIdentifier:@"HBMyAssetDetailTopView"];
    [_tableView registerNib:[UINib nibWithNibName:@"HBMyAssetDetailListCell" bundle:nil] forCellReuseIdentifier:@"HBMyAssetDetailListCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MyassetDetailItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyassetDetailItemTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:kHBMyKokAssetHeaderCellIdentifier bundle:nil] forCellReuseIdentifier:kHBMyKokAssetHeaderCellIdentifier];
  
    self.api = [FinLogApi new];
    self.api.currency_id = self.current_id;
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
        [sself loadCurrencyInfo];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api loadNextPage];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self setupButtonView];
//    [self setupRightBarItem];
}

- (void)setupRightBarItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [button setTitle:kLocat(@"k_MyassetDetailViewController_tableview_header_selectBtn") forState:UIControlStateNormal];
    [button setTitleColor:kColorFromStr(@"#4173C7") forState:UIControlStateNormal];
    UIImage *image = [[UIImage imageNamed:@"sxuan_icon"] imageByTintColor:kColorFromStr(@"#4173C7")];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_showFilterMenuVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)_showFilterMenuVC {
    [self.menuVC show];
}

-(void)setupButtonView
{

    CGFloat h = 50;
    UIView *btView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH - kNavigationBarHeight - h, kScreenW, h)];
    [self.view addSubview:btView];
    btView.backgroundColor = kColorFromStr(@"#4C506D");
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, h, 0);
    if ([_currencyName isEqualToString:@"KOK"]) {//KOK
        
    NSArray *titles = @[kLocat(@"Assert_detail_charge"),kLocat(@"Assert_detail_tibi"),kLocat(@"k_c2c_now_trade"),kLocat(@"Assert_detail_exchange")];
    CGFloat w = kScreenW / titles.count;//ˆˇ
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(i * w, 0, w, h) title:titles[i] titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
        [btView addSubview:button];
        button.tag = i;
        
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
            
            
            switch (sender.tag) {
                case 0:{//充币
                    if (![self _canRecharge]) {
                        return ;
                    }
                    HBTokenTopUpTableViewController *top = [HBTokenTopUpTableViewController fromStoryboard];
                    top.currencyid = _current_id;
                    top.currencyname = _currencyName;
                    kNavPush(top);
//                    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_history_in,self.current_id,[Utilities dataChangeUTC]]];
//                    kNavPush(vc);
                }
                    
                    break;
                case 1:{//提币
                    if (![self _canTake]) {
                        return ;
                    }
//                    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_history_out,self.current_id,[Utilities dataChangeUTC]]];
                    
                    HBTokenWithdrawViewController *tokenWithDraw = [HBTokenWithdrawViewController fromStoryboard];
                    tokenWithDraw.currency = _currencyName;
                    tokenWithDraw.currency_id = _current_id;
                    NSLog(@"mmmmmmm---%@",_current_id);

                    kNavPush(tokenWithDraw);
                    break;
                }
                    
                    case 2:
                    self.tabBarController.selectedIndex = 2;
                    break;
                case 3: {
                    if (![self _canExchange]) {
                        return ;
                    }
                    HBMyAssetExchangeController *vc = [HBMyAssetExchangeController new];
                    vc.dataDic = _dataDic;
                    kNavPush(vc);
                    break;
                }
                default:
                    break;
            }
        }];
        
//        if (i == titles.count - 1) {
//            [button setImage:kImageFromStr(@"Assert_x") forState:UIControlStateSelected];
//
//            [button setImage:kImageFromStr(@"Assert_s") forState:UIControlStateNormal];
////            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
////                sender.selected = !sender.isSelected;
////                weakSelf.nwView.hidden = !sender.selected;
////            }];
//        }
//        
        if (i < titles.count - 1) {//加灰线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(w - 0.5, 0, 0.5, 15)];
            lineView.backgroundColor = kColorFromStr(@"#999999");
            [button addSubview:lineView];
            [lineView alignVertical];
        }
    }
    
    UIView *nwView = [[UIView alloc] initWithFrame:kRectMake(0, btView.y - h, kScreenW, h)];
    [self.view addSubview:nwView];
    nwView.backgroundColor = btView.backgroundColor;
    
    NSArray *ntitles = @[kLocat(@"Assert_detail_release"), kLocat(@"To_Lock"), kLocat(@"Assert_detail_presetation_release_menu")];
    for (NSInteger i = 0; i < ntitles.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(i * w, 0, w, h) title:ntitles[i] titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
        [nwView addSubview:button];
        button.tag = i;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
            switch (sender.tag) {
                case 0: {//释放
                    
                    if (![self _canRelease]) {
                        return ;
                    }
                    HBMyAssetReleaseController *vc = [HBMyAssetReleaseController new];
                    vc.dataDic = _dataDic;
                    vc.currencyID = _current_id;
                    vc.currencyName = _currencyName;
                    kNavPush(vc);
                    break;
                }
                case 1: {//鎖一送一
                    HBToLockTableViewController *vc = [HBToLockTableViewController fromStoryboard];
                    kNavPush(vc);
                      break;
                }
                case 2: {//贈送釋放
                    
                    if (![self _canReleaseOfAward]) {
                        return;
                    }
                    HBMyAssetReleaseController *vc = [HBMyAssetReleaseController new];
                    vc.dataDic = _dataDic;
                    vc.currencyID = _current_id;
                    vc.currencyName = _currencyName;
                    vc.isPresentation = YES;
                    kNavPush(vc);
                    break;
                }
                  
                default:
                    break;
            }
        }];
 
        if (i < ntitles.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(w - 0.5, 0, 0.5, 15)];
            lineView.backgroundColor = kColorFromStr(@"#999999");
            [button addSubview:lineView];
            [lineView alignVertical];
        }
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, h - 0.5, kScreenW-24, 0.5)];
    lineView.backgroundColor = kColorFromStr(@"#0B132A");
    [nwView addSubview:lineView];
//    nwView.hidden = YES;
    _nwView = nwView;
    }else{//其他币 包括KOKcy
        NSArray *titles = @[kLocat(@"Assert_detail_charge"),kLocat(@"Assert_detail_tibi"),kLocat(@"k_c2c_now_trade")];
        
        
        CGFloat w = kScreenW / titles.count;//ˆˇ
        for (NSInteger i = 0; i < titles.count; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(i * w, 0, w, h) title:titles[i] titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
            [btView addSubview:button];
            button.tag = i;
            
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
                if (sender.tag == 0) {//充币
                    BOOL canRecharge = [self _canRecharge];
                    if (canRecharge) {
                        HBTokenTopUpTableViewController *top = [HBTokenTopUpTableViewController fromStoryboard];
                        top.currencyid = _current_id;
                        top.currencyname = _currencyName;
                        kNavPush(top);
                        //              kNavPush([HBTokenWithdrawViewController fromStoryboard]);
//                        BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_history_in,self.current_id,[Utilities dataChangeUTC]]];
//                        kNavPush(vc);
                    }
                    

                    
                }else if (sender.tag == 1){//提币
                    BOOL canTake = [self _canTake];
                    if (canTake) {
//                    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_history_out,self.current_id,[Utilities dataChangeUTC]]];
//                    kNavPush(vc);
                        HBTokenWithdrawViewController *tokenWithDraw = [HBTokenWithdrawViewController fromStoryboard];
                        tokenWithDraw.currency = _currencyName;
                        tokenWithDraw.currency_id = _current_id;
                        NSLog(@"mmmmmmm---%@",_current_id);
                        kNavPush(tokenWithDraw);

                    }
                }else{//交易&&释放
                    self.tabBarController.selectedIndex = 2;
                }
            }];
            
            if (i < titles.count - 1) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(w - 0.5, 0, 0.5, 15)];
                lineView.backgroundColor = kColorFromStr(@"#999999");
                [button addSubview:lineView];
                [lineView alignVertical];
            }
        }
        
        UIView *nwView = [[UIView alloc] initWithFrame:kRectMake(0, btView.y - h, kScreenW, h)];
        [self.view addSubview:nwView];
        nwView.backgroundColor = btView.backgroundColor;
        
    
        NSArray *ntitles = @[kLocat(@"Assert_detail_release"), kLocat(@"Assert_detail_presetation_release_menu")];
        
        for (NSInteger i = 0; i < ntitles.count; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(i * w, 0, w, h) title:ntitles[i] titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
            [nwView addSubview:button];
            
            button.tag = i;
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
                switch (sender.tag) {
                    case 0: {//锁仓释放
                        
                        if (![self _canRelease]) {
                            return ;
                        }
                        HBMyAssetReleaseController *vc = [HBMyAssetReleaseController new];
                        vc.dataDic = _dataDic;
                        vc.currencyID = _current_id;
                        vc.currencyName = _currencyName;
                        kNavPush(vc);
                        break;
                    }
                    case 1: {//贈送釋放
                        
                        if (![self _canReleaseOfAward]) {
                            return;
                        }
                        HBMyAssetReleaseController *vc = [HBMyAssetReleaseController new];
                        vc.dataDic = _dataDic;
                        vc.currencyID = _current_id;
                        vc.currencyName = _currencyName;
                        vc.isPresentation = YES;
                        kNavPush(vc);
                        break;
                    }
                        
                    default:
                        break;
                }
            }];
            
            if (i < ntitles.count - 1) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(w - 0.5, 0, 0.5, 15)];
                lineView.backgroundColor = kColorFromStr(@"#999999");
                [button addSubview:lineView];
                [lineView alignVertical];
            }
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, h - 0.5, kScreenW-24, 0.5)];
        lineView.backgroundColor = kColorFromStr(@"#0B132A");
        [nwView addSubview:lineView];
    }
}

- (BOOL)_canRecharge {
    BOOL canRecharge = [self.myAssetCurrencyModel canRecharge];
    if (!canRecharge) {
        [self alertSorryWithMessage:kLocat(@"Has_been_suspended_in_recharge")];
    }
    
    return canRecharge;
}

- (BOOL)_canTake {

    BOOL canTake = [self.myAssetCurrencyModel canTake];
    if (!canTake) {
        [self alertSorryWithMessage:kLocat(@"Has_been_suspended_in_take")];
    }
    
    return canTake;
}

- (void)alertSorryWithMessage:(NSString *)message {
    NSString *msg = [NSString stringWithFormat:@"%@ %@",self.myAssetCurrencyModel.currency_mark ?: @"", message];
    [YWAlert alertSorryWithMessage:msg inViewController:self];
}

- (BOOL)_canRelease {
    
    BOOL can = [self.myAssetCurrencyModel canRelease];
    if (!can) {
        [self alertSorryWithMessage:kLocat(@"Has_been_suspended_in_release")];
    }
    
    return can;
}

- (BOOL)_canReleaseOfAward {
    
    BOOL can = [self.myAssetCurrencyModel canReleaseOfAward];
    if (!can) {
        [self alertSorryWithMessage:kLocat(@"Has_been_suspended_in_release_award")];
    }
    
    return can;
}

- (BOOL)_canExchange {
    
    BOOL can = [self.myAssetCurrencyModel canExchange];
    if (!can) {
        [self alertSorryWithMessage:kLocat(@"Has_been_suspended_in_exchange")];
    }
    
    return can;
}


/*  获取币种信息和委托数据*/
-(void)loadCurrencyInfo
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _current_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"AccountManage/accent_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        [_tableView.mj_header endRefreshing];
        if (success) {
            _dataDic = [responseObj ksObjectForKey:kData][@"currency_user"];
            id currencyData = [responseObj ksObjectForKey:kData][@"currency"];
            self.myAssetCurrencyModel = [HBMyAssetCurrencyModel mj_objectWithKeyValues:currencyData];
            [self.tableView reloadData];
        }
    }];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.dataArray.count;
    }else{
        if (_dataDic) {
            return 1;
        }else{
            return 0;
        }
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_currencyName isEqualToString:@"KOK"]) {
            HBMyKokAssetHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBMyKokAssetHeaderCellIdentifier];
            cell.dataDic = _dataDic;
            return cell;
        }
        static NSString *rid = @"HBMyAssetDetailTopView";
        HBMyAssetDetailTopView *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.currencyName.text = _currencyName;
//        cell.exchange.hidden = YES;
//        cell.exchangeLabel.hidden = YES;
        cell.dataDic = _dataDic;
        
        
        return cell;
        
    }else{
        //>>>>>财务日志
        static NSString *rid = @"HBMyAssetDetailListCell";
        HBMyAssetDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        FinModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
        return cell;
        
        //>>>>>>>>委托
        
//        static NSString *rid = @"MyassetDetailItemTableViewCell";
//        MyassetDetailItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
//        }
//        [cell refreshWithModel:self.dataArray[indexPath.row]];
//        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_currencyName isEqualToString:@"KOK"]) {
            return 175;
        }
        return 150+11;
    }else{
        return 105;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 48;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 48)];
    bgView.backgroundColor = kClearColor;
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(17, 0, 150, bgView.height) text:kLocat(@"k_FinsetViewController_title") font:PFRegularFont(16) textColor:kColorFromStr(@"#DEE5FF") textAlignment:0 adjustsFont:YES];
    [bgView addSubview:label];
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:filterButton];
    [filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(48);
    }];
    
    [filterButton setTitle:kLocat(@"k_MyassetDetailViewController_tableview_header_selectBtn") forState:UIControlStateNormal];
    [filterButton setTitleColor:kColorFromStr(@"#7582A4") forState:UIControlStateNormal];
    UIImage *image = [[UIImage imageNamed:@"sxuan_icon"] imageByTintColor:kColorFromStr(@"#7582A4")];
    [filterButton setImage:image forState:UIControlStateNormal];
    filterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [filterButton addTarget:self action:@selector(_showFilterMenuVC) forControlEvents:UIControlEventTouchUpInside];
    
    return bgView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    HBAssetDetailViewController *detail = [HBAssetDetailViewController fromStoryboard];
    FinModel *model =  [self.dataArray objectAtIndex:indexPath.row];
    detail.model = model;
    kNavPush(detail);
}


#pragma mark - Getters

- (HBMyAssetsFilterMenuViewController *)menuVC {
    if (!_menuVC) {
        _menuVC = [HBMyAssetsFilterMenuViewController fromStoryboard];
        
        __weak typeof(self) weakSelf = self;
        _menuVC.didSelectModelBlock = ^(HBMyAssetsFilterModel *model) {
            weakSelf.dataArray = @[].mutableCopy;
            [weakSelf.tableView reloadData];
            weakSelf.api.type = model.ID;
            [weakSelf.api refresh];
        };
    }
    
    return _menuVC;
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header endRefreshing];
    [self.view hideToastActivity];
    NSArray *array = responsObject;

    if (array.count <= 0) {
       
    }else{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
  
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableView.mj_header endRefreshing];
    [self.view hideToastActivity];
    [self.tableView.mj_header endRefreshing];
 
}


- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.view hideToastActivity];
    [self.tableView.mj_footer endRefreshing];
    [self.dataArray addObjectsFromArray:responsObject];
    [self.tableView reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableView.mj_footer endRefreshing];
    [self.view hideToastActivity];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.view hideToastActivity];
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
    
}



@end
