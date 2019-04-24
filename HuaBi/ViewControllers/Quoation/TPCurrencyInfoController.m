//
//  TPCurrencyInfoController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPCurrencyInfoController.h"
//#import "TPCurrencyPanKouCell.h"
//#import "TPTradeMallController.h"
#import "TPKLineFullScreenController.h"
#import "ZXAssemblyView.h"
#import "YTCurryInfoTableViewCell.h"
#import "YTTradeViewController.h"
#import "HBKlineTradeHeaderView.h"
#import "YTTradeIndexModel+Request.h"
#import "YTLatestDealContaineeTableViewController.h"
#import "HBKlineTradeContainerCell.h"
#import "HBKlineResumeTableViewController.h"
#import "HBIconInfoModel.h"
#import "HBKlineInfoHeaderView.h"
#import "ListModel+Request.h"

@interface TPCurrencyInfoController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate,AssemblyViewDelegate,ZXSocketDataReformerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)CGFloat height;

@property(nonatomic,strong)NSArray *buyRecords;
@property(nonatomic,strong)NSArray *sellRecords;


@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)NSMutableArray<UIButton *> *buttons;

@property(nonatomic,strong)UIView *lineView;

/**  K线图时间间隔  /分钟  */
@property(nonatomic,assign)NSInteger interval;
@property(nonatomic,strong)UIView *moreView;
@property(nonatomic,strong)YLButton *moreButton;
@property(nonatomic,strong)YLButton *targetButton;
@property(nonatomic,strong)UIView *midView;


@property(nonatomic,strong)UIView *indexView;





/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *横竖屏方向
 */
@property (nonatomic,assign) UIInterfaceOrientation orientation;
/**
 *当前绘制的指标名
 */
@property (nonatomic,strong) NSString *currentDrawQuotaName;
/**
 *所有的指标名数组
 */
@property (nonatomic,strong) NSArray *quotaNameArr;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *dataArray;
/**
 *
 */
@property (nonatomic,assign) ZXTopChartType topChartType;

@property (nonatomic,strong) NSDictionary *dic;

@property (nonatomic, strong) NSArray<Trade_list *> * trade_list;

@property (nonatomic, strong) YTLatestDealContaineeTableViewController *latestDealContaineeVC;
@property (nonatomic, strong) HBKlineResumeTableViewController *resumeTableViewController;
@property (nonatomic, assign) NSInteger headerSelectIndex;
@property (nonatomic, assign) HBKlineTradeHeaderView *tradeHeaderView;
@property (nonatomic, strong) HBIconInfoModel *iconInfoModel;

@property (nonatomic, strong) HBKlineInfoHeaderView *klineInfoHeaderView;

@property (nonatomic, assign) BOOL isCollect;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TPCurrencyInfoController


#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(_refreshAllData) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    kHideHud;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)dealloc
{
    kLOG(@"======");
}
- (void)viewDidLoad {
    [super viewDidLoad];

   
    [self setupUI];
//    self.enablePanGesture = NO;
    
    UIView *bgview = [[UIView alloc]init];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = kRGBA(85, 186, 138, 1);
    [button setTitle:kLocat(@"k_TradeViewController_seg01") forState:UIControlStateNormal];
    [bgview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenW/2);
        make.height.mas_equalTo(45);
    }];
    button.tag = 1;
    UIButton *rbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rbutton.backgroundColor = kRGBA(214, 114, 76, 1);
    [rbutton setTitle:kLocat(@"k_TradeViewController_seg02") forState:UIControlStateNormal];
    [bgview addSubview:rbutton];
    [rbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(button.mas_right);
        make.height.mas_equalTo(45);
    }];
    [button addTarget:self action:@selector(toSell:) forControlEvents:UIControlEventTouchUpInside];
    [rbutton addTarget:self action:@selector(toSell:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YTCurryInfoTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([YTCurryInfoTableViewCell class])];
    [self _addChildVCs];
    
    [self.tableView registerClass:[HBKlineTradeContainerCell class] forCellReuseIdentifier:@"HBKlineTradeContainerCell"];
    
    [self _refreshAllData];
   
};

