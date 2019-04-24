//
//  HBPullBaseTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBPullBaseTableViewController.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"
#import "HBBaseTableViewDataSource.h"

@interface HBPullBaseTableViewController ()

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

@implementation HBPullBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    self.tableViewDataSource = [[HBBaseTableViewDataSource alloc] initWithItems:self.models cellIdentifier:[self cellIdentifier] cellConfigureBlock:^(id _Nonnull cell, id _Nonnull model) {
        [weakSelf configureCell:cell model:model];
    }];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    self.tableView.mj_footer.hidden = YES;
    
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    [self _firstRequestData];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kThemeBGColor;
    
    self.pageSize = 10;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
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

//static NSInteger const kPageSize = 10;
- (void)_requestRecordsWithIsRefresh:(BOOL)isRefresh {
    
    if (self.isFetchInProgress) {
        return;
    }
    
    self.isFetchInProgress = YES;
    
    if (isRefresh) {
        self.currentPage = 1;
    }
    
    [self requestDataWithPage:self.currentPage pageSize:self.pageSize success:^(NSArray *array, YWNetworkResultModel *obj) {
        self.currentPage++;
        self.noMoreData = array.count < self.pageSize;
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

#pragma mark - Public

- (void)registerNibCellWithClassName:(NSString *)className {
    [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableViewDataSource itemAtIndexPath:indexPath];
}

#pragma mark - Subclass Override

- (NSString *)cellIdentifier {
    return nil;
}

- (void)configureCell:(id)cell model:(id)model {
    
}

 
- (void)requestDataWithPage:(NSInteger)page
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *array, YWNetworkResultModel *obj))success
                    failure:(void(^)(NSError *error))failure {
    
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

#pragma mark - Getters & Setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
