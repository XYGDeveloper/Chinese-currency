//
//  HBSubscribeRecordListViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeRecordListViewController.h"
#import "HBSubscribeRecordCell.h"
#import "HBBaseTableViewDataSource.h"
#import "HBSubscribeRecordModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"
#import "HBReleaseRecordListViewController.h"

@interface HBSubscribeRecordListViewController () <UITableViewDelegate, HBSubscribeRecordCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HBBaseTableViewDataSource *tableViewDataSource;

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray<HBSubscribeRecordModel *> *models;

@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

static NSString *const kHBSubscribeRecordCellIdentifier = @"HBSubscribeRecordCell";

@implementation HBSubscribeRecordListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = kLocat(@"Subscription Records title");
    
    self.tableView.backgroundColor = kThemeBGColor;
    __weak typeof(self) weakSelf = self;
    self.tableViewDataSource = [[HBBaseTableViewDataSource alloc] initWithItems:self.models cellIdentifier:kHBSubscribeRecordCellIdentifier cellConfigureBlock:^(HBSubscribeRecordCell  *_Nonnull cell, HBSubscribeRecordModel  *_Nonnull model) {
        cell.model = model;
        cell.delegate = weakSelf;
    }];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    self.tableView.mj_footer.hidden = YES;
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    [self _firstRequestData];
}

#pragma mark - Private

- (void)_firstRequestData {
    [self showLoadingView];
    [self _refreshData];
}

- (void)_refreshData {
    [self _requestRecordsWithIsRefresh:YES];
}

- (void)_loadData {
    [self _requestRecordsWithIsRefresh:NO];
}

static NSInteger const kPageSize = 10;
- (void)_requestRecordsWithIsRefresh:(BOOL)isRefresh {
    
    if (self.isFetchInProgress) {
        return;
    }
    
    self.isFetchInProgress = YES;
    
    if (isRefresh) {
        self.currentPage = 1;
    }
    
    [HBSubscribeRecordModel requestSubscribeRecordListWithPage:self.currentPage pageSize:kPageSize success:^(NSArray<HBSubscribeRecordModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj)  {
        self.currentPage++;
        self.noMoreData = array.count < kPageSize;
        self.isFetchInProgress = NO;
        if (isRefresh) {
            self.models = array;
        } else {
            if (array.count > 0) {
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:self.models];
                [tmp addObjectsFromArray:array];
                self.models = tmp.copy;
            }
        }
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.emptyDataSetDataSource.title = kLocat(@"empty_msg");
    } failure:^(NSError * _Nonnull error) {
        self.emptyDataSetDataSource.title = kLocat(error.localizedDescription);
        [self hideLoadingView];
        self.isFetchInProgress = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

#pragma mark - HBSubscribeRecordCellDelegate

- (void)subscribeRecordCell:(HBSubscribeRecordCell *)cell releseModel:(HBSubscribeRecordModel *)model {
    kShowHud;
    [model releaseSubscribeWithSuccess:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        if ([obj succeeded]) {
            [self showSuccessWithMessage:obj.message];
        } else {
            [self showInfoWithMessage:obj.message];
        }
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

- (void)subscribeRecordCell:(HBSubscribeRecordCell *)cell showReleseVCWithModel:(HBSubscribeRecordModel *)model {
    HBReleaseRecordListViewController *vc = [HBReleaseRecordListViewController fromStoryboard];
    vc.ID = model.ID;
    kNavPush(vc);
}

#pragma mark - Setters & Getters

- (void)setModels:(NSArray<HBSubscribeRecordModel *> *)models {
    _models = models;
    
    self.tableViewDataSource.items = models;
    self.tableView.mj_footer.hidden = models.count < 5;
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