#pragma mark - Private

- (void)_addChildVCs {
    [self _addChildVC:self.latestDealContaineeVC];
    [self _addChildVC:self.resumeTableViewController];
}

- (void)_addChildVC:(UIViewController *)vc {
    [self addChildViewController:vc];
    [vc willMoveToParentViewController:vc];
}


- (void)toSell:(UIButton *)sender{
    UINavigationController *nc = self.tabBarController.viewControllers[2];
    YTTradeViewController *tradeVC = nc.viewControllers.firstObject;
    tradeVC.isTypeOfBuy = (sender.tag == 1);
    if ([tradeVC isKindOfClass:[YTTradeViewController class]]) {
        tradeVC.currentListModel = self.model;
    }
    
    if (self.tabBarController.selectedIndex == 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        self.tabBarController.selectedIndex = 2;
    }
}

- (void)lasdFootData:(NSString *)currencyID{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency"] = self.model.currency_id;
    __weak typeof(self)weakSelf = self;
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/icon_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (success) {
            self.dic = responseObj;
            id cid_value = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"cid_value"];
            self.iconInfoModel = [HBIconInfoModel mj_objectWithKeyValues:cid_value];
            id currency_message = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"currency_message"];
            [self.klineInfoHeaderView configViewWithCurrencyMessage:currency_message];
            BOOL is_defaule = [[[responseObj ksObjectForKey:kData] ksObjectForKey:@"is_defaule"] boolValue];
            self.isCollect = is_defaule;
        }
    }];
}

- (void)loadLatestTradeData {
    if (self.headerSelectIndex != 0) {
        return;
    }
    [YTTradeIndexModel requestTradeIndexsWithCurrencyID:self.model.currency_id success:^(YTTradeIndexModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        self.trade_list = model.trade_list;
    } failure:^(NSError * _Nonnull error) {
    }];
}


-(void)setupUI
{
    //    self.enablePanGesture = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.model.comcurrencyName;
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH - kNavigationBarHeight- 45) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kThemeColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPCurrencyPanKouCell" bundle:nil] forCellReuseIdentifier:@"TPCurrencyPanKouCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"UIDealDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"UIDealDetailBottomCell"];
    
     self.klineInfoHeaderView = [HBKlineInfoHeaderView viewLoadNib];
    _tableView.tableHeaderView = [self createKLineHeadView];
    
    [self addRightTwoBarButtonsWithFirstImage:kImageFromStr(@"fd_icon") firstAction:@selector(fullScreenAction) secondImage:kImageFromStr(@"sc_icon") secondAction:@selector(favorAction:)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshAllData)];
}

- (void)_refreshAllData {
    [self loadKlineData];
    [self lasdFootData:self.model.currency_id];
    [self loadLatestTradeData];
}

