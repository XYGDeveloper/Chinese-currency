//
//  HBOTCCurrentADListViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/3.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCCurrentADListViewController.h"
#import "TPOTCMyADModel+Request.h"
#import "HBMyAdOfOtcCell.h"
#import "TPOTCADDetailController.h"

@interface HBOTCCurrentADListViewController () <UITableViewDelegate>

@end

@implementation HBOTCCurrentADListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self registerNibCellWithClassName:@"HBMyAdOfOtcCell"];
    self.tableView.rowHeight = 185.;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"kuserDidCancelAdActionKey" object:nil];
}

#pragma mark - Private
-(void)refreshData:(NSNotification *)noti
{
    TPCurrencyModel *model = noti.object;
    if ([model.currencyID isEqualToString:_model.currencyID]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - Override Super class Method

- (void)requestDataWithPage:(NSInteger)page
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *array, YWNetworkResultModel *obj))success
                    failure:(void(^)(NSError *error))failure {
    
    [TPOTCMyADModel requestMyADModelsWithCurrencyID:self.model.currencyID isHistory:self.isHistory page:page pageSize:pageSize success:success failure:failure];
}

- (void)configureCell:(HBMyAdOfOtcCell *)cell model:(TPOTCMyADModel *)model {
    [cell configureCellWithModel:model isHistory:self.isHistory];
}

- (NSString *)cellIdentifier {
    return @"HBMyAdOfOtcCell";
}

#pragma mark - UITableVeiwDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TPOTCADDetailController *vc = [TPOTCADDetailController new];
    vc.model = [self itemAtIndexPath:indexPath];
    vc.currencyID = _model.currencyID;
    vc.isHistory = self.isHistory;
    kNavPush(vc);
}

@end
