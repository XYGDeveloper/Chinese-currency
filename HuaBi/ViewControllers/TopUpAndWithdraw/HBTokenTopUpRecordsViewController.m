//
//  HBTokenTopUpRecordsViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/19.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBTokenTopUpRecordsViewController.h"
#import "HBCancelTableViewCell.h"
#import "HBNonomalTableViewCell.h"
@interface HBTokenTopUpRecordsViewController () <UITableViewDelegate>

@end

@implementation HBTokenTopUpRecordsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.title = kLocat(@"充幣記錄");
    [self registerNibCellWithClassName:@"HBCancelTableViewCell"];
    [self registerNibCellWithClassName:@"HBNonomalTableViewCell"];

    self.tableView.rowHeight = 105.;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10.)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Override Super class Method
// Override Super class Method
- (void)requestDataWithPage:(NSInteger)page
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *array, YWNetworkResultModel *obj))success
                    failure:(void(^)(NSError *error))failure {
//    [HBReceiveAwardModel requestReceiveAwardModelsWithPage:page pageSize:pageSize success:success failure:failure];
    success(@[@"", @"", @"",], nil);
}

- (NSString *)cellIdentifier {
    return @"HBTokenTopUpRecordCell";
}

//- (void)configureCell:(HBTokenTopUpRecordCell *)cell model:(id)model {
////    cell.model = model;
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