-(UIView *)createKLineHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 100 + TotalHeight + 10)];
    view.backgroundColor = kThemeColor;
    
    self.klineInfoHeaderView.frame = CGRectMake(0, 0, kScreenW, 100);
    [view addSubview:self.klineInfoHeaderView];
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(0, self.klineInfoHeaderView.bottom + 15, kScreenW, 25 + 30)];
    [view addSubview:midView];
    midView.backgroundColor = kClearColor;
    
    NSArray *arr = @[kLocat(@"k_line_minh"),kLocat(@"k_line_minutes15"),kLocat(@"k_line_hours1"),kLocat(@"k_line_hours4"),kLocat(@"k_line_days"),kLocat(@"k_line_More"),kLocat(@"k_line_index")];
    CGFloat w = kScreenW / 7.0;
    self.buttons = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSInteger i = 0; i < arr.count; i++) {
        
        YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(w * i, 0, w, 25) title:arr[i] titleColor:kColorFromStr(@"979CAD") font:PFRegularFont(14) titleAlignment:0];
        [midView addSubview:button];
        button.tag = i;
        //        button.backgroundColor = kRandColor;
        [self.buttons addObject:button];
        if (i < 5) {
            [button setTitleColor:kColorFromStr(@"#11B1ED") forState:UIControlStateSelected];
            if (button.tag == 3) {
                
                button.selected = YES;
                [midView addSubview:self.lineView];
                self.lineView.centerX = button.centerX;
                self.lineView.y = button.bottom;
            }
        } else {
            [button setTitleColor:kLightGrayColor forState:UIControlStateSelected];
        }
        
        if (i == 5) {
            _moreButton = button;
        }else if (i == 6){
            _targetButton = button;
        }
        [button addTarget:self action:@selector(timeSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    _interval = 60 * 4;
    _midView = midView;
    
    self.assenblyView.frame = kRectMake(0, 100 + 50, kScreenW, TotalHeight);
    [view addSubview:self.assenblyView];
    
    view.height = self.assenblyView.bottom;
    
    self.topChartType = ZXTopChartTypeCandle;
    
    self.currentDrawQuotaName = self.quotaNameArr.lastObject;
    
    return view;
    
}


#pragma mark - 获取k线数据

-(void)loadKlineData
{
    [self.moreButton setTitle:kLocat(@"k_line_More") forState:UIControlStateNormal];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"market"] = [self.model.comcurrencyName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    param[@"range"] = @(_interval*60*1000);
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    [kNetwork_Tool POST_HTTPS:@"/Api/Ajax/kline" andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSArray *data = [responseObj ksObjectForKey:@"result"];
        
        NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:data.count];
        
        //     数组中数据格式:@[@"时间戳,收盘价,开盘价,最高价,最低价,成交量",
        for (NSArray *arr in data) {//毫秒转秒
            NSArray *newArr = @[@([arr[0]unsignedLongLongValue]/1000),arr[4],arr[1],arr[2],arr[3],arr[5]];
            NSString *string = [newArr componentsJoinedByString:@","];
            [Marr addObject:string];
        }
        
        NSString *des = nil;
        if (_interval == 15) {
            des = @"M15";
        }else if (_interval == 60){
            des = @"H1";
        }else if (_interval == 60*4){
            des = @"H4";
        }else if (_interval == 60 * 24){
            des = @"D1";
        }else if (_interval == 1){
            des = @"M1";
        }else if (_interval == 5){
            des = @"M5";
        }else if (_interval == 30){
            des = @"M30";
        }else if (_interval == 60 * 24 * 7){
            des = @"W1";
        }else if (_interval == 30 *24 * 60){
            des = @"W4";
        }
        
        NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:Marr.copy currentRequestType:des];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:transformedDataArray];
        
        //绘制k线图
        [self.assenblyView drawHistoryCandleWithDataArr:self.dataArray precision:6 stackName:self.model.comcurrencyName needDrawQuota:self.currentDrawQuotaName];
        
        [self drawQuotaWithCurrentDrawQuotaName:@"VOL"];
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HBKlineTradeContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBKlineTradeContainerCell" forIndexPath:indexPath];
    
    [cell.contentView removeAllSubviews];
    UIView *view = indexPath.row == 0 ? self.latestDealContaineeVC.view : self.resumeTableViewController.view;
    [cell.contentView addSubview:view];
    view.frame = cell.contentView.bounds;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    HBKlineTradeHeaderView *view = [HBKlineTradeHeaderView viewLoadNib];
    view.segmentedControl.selectedSegmentIndex = self.headerSelectIndex;
    __weak typeof(self) weakSelf = self;
    view.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        weakSelf.headerSelectIndex = index;
    };
    self.tradeHeaderView = view;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height0 = self.headerSelectIndex == 0 ? [YTLatestDealContaineeTableViewController getHeightWithModels:self.trade_list] : 0;
    CGFloat height1 = self.headerSelectIndex == 0 ? 0 : self.resumeTableViewController.getHeight;
    if (indexPath.row == 0) {
        return height0;
    } else {
        return height1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.;
}


#pragma mark - Actions

