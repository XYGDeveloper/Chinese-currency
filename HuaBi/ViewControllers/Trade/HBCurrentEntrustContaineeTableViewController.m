//
//  HBCurrentEntrustContaineeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCurrentEntrustContaineeTableViewController.h"
#import "HBCurrentEntrustCell.h"
#import "YWAlert.h"
#import "YTTradeUserOrderModel+Request.h"
#import "YTData_listModel.h"
#import "HBCurrentEntrustViewController.h"

@interface HBCurrentEntrustContaineeTableViewController ()

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (strong, nonatomic) IBOutlet UIView *cellSelectedBackgroudView;

@end

@implementation HBCurrentEntrustContaineeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"HBCurrentEntrustCell" bundle:nil] forCellReuseIdentifier:@"HBCurrentEntrustCell"];
    self.isFetchInProgress = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginOut) name:kLoginOutKey object:nil];
}

- (void)_loginOut {
    self.orders = nil;
}

- (void)_requestUserOrders {
    if (!self.model) {
        return;
    }
    
    if (self.isFetchInProgress) {
        return;
    }
    self.isFetchInProgress = YES;
    [YTTradeUserOrderModel requestTradeUserOrdersWithCurrencyModel:self.model isTypeOfBuy:nil rows:10 page:0 isHistory:NO success:^(NSArray<YTTradeUserOrderModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        self.orders = array;
        self.isFetchInProgress = NO;
    } failure:^(NSError * _Nonnull error) {
        self.isFetchInProgress = NO;
    }];
}

#pragma mark - TableVeiwDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEmpty) {
        return 100.;
    }
    return kCellHeight;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isEmpty) {
        return 1;
    }
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEmpty) {
        return [tableView dequeueReusableCellWithIdentifier:@"HBCurrentEntrustEmptyCell" forIndexPath:indexPath];
    }
    
    HBCurrentEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBCurrentEntrustCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.model = self.orders[indexPath.row];
    cell.cancelBlock = ^(YTTradeUserOrderModel *model) {
        [weakSelf _showDeleteAlertWithModel:model];
    };
    cell.selectedBackgroundView = self.cellSelectedBackgroudView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        [self _deleteModel:model];
    } cancelAction:nil inViewController:self];
}

- (void)_deleteModel:(YTTradeUserOrderModel *)model {
    
    NSMutableArray *array = self.orders.mutableCopy;
    [array removeObject:model];
    self.orders = array.copy;
}

#pragma mark - Setters & Getters
- (void)setOrders:(NSArray<YTTradeUserOrderModel *> *)orders {
    _orders = orders;
    
    [self.tableView reloadData];
    if (self.heightChangedBlock) {
        self.heightChangedBlock();
    }
}

- (void)setModel:(ListModel *)model {
    _model = model;
    
    [self _requestUserOrders];
}

//- (void)setIsTypeOfBuy:(BOOL)isTypeOfBuy {
////    if (_isTypeOfBuy == isTypeOfBuy) {
////        return;
////    }
//    _isTypeOfBuy = isTypeOfBuy;
//    
//    [self _requestUserOrders];
//}

- (BOOL)isEmpty {
    return self.orders.count == 0;
}

#pragma mark - Public

- (CGFloat)getHeight {
    if (self.isEmpty) {
        return 100.;
    }
    return [HBCurrentEntrustContaineeTableViewController getHeightWithModels:self.orders];
}

static CGFloat const kCellHeight = 179;
+ (CGFloat)getHeightWithModels:(NSArray<YTTradeUserOrderModel *> *)models {
    return models.count * kCellHeight;
}
@end
