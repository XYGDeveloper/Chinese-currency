//
//  HBToLockRecordTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBToLockRecordTableViewController.h"
#import "HBToLockModel+Request.h"
#import "HBLockRecordCell.h"
#import "NSObject+SVProgressHUD.h"
#import "UIViewController+HBLoadingView.h"
#import "YWEmptyDataSetDataSource.h"

@interface HBToLockRecordTableViewController ()

@property (nonatomic, strong) NSArray<HBToLockModel *> *models;
@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

@implementation HBToLockRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kThemeBGColor;
    self.title = kLocat(@"To_Lock_Records");
    
    [self showLoadingView];
    [self _requestToLockRecords];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_requestToLockRecords)];
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView title:kLocat(@"empty_msg")];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    
}

#pragma mark - Private

- (void)_requestToLockRecords {
    [HBToLockModel requestExchangeToLockModelsWithSuccess:^(NSArray<HBToLockModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        self.models = array;
        [self.tableView reloadData];
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
        self.emptyDataSetDataSource.title = kLocat(@"empty_msg");
    } failure:^(NSError * _Nonnull error) {
        self.emptyDataSetDataSource.title = error.localizedDescription;
        [self hideLoadingView];
        [self showInfoWithMessage:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source

- (HBToLockModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.models.count) {
        return self.models[indexPath.row];
    }
    
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

static NSString *const kHBLockRecordCellIdentifier = @"HBLockRecordCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBLockRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBLockRecordCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    HBToLockModel *model = [self modelAtIndexPath:indexPath];
    [cell configWithModel:model];
    
    return cell;
}


@end