- (void)favorAction:(UIButton *)button {
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return;
    }
    
    kShowHud;
    [self.model collectWithSuccess:^(BOOL isCollected) {
        kHideHud;
        self.isCollect = isCollected;
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}

-(void)fullScreenAction
{
    TPKLineFullScreenController *vc = [TPKLineFullScreenController new];
    vc.currencyName = [self.model.comcurrencyName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    vc.datas = self.dataArray.mutableCopy;
    kNavPush(vc);
}


#pragma mark - 时间选择点击事件

-(void)timeSelectedAction:(UIButton *)button
{
    if (button.selected) {
        if (button.tag == 5) {
            self.moreView.hidden = !self.moreView.hidden;
        }else if(button.tag == 6){
            self.indexView.hidden = !self.indexView.hidden;
        }
        
        return;
    } else {
        if (button.tag != 6) {
            
            for (UIButton *btn in _midView.subviews) {
                
                if ([btn isKindOfClass:[UIButton class]]) {
                    
                    if (btn.tag == button.tag) {
                        btn.selected = YES;
                    }else{
                        btn.selected = NO;
                    }
                }
            }
        }
        
    }
    
    
    self.moreView.hidden = button.tag != 5;
    self.indexView.hidden = button.tag != 6;
    
    
    if (button.tag < 5) {
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView.centerX = button.centerX;
        }];
        
        if (button.tag == 0) {
            
            [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeBrokenLine];
            self.topChartType = ZXTopChartTypeBrokenLine;
            return;
        }else if (button.tag == 1) {
            _interval = 15;
        }else if (button.tag == 2){
            _interval = 60;
        }else if (button.tag == 3){
            _interval = 60 * 4;
        }else if (button.tag == 4){
            _interval = 60 * 24;
        }
        if (self.topChartType != ZXTopChartTypeCandle) {
            [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
            self.topChartType = ZXTopChartTypeCandle;
        }
        [self loadKlineData];
        
        [self.moreButton setTitle:kLocat(@"k_line_More") forState:UIControlStateNormal];
        
    }else{//更多
        if (button.tag == 5) {
            [_midView.superview bringSubviewToFront:_midView];
            
            //            self.moreView.hidden = NO;
            
        }else{//指标
            
            [_indexView.superview bringSubviewToFront:_indexView];
            
        }
        
        
    }
    
    [self.moreButton setTitle:kLocat(@"k_line_More") forState:UIControlStateNormal];

}

#pragma mark - KLine
#pragma mark - 屏幕旋转通知事件
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        //翻转为竖屏时
        [self updateConstrainsForPortrait];
        self.navigationController.navigationBar.hidden = NO;
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        
        [self updateConstrsinsForLandscape];
        self.navigationController.navigationBar.hidden = YES;
    }
}
- (void)updateConstrainsForPortrait
{
    [self.assenblyView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view).offset(200);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
    }];
    
}
- (void)updateConstrsinsForLandscape
{
    //翻转为横屏时
    [self.assenblyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
    }];
    
}


#pragma mark - AssemblyViewDelegate
- (void)tapActionActOnQuotaArea
{
    return;
    //这里可以进行quota图的切换
//    NSInteger index = [self.quotaNameArr indexOfObject:self.currentDrawQuotaName];
//    if (index<self.quotaNameArr.count-1) {
//
//        self.currentDrawQuotaName = self.quotaNameArr[index+1];
//    }else{
//        self.currentDrawQuotaName = self.quotaNameArr[0];
//    }
//    [self drawQuotaWithCurrentDrawQuotaName:self.currentDrawQuotaName];
}

