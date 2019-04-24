//
//  HBSubscribeListViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeListViewController.h"
#import "HBSubscribeCell.h"
#import "HBSubscribeMenuViewController.h"
#import "HBSubscribeModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"
#import "HBSubscribeDetailContainerViewController.h"

@interface HBSubscribeListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordsBarButtonItem;

@property (nonatomic, strong) HBSubscribeMenuViewController *menuVC;
@property (nonatomic, strong) NSArray<HBSubscribeModel *> *models;
@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;
@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation HBSubscribeListViewController

#pragma mark - Lifecycle

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Subscribe" bundle:nil] instantiateViewControllerWithIdentifier:@"HBSubscribeListViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recordsBarButtonItem.title = kLocat(@"Subscription Records");
    
    self.tableView.backgroundColor = kThemeBGColor;
    self.title = kLocat(@"Subscription");
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    self.tableView.mj_footer.hidden = YES;
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    [self _firstRequestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSubscribeDetailVC"]) {
        HBSubscribeModel *model = [self modelAtIndexPath:self.tableView.indexPathForSelectedRow];
        HBSubscribeDetailContainerViewController *vc = segue.destinationViewController;
        vc.model = model;
    }
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
    
    [HBSubscribeModel requestSubscribeListWithPage:self.currentPage pageSize:kPageSize success:^(NSArray<HBSubscribeModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj)  {
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


- (HBSubscribeModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.models.count) {
        return self.models[indexPath.row];
    }
    
    return nil;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

static NSString *const kHBSubscribeCellIdentifier = @"HBSubscribeCell";
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HBSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBSubscribeCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.tappedSubscribeBlock = ^(HBSubscribeModel *model) {
        weakSelf.menuVC.model = model;
        [weakSelf.menuVC showInViewController:self];
    };
    
    cell.model = [self modelAtIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getters & Setters

- (void)setModels:(NSArray<HBSubscribeModel *> *)models {
    _models = models;
    self.tableView.mj_footer.hidden = models.count < 5;
    [self.tableView reloadData];
}

- (HBSubscribeMenuViewController *)menuVC {
    if (!_menuVC) {
        _menuVC = [HBSubscribeMenuViewController fromStoryboard];
        
        __weak typeof(self) weakSelf = self;
        _menuVC.operatedDoneBlock = ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf performSegueWithIdentifier:@"showSubscribeRecordsVC" sender:nil];
            });
        };
    }
    
    return _menuVC;
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
