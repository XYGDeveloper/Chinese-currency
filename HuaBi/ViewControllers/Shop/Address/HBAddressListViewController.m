//
//  HBAddressListViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBAddressListViewController.h"
#import "HBAddressDetailViewController.h"
#import "HBMallAddressModel.h"
#import "HBAddressListCell.h"
#import "YWAlert.h"
#import "NSObject+SVProgressHUD.h"

@interface HBAddressListViewController () <UITableViewDelegate, HBAddressListCellDelegate>

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation HBAddressListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.title = @"收货地址";
    [self registerNibCellWithClassName:@"HBAddressListCell"];
    self.tableView.rowHeight = 101.;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = kColorFromStr(@"F4F4F4");
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 140 + 20, 0);

    [self.view addSubview:self.addButton];
    self.tableView.mj_footer = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addressDetailViewControllerChanged) name:@"HBAddressDetailViewControllerChanged" object:nil];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _addButton.bottom = CGRectGetHeight(self.view.bounds) - 40;
}

#pragma mark - Override Super class Method
// Override Super class Method
- (void)requestDataWithPage:(NSInteger)page
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *array, YWNetworkResultModel *obj))success
                    failure:(void(^)(NSError *error))failure {
    
    [HBMallAddressModel requestAddressListWithSuccess:success failure:failure];
}

- (NSString *)cellIdentifier {
    return @"HBAddressListCell";
}

- (void)configureCell:(HBAddressListCell *)cell model:(HBMallAddressModel *)model {
    cell.model = model;
    cell.delegate = self;
}

#pragma mark - HBAddressListCellDelegate

- (void)addressListCell:(HBAddressListCell *)cell editWithModel:(HBMallAddressModel *)model {
    HBAddressDetailViewController *vc = [HBAddressDetailViewController getEditVCWithModel:model];
    kNavPush(vc);
}

- (void)addressListCell:(HBAddressListCell *)cell deleteWithModel:(HBMallAddressModel *)model {
    [YWAlert alertWithTitle:@"确认删除收货地址" message:nil sureTitle:@"删除" cancelTitle:@"取消" sureAction:^{
        kShowHud;
        [model requestDeleteAddressWithSuccess:^(YWNetworkResultModel * _Nonnull obj) {
            kHideHud;
            if ([obj succeeded]) {
                [self showSuccessWithMessage:obj.message];
                [self.tableView.mj_header beginRefreshing];
            } else {
                [self showInfoWithMessage:obj.message];
            }
        } failure:^(NSError * _Nonnull error) {
            kHideHud;
            [self showErrorWithMessage:error.localizedDescription];
        }];
    } cancelAction:nil inViewController:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HBMallAddressModel *model = [self itemAtIndexPath:indexPath];
    if (self.didSelectAddressBlock) {
        self.didSelectAddressBlock(model);
        kNavPop;
    } else {
        HBAddressDetailViewController *vc = [HBAddressDetailViewController getShowedVCWithModel:model];
        kNavPush(vc);
    }
}

#pragma mark - Actions

- (void)_addAddressAction {
    HBAddressDetailViewController *vc = [HBAddressDetailViewController getAddVC];
    kNavPush(vc);
}

- (void)_addressDetailViewControllerChanged {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Getters

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton new];
        [_addButton setTitle:@"添加新地址" forState:UIControlStateNormal];
        _addButton.backgroundColor = kColorFromStr(@"#4173C8");
        _addButton.x = 25;
        _addButton.width = kScreenW - 50;
        _addButton.height = 44;
//        _addButton.bottom = kScreenH - 96;
        
        [_addButton addTarget:self action:@selector(_addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addButton;
}

@end