- (void)tapActionActOnCandleArea
{
    return;
//    if (self.topChartType==ZXTopChartTypeBrokenLine) {
//
//        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
//        self.topChartType = ZXTopChartTypeCandle;
//    }else if (self.topChartType==ZXTopChartTypeCandle)
//    {
//        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeBrokenLine];
//        self.topChartType = ZXTopChartTypeBrokenLine;
//    }
    
}
#pragma mark - 画指标
//在返回的数据里面。可以调用预置的指标接口绘制指标，也可以根据返回的数据自己计算数据，然后调用绘制接口进行绘制
- (void)drawQuotaWithCurrentDrawQuotaName:(NSString *)currentDrawQuotaName
{
    if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[0]])
    {
        //macd绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithMACD];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[1]])
    {
        
        //KDJ绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithKDJ];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[2]])
    {
        
        //BOLL绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithBOLL];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[3]])
    {
        
        //RSI绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithRSI];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[4]])
    {
        
        //Vol绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithVOL];
    }
    
}

#pragma mark - ZXSocketDataReformerDelegate
- (void)bulidSuccessWithNewKlineModel:(KlineModel *)newKlineModel
{
    //维护控制器数据源
    if (newKlineModel.isNew) {
        
        [self.dataArray addObject:newKlineModel];
        [[ZXQuotaDataReformer sharedInstance] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
    }else{
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
        [[ZXQuotaDataReformer alloc] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
    }
    //绘制最后一个蜡烛
    [self.assenblyView drawLastKlineWithNewKlineModel:newKlineModel];
}
#pragma mark - Event Response



#pragma mark - CustomDelegate

#pragma mark - Getters & Setters
- (ZXAssemblyView *)assenblyView
{
    if (!_assenblyView) {
        _assenblyView = [[ZXAssemblyView alloc] initWithDrawJustKline:NO];
        _assenblyView.delegate = self;
        _assenblyView.isDisplayCandelInfoInTop = YES;
        _assenblyView.backgroundColor = kThemeColor;
        
    }
    return _assenblyView;
}
- (UIInterfaceOrientation)orientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}
- (NSArray *)quotaNameArr
{
    if (!_quotaNameArr) {
        _quotaNameArr = @[@"MACD",@"KDJ",@"BOLL",@"RSI",@"VOL"];
    }
    return _quotaNameArr;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



-(UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 24, 2)];
        _lineView.backgroundColor = kColorFromStr(@"#11B1ED");
    }
    return _lineView;
}
-(UIView *)moreView
{
    if (_moreView == nil) {
        _moreView = [[UIView alloc] initWithFrame:kRectMake(0, 30, kScreenW, 25)];
        _moreView.backgroundColor = kColorFromStr(@"#111419");
        [self.midView addSubview:_moreView];
        [_midView.superview bringSubviewToFront:_midView];
        NSArray *arr = @[kLocat(@"k_line_1m"),kLocat(@"k_line_5m"),kLocat(@"k_line_30m"),kLocat(@"k_line_1w"),kLocat(@"k_line_1mon")];
        CGFloat w = kScreenW * 0.75 / arr.count;
        self.buttons = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSInteger i = 0; i < arr.count; i++) {
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(w * i, 0, w, _moreView.height) title:arr[i] titleColor:kColorFromStr(@"979CAD") font:PFRegularFont(14) titleAlignment:0];
            [_moreView addSubview:button];
            button.tag = i;
            //        button.backgroundColor = kRandColor;
            [self.buttons addObject:button];
            
            __weak typeof(self)weakSelf = self;
            
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
                weakSelf.moreView.hidden = YES;
                
                switch (sender.tag) {
                    case 0:
                        weakSelf.interval = 1;
                        break;
                    case 1:
                        
                        weakSelf.interval = 5;
                        break;
                    case 2:
                        weakSelf.interval = 30;
                        break;
                    case 3:
                        weakSelf.interval = 24*60*7;
                        break;
                    case 4:
                        weakSelf.interval = 30*24*60;
                        break;
                    default:
                        break;
                }
                [weakSelf.moreButton setTitle:sender.currentTitle forState:UIControlStateNormal];
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.lineView.centerX = weakSelf.moreButton.centerX;
                }];
                
                if (weakSelf.topChartType != ZXTopChartTypeCandle) {
                    [weakSelf.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
                    weakSelf.topChartType = ZXTopChartTypeCandle;
                }
                [weakSelf loadKlineData];
            }];
        }
    }
    return _moreView;
}

