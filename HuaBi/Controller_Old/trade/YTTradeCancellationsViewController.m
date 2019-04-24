//
//  YTTradeCancellationsViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeCancellationsViewController.h"
#import "YTTradeCancellationsCell.h"
#import "YTTradeUserOrderModel+Request.h"
#import "YWEmptyDataSetDataSource.h"
#import "YTData_listModel.h"
#import "YWAlert.h"

@interface YTTradeCancellationsViewController () <UITableViewDataSource, UITableViewDelegate, YTTradeCancellationsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<YTTradeUserOrderModel *> *orders;
@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

@implementation YTTradeCancellationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_requestTradeUserOrderModels)];
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView title:kLocat(@"empty_msg")];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
//    [self _requestTradeUserOrderModels];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([Utilities isExpired]) {
        self.orders = nil;
    }
}


#pragma mark - Private

- (void)_requestTradeUserOrderModels {
    [YTTradeUserOrderModel requestTradeUserOrdersWithCurrencyID:self.model.currency_id success:^(NSArray<YTTradeUserOrderModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        [self.tableView.mj_header endRefreshing];
        self.orders = array;
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self showTips:error.localizedDescription];
    }];
}


#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTTradeCancellationsViewController"];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YTTradeCancellationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTTradeCancellationsCell" forIndexPath:indexPath];
    cell.model = self.orders[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

#pragma mark - YTTradeCancellationsCellDelegate

- (void)tradeCancellationsCell:(YTTradeCancellationsCell *)cell deleteModel:(YTTradeUserOrderModel *)model {
    [YWAlert alertWithTitle:kLocat(@"C_Tip") message:kLocat(@"C_TipDetail") sureAction:^{
        [model cancelTradeOrdersWithSuccess:^(YWNetworkResultModel * _Nonnull obj) {
            [self showTips:obj.message];
            if ([obj succeeded]) {
                [self _deleteModel:model];
            }
        } failure:^(NSError * _Nonnull error) {
            [self showTips:error.localizedDescription];
        }];
        
        [self _deleteModel:model];
    } cancelAction:nil inViewController:self];
}

- (void)_deleteModel:(YTTradeUserOrderModel *)model {
    
//    NSInteger index = [self.orders indexOfObject:model];
    NSMutableArray *array = self.orders.mutableCopy;
    [array removeObject:model];
    self.orders = array.copy;
//    [self.tableView reloadData];
//    [self.tableView deleteRow:index inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - Setters

- (void)setOrders:(NSArray<YTTradeUserOrderModel *> *)orders {
    _orders = orders;
    
    [self.tableView reloadData];
}

- (void)setModel:(ListModel *)model {
    _model = model;
    [self _requestTradeUserOrderModels];
}

@end
