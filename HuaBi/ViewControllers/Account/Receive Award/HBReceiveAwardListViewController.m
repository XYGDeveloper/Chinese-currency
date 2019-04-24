//
//  HBReceiveAwardListViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReceiveAwardListViewController.h"
#import "HBReceiveAwardCell.h"
#import "HBReceiveAwardModel+Request.h"
#import "NSObject+SVProgressHUD.h"

@interface HBReceiveAwardListViewController () <HBReceiveAwardCellDelegate, UITableViewDelegate>

@end

@implementation HBReceiveAwardListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.title = kLocat(@"Receive award");
    [self registerNibCellWithClassName:@"HBReceiveAwardCell"];
    self.tableView.rowHeight = 105.;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
}


#pragma mark - Override Super class Method
// Override Super class Method
- (void)requestDataWithPage:(NSInteger)page
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *array, YWNetworkResultModel *obj))success
                    failure:(void(^)(NSError *error))failure {
   
    [HBReceiveAwardModel requestReceiveAwardModelsWithPage:page pageSize:pageSize success:success failure:failure];
}

- (NSString *)cellIdentifier {
    return @"HBReceiveAwardCell";
}

- (void)configureCell:(HBReceiveAwardCell *)cell model:(HBReceiveAwardModel *)model {
    cell.model = model;
    cell.delegate = self;
}

#pragma mark - HBReceiveAwardCellDelegate

- (void)receiveAwardWithReceiveAwardCell:(HBReceiveAwardCell *)cell model:(HBReceiveAwardModel *)model {
    kShowHud;
    [model receiveAwardWithSuccess:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        if ([obj succeeded]) {
            [self showSuccessWithMessage:obj.message];
            model.status = @"1";
            [self.tableView reloadData];
        } else {
           [self showInfoWithMessage:obj.message];
        }
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