- (UIView *)indexView
{
    if (_indexView == nil) {
        _indexView = [[UIView alloc] initWithFrame:kRectMake(0, 30, kScreenW, 25)];
        _indexView.backgroundColor = kColorFromStr(@"#111419");
        [self.midView addSubview:_indexView];
        [_indexView.superview bringSubviewToFront:_indexView];
        
        NSArray *arr =  @[@"MACD",@"KDJ",@"BOLL",@"RSI",@"VOL"];
        CGFloat w = kScreenW * 0.75 / arr.count;
        //        self.buttons = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSInteger i = 0; i < arr.count; i++) {
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(w * i, 0, w, _moreView.height) title:arr[i] titleColor:kColorFromStr(@"979CAD") font:PFRegularFont(14) titleAlignment:0];
            [_indexView addSubview:button];
            button.tag = i;
            //        button.backgroundColor = kRandColor;
            //            [self.buttons addObject:button];
            
            __weak typeof(self)weakSelf = self;
            
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
                weakSelf.indexView.hidden = YES;
                switch (sender.tag) {
                    case 0:
                        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithMACD];
                        break;
                    case 1:
                        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithKDJ];
                        break;
                    case 2:
                        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithBOLL];
                        break;
                    case 3:
                        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithRSI];
                        break;
                    case 4:
                        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithVOL];
                        break;
                    default:
                        break;
                }
                
                //                [UIView animateWithDuration:0.25 animations:^{
                //                    weakSelf.lineView.centerX = weakSelf.moreButton.centerX;
                //                }];
            }];
            
        }
        
    }
    return _indexView;
}


- (void)setTrade_list:(NSArray<Trade_list *> *)trade_list {
    _trade_list = trade_list;
    
    self.latestDealContaineeVC.models = trade_list;
    [self.tableView reloadData];
}


- (YTLatestDealContaineeTableViewController *)latestDealContaineeVC {
    if (!_latestDealContaineeVC) {
        _latestDealContaineeVC = [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTLatestDealContaineeTableViewController"];
        _latestDealContaineeVC.view.backgroundColor = [UIColor clearColor];
    }
    return _latestDealContaineeVC;
}

- (HBKlineResumeTableViewController *)resumeTableViewController {
    if (!_resumeTableViewController) {
        //resumeTableViewController
        _resumeTableViewController = [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"HBKlineResumeTableViewController"];
    }
    
    return _resumeTableViewController;
}

- (void)setHeaderSelectIndex:(NSInteger)headerSelectIndex {
    _headerSelectIndex = headerSelectIndex;
    
//    [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

- (HBKlineTradeHeaderView *)tradeHeaderView {
    if (!_tradeHeaderView) {
        _tradeHeaderView = [HBKlineTradeHeaderView viewLoadNib];
        
        __weak typeof(self) weakSelf = self;
        _tradeHeaderView.segmentedControl.indexChangeBlock = ^(NSInteger index) {
            weakSelf.headerSelectIndex = index;
        };
    }
    
    return _tradeHeaderView;
}

- (void)setIconInfoModel:(HBIconInfoModel *)iconInfoModel {
    _iconInfoModel = iconInfoModel;
    
    self.resumeTableViewController.iconInfoModel = _iconInfoModel;
}

- (void)setIsCollect:(BOOL)isCollect {
    _isCollect = isCollect;
    
    NSString *collectImageName = _isCollect ? @"sc1_icon" : @"sc_icon";
    [self addRightTwoBarButtonsWithFirstImage:kImageFromStr(@"fd_icon") firstAction:@selector(fullScreenAction) secondImage:kImageFromStr(collectImageName) secondAction:@selector(favorAction:)];
}

-(void)userDidClickKlineView:(NSNotification *)noti
{
    if (noti.object == self.assenblyView) {
        [self.assenblyView.superview bringSubviewToFront:self.assenblyView];
    }
}

@end
