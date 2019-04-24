//
//  YTTradeViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeViewController.h"
#import "YTBuyAndSellDetailTableViewController.h"
#import "YTQuotationMenuViewController.h"
#import "YTData_listModel+Request.h"
#import "YTTradeIndexModel+Request.h"
#import "YTTradeRequest.h"
#import "BaseWebViewController.h"
#import "YTLoginManager.h"
#import "EmptyManager.h"
#import "TPCurrencyInfoController.h"
#import "IndexModel.h"
#import "HBCurrentEntrustViewController.h"
#import "YTMyassetDetailModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "NSTimer+HB.h"

@interface YTTradeViewController ()

@property (strong, nonatomic) IBOutlet UIView *customItemView;
@property (weak, nonatomic) IBOutlet UILabel *customItemLabel;

@property (nonatomic, strong) YTBuyAndSellDetailTableViewController *buyDetailTableViewController;
@property (nonatomic, strong) YTQuotationMenuViewController *quotationMenuVC;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YTTradeViewController

#pragma mark - Lifecycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isTypeOfBuy = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self _addChildVC:self.buyDetailTableViewController];
    [self _setupLeftItemButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_reloadAllDataAction) name:kLoginSuccessKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_reloadAllDataAction) name:HBCurrentEntrustViewControllerDeleteModelNotificationName object:nil];
    
    self.enablePanGesture = NO;
    [self _reloadAllDataAction];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.buyDetailTableViewController.view.frame = self.view.bounds;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([Utilities isExpired]) {
        [self _cleanData];
    }
    
    self.navigationController.navigationBar.hidden = NO;
    if (self.currentListModel == nil) {
        [self _requestQuotations];
    }
    
    if (!self.timer) {
        [self _createTimer];
    }
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}



#pragma mark - Private

- (void)_cleanData {
    self.buyDetailTableViewController.assetModel = nil;
    self.buyDetailTableViewController.tradeAssetModel = nil;
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
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)_timerAction {
    [self _requestTradeIndexModels];
    [self _createTimer];
}

- (void)_createTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer _createRandomTimerWithTarget:self selector:@selector(_timerAction)];

}

- (NSInteger)_getTimerRandomFactor {
    return arc4random_uniform(5) + 1;
}

- (void)_requestTradeIndexModels {

    [YTTradeIndexModel requestTradeIndexsWithCurrencyID:self.currentListModel.currency_id success:^(YTTradeIndexModel *_Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        _currentListModel.price = model.newbuyprice.price;
        _currentListModel.price_cny_new = model.newbuyprice.price_cny_new;
        _currentListModel.price_usd_new = model.newbuyprice.price_usd_new;
        _currentListModel.price_status = model.newbuyprice.price_status;
        self.buyDetailTableViewController.tradeIndexs = model;
        
        [self.buyDetailTableViewController endRefresh];
        kHideHud;
    } failure:^(NSError * _Nonnull error) {
        [self.buyDetailTableViewController endRefresh];
        kHideHud;
    }];
}

- (void)_requestQuotations {
    
    [YTData_listModel requestQuotationsWithSuccess:^(NSArray<YTData_listModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        
        self.currentListModel = array.firstObject.data_list.firstObject;
    } failure:^(NSError * _Nonnull error) {
        
        kHideHud;
        [self showTips:error.localizedDescription];
        if (error) {
            __weak typeof(self) weakSelf = self;
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                [weakSelf _requestAllData];
            }];
        }
    }];
}

- (void)_requestMyCurrencyNumber {
    [YTMyassetDetailModel requestMyAssetDetailWithCurrencyID:self.currentListModel.currency_id success:^(YTMyassetDetailModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        self.buyDetailTableViewController.assetModel = model;
    } failure:nil];
    [YTMyassetDetailModel requestMyAssetDetailWithCurrencyID:self.currentListModel.trade_currency_id success:^(YTMyassetDetailModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        self.buyDetailTableViewController.tradeAssetModel = model;
    } failure:nil];
}

- (void)_requestAllData {
    kShowHud;
    if (self.currentListModel) {
        [self _requestTradeIndexModels];
        [self _requestMyCurrencyNumber];
    } else {
        [self _requestQuotations];
    }
    
}

#pragma mark - Actions

- (void)tapButtonWithIsBuy:(BOOL)isbuy {
    [self.buyDetailTableViewController tapButtonWithIsBuy:isbuy];
}

- (IBAction)showQuotationVCAction:(id)sender {
    [self.quotationMenuVC show];
}

- (IBAction)showKLineGraphVC:(id)sender {
   
    TPCurrencyInfoController *vc = [TPCurrencyInfoController new];
    vc.model = self.currentListModel;
    kNavPush(vc);
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

- (YTBuyAndSellDetailTableViewController *)buyDetailTableViewController {
    if (!_buyDetailTableViewController) {
        _buyDetailTableViewController = [YTBuyAndSellDetailTableViewController buyDetailTableViewController];
        __weak typeof(self) weakSelf = self;
        _buyDetailTableViewController.isTypeOfBuy = self.isTypeOfBuy;
        _buyDetailTableViewController.operateDoneBlock = ^{
            [weakSelf _reloadAllDataAction];
        };
    }
    return _buyDetailTableViewController;
}

- (void)setCurrentListModel:(ListModel *)currentListModel {
    _currentListModel = currentListModel;
    if (self.isViewLoaded) {
        self.buyDetailTableViewController.model = _currentListModel;
        self.customItemLabel.text = _currentListModel.comcurrencyName;
        
        [self _requestAllData];
    }
    
}

- (void)setIsTypeOfBuy:(BOOL)isTypeOfBuy {
    _isTypeOfBuy = isTypeOfBuy;
    self.buyDetailTableViewController.isTypeOfBuy = isTypeOfBuy;
}

@end
