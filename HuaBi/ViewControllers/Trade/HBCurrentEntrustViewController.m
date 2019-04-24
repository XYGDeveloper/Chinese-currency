//
//  HBCurrentEntrustViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCurrentEntrustViewController.h"
#import "HBCurrentEntrustCell.h"
#import "YTTradeUserOrderModel+Request.h"
#import "YWAlert.h"
#import "YTData_listModel.h"
#import "HBCurrentEntrustViewController.h"
#import "YWEmptyDataSetDataSource.h"
#import "HBCurrentEntrustDetailTableViewController.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"

NSString *const HBCurrentEntrustViewControllerDeleteModelNotificationName = @"HBCurrentEntrustViewControllerDeleteModelNotificationName";

@interface HBCurrentEntrustViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (nonatomic, strong) NSArray<YTTradeUserOrderModel *> *orders;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIView *cellSelectedBackgroudView;

@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation HBCurrentEntrustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.enablePanGesture = YES;
    [self _setupUI];
    [self _fristRefreshData];
}

#pragma mark - Private

- (void)_setupUI {
//    self.title = self.model.comcurrencyName;
    [self _setupTableView];
    self.topContainerView.backgroundColor = kThemeColor;
    if (!self.isHistoryVC) {
        NSString *historyTitle = [NSString stringWithFormat:@" %@", kLocat(@"History")];
        [self.historyButton setTitle:historyTitle forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.historyButton];
    }
    self.title = self.isHistoryVC ? kLocat(@"k_TradeViewController_seg04") : kLocat(@"k_MyassetDetailViewController_tableview_header_label");
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];

    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView title:kLocat(@"empty_msg")];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    [self.selectBtn setTitle:kLocat(@"k_MyassetDetailViewController_tableview_header_selectBtn") forState:UIControlStateNormal];
}

- (void)_setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"HBCurrentEntrustCell" bundle:nil] forCellReuseIdentifier:@"HBCurrentEntrustCell"];
    self.tableView.backgroundColor = kThemeBGColor;
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top = 1.;
    self.tableView.contentInset = contentInset;
}

- (void)_fristRefreshData {
    [self showLoadingView];
    [self _refreshData];
}

- (void)_refreshData {
    [self _requestTradeUserOrderModelsWithIsRefresh:YES];
}
- (void)_loadMoreData {
    [self _requestTradeUserOrderModelsWithIsRefresh:NO];
}
static NSInteger sizeOfPage = 10;
- (void)_requestTradeUserOrderModelsWithIsRefresh:(BOOL)isRefresh {
    if (!self.model) {
        return;
    }
    
    if (self.isFetchInProgress) {
        return;
    }
    
    self.isFetchInProgress = YES;
    
    if (isRefresh) {
        self.currentPage = 0;
    }
    
    [YTTradeUserOrderModel requestTradeUserOrdersWithCurrencyModel:self.model isTypeOfBuy:nil rows:sizeOfPage page:self.currentPage isHistory:self.isHistoryVC success:^(NSArray<YTTradeUserOrderModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        self.currentPage++;
        self.noMoreData = array.count < sizeOfPage;
        self.isFetchInProgress = NO;
        if (isRefresh) {
            self.orders = array;
        } else {
            if (array.count > 0) {
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:self.orders];
                [tmp addObjectsFromArray:array];
                self.orders = tmp.copy;
            }
        }
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        self.isFetchInProgress = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showErrorWithMessage:error.localizedDescription];
        [self hideLoadingView];
    }];
}

#pragma mark - Actions

- (IBAction)showHistoryAction:(id)sender {
    HBCurrentEntrustViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"HBCurrentEntrustViewController"];
    vc.isHistoryVC = YES;
    vc.model = self.model;
    kNavPush(vc);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (YTTradeUserOrderModel *)orderModelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.orders.count) {
        return self.orders[indexPath.row];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCurrentEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBCurrentEntrustCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.model = [self orderModelAtIndexPath:indexPath];
    cell.cancelBlock = ^(YTTradeUserOrderModel *model) {
        [weakSelf _showDeleteAlertWithModel:model];
    };
    cell.cancelButton.hidden = self.isHistoryVC;
    cell.statusStackView.hidden = !self.isHistoryVC;
    cell.selectedBackgroundView = self.cellSelectedBackgroudView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isHistoryVC) {
        return;
    }
    YTTradeUserOrderModel *model = [self orderModelAtIndexPath:indexPath];
    if ([model isDone]) {
        HBCurrentEntrustDetailTableViewController *vc = [HBCurrentEntrustDetailTableViewController fromStoryboard];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
//        [self performSegueWithIdentifier:@"showEntrustDetailVC" sender:nil];
    }
}

- (void)_showDeleteAlertWithModel:(YTTradeUserOrderModel *)model {
    [YWAlert alertWithTitle:kLocat(@"HBCurrentEntrustViewController.AlertTitle") message:kLocat(@"HBCurrentEntrustViewController.AlertMessage") sureAction:^{
        [model cancelTradeOrdersWithSuccess:^(YWNetworkResultModel * _Nonnull obj) {
            [self showTips:obj.message];
            if ([obj succeeded]) {
                [self _deleteModel:model];
                 [[NSNotificationCenter defaultCenter] postNotificationName:HBCurrentEntrustViewControllerDeleteModelNotificationName object:nil];
            }
        } failure:^(NSError * _Nonnull error) {
            [self showTips:error.localizedDescription];
        }];
        
       
    } cancelAction:nil inViewController:self];
}

- (void)_deleteModel:(YTTradeUserOrderModel *)model {
    
    //    NSInteger index = [self.orders indexOfObject:model];
    NSMutableArray *array = self.orders.mutableCopy;
    [array removeObject:model];
    self.orders = array.copy;
    
}

#pragma mark - Setters
- (void)setOrders:(NSArray<YTTradeUserOrderModel *> *)orders {
    _orders = orders;
    
    [self.tableView reloadData];
}

- (void)setNoMoreData:(BOOL)noMoreData {
    _noMoreData = noMoreData;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_noMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.tableView.mj_footer setNeedsDisplay];
    });
    
}

@end
