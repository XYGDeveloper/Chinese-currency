//
//  HBDepositRecordsViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBDepositRecordsViewController.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"
#import "HBBaseTableViewDataSource.h"
#import "HBMoneyInterestLogModel+Request.h"
#import "HBMoneyInterestLogCell.h"

@interface HBDepositRecordsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Names

@property (nonatomic, strong) HBBaseTableViewDataSource *tableViewDataSource;

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

static NSString *const kHBMoneyInterestLogCellIdentifier = @"HBMoneyInterestLogCell";

@implementation HBDepositRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"Money Interest Deposit title");
    self.tableView.backgroundColor = kThemeBGColor;
    self.tableViewDataSource = [[HBBaseTableViewDataSource alloc] initWithItems:self.models cellIdentifier:kHBMoneyInterestLogCellIdentifier cellConfigureBlock:^(HBMoneyInterestLogCell  *_Nonnull cell, HBMoneyInterestLogModel  *_Nonnull model) {
        cell.model = model;
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

- (void)_setupLabelNames {

}

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
    
    [HBMoneyInterestLogModel requestMoneyInterestLogsWithPage:self.currentPage success:^(NSArray<HBMoneyInterestLogModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
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


#pragma mark - Setters

- (void)setModels:(NSArray *)models {
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
