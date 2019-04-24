//
//  HBExchangeRecordListTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeRecordListTableViewController.h"
#import "HBExchangeRecordCell.h"
#import "HBExchangeModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"

@interface HBExchangeRecordListTableViewController ()

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray<HBExchangeModel *> *models;

@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

@implementation HBExchangeRecordListTableViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Exchange" bundle:nil] instantiateViewControllerWithIdentifier:@"HBExchangeRecordListTableViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kThemeBGColor;
    [self _requestExchangeRecordsWithIsRefresh:YES];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
}

#pragma mark - Private

- (void)_firstRequestData {
    [self showLoadingView];
    [self _refreshData];
}

- (void)_refreshData {
    [self _requestExchangeRecordsWithIsRefresh:YES];
}

- (void)_loadData {
    [self _requestExchangeRecordsWithIsRefresh:NO];
}

static NSInteger const kPageSize = 10;

- (void)_requestExchangeRecordsWithIsRefresh:(BOOL)isRefresh {
    if (self.isFetchInProgress) {
        return;
    }
    
    self.isFetchInProgress = YES;
    
    if (isRefresh) {
        self.currentPage = 1;
    }
    
    [HBExchangeModel requestExchangeModelsWithStatus:self.status page:self.currentPage pageSize:kPageSize success:^(NSArray<HBExchangeModel *> *array, YWNetworkResultModel * _Nonnull obj) {
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.models.count;
}

- (HBExchangeModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.models.count) {
        return self.models[indexPath.row];
    }
    
    return nil;
}

static NSString *const kHBExchangeRecordCellIdentifier = @"HBExchangeRecordCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBExchangeRecordCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    HBExchangeModel *model = [self modelAtIndexPath:indexPath];
    [cell configureCellWithModel:model];
    return cell;
}


#pragma mark - Setters

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

- (void)setModels:(NSArray<HBExchangeModel *> *)models {
    _models = models;
    self.tableView.mj_footer.hidden = models.count < 5;
    [self.tableView reloadData];
}

@end
