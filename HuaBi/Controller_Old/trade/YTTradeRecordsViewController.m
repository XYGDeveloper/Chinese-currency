//
//  YTTradeRecordsViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeRecordsViewController.h"
#import "YTData_listModel.h"
#import "YTTradeRecordModel+Request.h"
#import "YTTradeRecordCell.h"
#import "YWEmptyDataSetDataSource.h"

@interface YTTradeRecordsViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<YTTradeRecordModel *> *recordModels;
@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;

@end

@implementation YTTradeRecordsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_requestTradeRecordModels)];
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView title:kLocat(@"empty_msg")];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    
    self.timeLabel.text = kLocat(@"Time");
    self.typeLabel.text = kLocat(@"Type");
    self.tradePriceLabel.text = kLocat(@"Trade_price");
    self.tradeNumberLabel.text = kLocat(@"Trade_volume");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([Utilities isExpired]) {
        self.recordModels = nil;
    }
}

#pragma mark - Private

- (void)_requestTradeRecordModels {
    [YTTradeRecordModel requestTradeRecordsWithCurrencyID:self.model.currency_id success:^(NSArray<YTTradeRecordModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        [self.tableView.mj_header endRefreshing];
        self.recordModels = array;
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self showTips:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTTradeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTTradeRecordCell" forIndexPath:indexPath];
    cell.model = self.recordModels[indexPath.row];
    return cell;
}

#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTTradeRecordsViewController"];
}

- (void)setModel:(ListModel *)model {
    _model = model;
    [self _requestTradeRecordModels];
}

- (void)setRecordModels:(NSArray<YTTradeRecordModel *> *)recordModels {
    _recordModels = recordModels;
    
    [self.tableView reloadData];
}

@end
