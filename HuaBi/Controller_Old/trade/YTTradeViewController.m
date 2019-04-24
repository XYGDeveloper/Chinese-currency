//
//  YTTradeViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeViewController.h"
#import "JXCategoryView.h"
#import "YTBuyAndSellDetailTableViewController.h"
#import "YTQuotationMenuViewController.h"
#import "YTData_listModel.h"
#import "YTTradeCancellationsViewController.h"
#import "YTTradeRecordsViewController.h"
#import "YTTradeIndexModel+Request.h"
#import "YTTradeRequest.h"
#import "BaseWebViewController.h"
#import "YTLoginManager.h"
#import "EmptyManager.h"
#import "TPCurrencyInfoController.h"
#import "IndexModel.h"
@interface YTTradeViewController () <JXCategoryViewDelegate>

@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *customItemView;
@property (weak, nonatomic) IBOutlet UILabel *customItemLabel;

@property (nonatomic, strong) YTBuyAndSellDetailTableViewController *buyDetailTableViewController;
@property (nonatomic, strong) YTBuyAndSellDetailTableViewController *sellDetailTableViewController;
@property (nonatomic, strong) YTTradeCancellationsViewController *cancellationsViewController;
@property (nonatomic, strong) YTTradeRecordsViewController *recordsViewController;

@property (nonatomic, strong) NSArray<UIViewController *> *myChildVCs;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) YTQuotationMenuViewController *quotationMenuVC;

@property (nonatomic, strong) ListModel *currentListModel;

//@property (nonatomic, assign) BOOL isViewDidLoad;

@end

@implementation YTTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buyDetailTableViewController = [YTBuyAndSellDetailTableViewController buyDetailTableViewController];
    __weak typeof(self) weakSelf = self;
    self.buyDetailTableViewController.operateDoneBlock = ^{
        [weakSelf _reloadAllDataAction];
    };
    self.sellDetailTableViewController = [YTBuyAndSellDetailTableViewController sellDetailTableViewController];
    self.sellDetailTableViewController.operateDoneBlock = ^{
        [weakSelf _reloadAllDataAction];
    };
    self.cancellationsViewController = [YTTradeCancellationsViewController fromStoryboard];
    self.recordsViewController = [YTTradeRecordsViewController fromStoryboard];
    
    ListModel *currencyModel = [ListModel new];
    currencyModel.currency_name = @"BTC";
    currencyModel.currency_id = @"52";
    self.currentListModel = currencyModel;
    
    self.myChildVCs = @[
                        self.buyDetailTableViewController,
                        self.sellDetailTableViewController,
                        self.cancellationsViewController,
                        self.recordsViewController,
                        ];
    
    [self _addChildVC:self.buyDetailTableViewController];
    [self _addChildVC:self.sellDetailTableViewController];
    [self _addChildVC:self.cancellationsViewController];
    [self _addChildVC:self.recordsViewController];
    
    [self _setupCategoryTitleView];
    [self _setupLeftItemButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_reloadAllDataAction) name:kLoginSuccessKey object:nil];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.scrollView.contentSize = CGSizeMake(width * self.myChildVCs.count, 0);

    [self.myChildVCs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = idx *width;
        obj.view.frame = frame;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([Utilities isExpired]) {
        [self _cleanData];
    }
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Private

- (void)_cleanData {
    self.sellDetailTableViewController.tradeModel = nil;
    self.buyDetailTableViewController.tradeModel = nil;
//    self.sellDetailTableViewController.tradeIndexs = nil;
//    self.buyDetailTableViewController.tradeIndexs = nil;
}

- (void)_reloadAllDataAction {
    if (self.isViewLoaded) {
        self.currentListModel = _currentListModel;//触发全部子界面更新
    }
}

- (void)_setupLeftItemButton {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.customItemView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showQuotationVCAction:)];
    [self.customItemView addGestureRecognizer:tapGesture];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)_addChildVC:(UIViewController *)vc {
    [self addChildViewController:vc];
    [self.scrollView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)_setupCategoryTitleView {
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorLineViewColor = kGreenColor;
    self.categoryTitleView.indicators = @[lineView];
    self.categoryTitleView.titles = @[kLocat(@"k_TradeViewController_seg01"),kLocat(@"k_TradeViewController_seg02"),kLocat(@"k_TradeViewController_seg03"),kLocat(@"k_TradeViewController_seg04")];
    self.categoryTitleView.titleSelectedColor = kGreenColor;
    self.categoryTitleView.contentScrollView = self.scrollView;
    self.categoryTitleView.titleColor = kColorFromStr(@"#333333");
    
    self.categoryTitleView.delegate = self;
}

- (void)_requestTradeIndexModels {
    kShowHud;
    [YTTradeIndexModel requestTradeIndexsWithCurrencyID:self.currentListModel.currency_id success:^(YTTradeIndexModel *_Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        kHideHud;
        self.sellDetailTableViewController.tradeIndexs = model;
        self.buyDetailTableViewController.tradeIndexs = model;
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
    }];
}

- (void)_requestTradAllBuyLogin {
    [YTTradeRequest requestTradAllBuyLoginWithCurrencyID:self.currentListModel.currency_id
                                                 success:^(YTTradeModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj)
    {
        self.sellDetailTableViewController.tradeModel = model;
        self.buyDetailTableViewController.tradeModel = model;
    } failure:^(NSError * _Nonnull error) {
        [self showTips:error.localizedDescription];
        if (error.code == 10100) {
            if (![Utilities isExpired]) {
                [YTLoginManager logout];
            }
        }
    }];
}

- (void)_requestAllData {
    [self _requestTradeIndexModels];
    [self _requestTradAllBuyLogin];
}

#pragma mark - Action

- (IBAction)showQuotationVCAction:(id)sender {
    
    [self.quotationMenuVC show];
    
//    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/%@/%@",kBasePath,icon_info_currency,self.currentListModel.currency_id,[Utilities dataChangeUTC]]];
//    //                vc.showNaviBar = YES;
//    kNavPush(vc);
}
- (IBAction)showKLineGraphVC:(id)sender {
   
    TPCurrencyInfoController *vc = [TPCurrencyInfoController new];
    vc.currencyName = _currentListModel.currency_name;
//    vc.currencyID = _currentListModel.currency_id;
    kNavPush(vc);
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
}

#pragma mark - Getters & Setters

- (YTQuotationMenuViewController *)quotationMenuVC {
    if (!_quotationMenuVC) {
        _quotationMenuVC = [YTQuotationMenuViewController fromStoryboard];
        __weak typeof(self) weakSelf = self;
        _quotationMenuVC.didSelectModelBlock = ^(ListModel * _Nonnull model) {
            weakSelf.currentListModel = model;
        };
    }
    
    return _quotationMenuVC;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    _selectedIndex = selectedIndex;

    UIColor *themeColor = (_selectedIndex == 1) ? kOrangeColor : kGreenColor;
    
    self.categoryTitleView.titleSelectedColor = themeColor;
    JXCategoryIndicatorLineView *line = (JXCategoryIndicatorLineView *)self.categoryTitleView.indicators.firstObject;
    line.backgroundColor = themeColor;
}

- (void)setCurrentListModel:(ListModel *)currentListModel {
    _currentListModel = currentListModel;
    
    self.buyDetailTableViewController.model = _currentListModel;
    self.sellDetailTableViewController.model = _currentListModel;
    self.cancellationsViewController.model = _currentListModel;
    self.recordsViewController.model = _currentListModel;
    self.customItemLabel.text = _currentListModel.currency_name;
    
    [self _requestAllData];
}

@end
