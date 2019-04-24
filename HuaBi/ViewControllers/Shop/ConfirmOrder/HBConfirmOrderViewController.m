//
//  HBConfirmOrderViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/9.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderViewController.h"
#import "HBConfirmOrderPayMethodCell.h"
#import "HBConfirmOrderBalanceCell.h"
#import "HBConfirmOrderDeliveryMethodCell.h"
#import "HBConfirmOrderBuyerMessageCell.h"
#import "HBConfirmOrderGoodsCell.h"
#import "HBConfirmOrderAddressCell.h"
#import "HBAddressListViewController.h"
#import "HBConfirmOrderDataModel+Request.h"
#import "NSObject+SVProgressHUD.h"
#import "HBConfirmOrderCurrencyModel.h"
#import "HBTokenTopUpTableViewController.h"
#import "HBMallAddressModel.h"
#import "HBConfirmOrderPasswordView.h"
#import "HBOrderManagementWebViewController.h"

typedef NS_ENUM(NSInteger, HBConfirmOrderViewControllerSection) {
    HBConfirmOrderViewControllerSectionAddress = 0,
    HBConfirmOrderViewControllerSectionGoods,
    HBConfirmOrderViewControllerSectionOther,
};

@interface HBConfirmOrderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic, strong) UILabel *payMethodLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *deliverMethodLabel;
@property (nonatomic, strong) UITextView *buyerMessageTextView;

@property (nonatomic, strong) HBMallAddressModel *selectedAddressModel;

@property (nonatomic, strong) HBConfirmOrderDataModel *model;

@property (nonatomic, strong) NSArray<HBShopGoodModel *> *goodsModels;
@property (nonatomic, strong) NSArray<HBConfirmOrderCurrencyModel *> *currencyModels;

@property (nonatomic, strong) HBConfirmOrderCurrencyModel *selectedCurrencyModel;

@property (nonatomic, strong) HBConfirmOrderPasswordView *passwordView;

@end

@implementation HBConfirmOrderViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Shop" bundle:nil] instantiateViewControllerWithIdentifier:@"HBConfirmOrderViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"确认订单";
    self.tableView.backgroundColor = kColorFromStr(@"F4F4F4");
    
    self.bottomContainerView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bottomContainerView.layer.shadowOpacity = 0.3;
    self.bottomContainerView.layer.shadowRadius = 2;
    self.bottomContainerView.layer.shadowOffset = CGSizeMake(0, -2);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self _requsetData];
}

#pragma mark - Private

- (void)_requsetData {
    kShowHud;
    [HBConfirmOrderDataModel requestConfirmOrderWithCartIDs:self.cartIDs
                                                      specs:self.spec_array
                                                 isFromCart:self.isFromCart
                                                    success:^(HBConfirmOrderDataModel * _Nonnull data, YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        self.model = data;
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HBConfirmOrderViewControllerSectionAddress: {
             HBConfirmOrderAddressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HBConfirmOrderAddressCell"];
            cell.model = self.selectedAddressModel;
            return cell;
        }
            break;
            
        case HBConfirmOrderViewControllerSectionGoods: {
            HBConfirmOrderGoodsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HBConfirmOrderGoodsCell"];
            cell.model = self.goodsModels[indexPath.row];
            return cell;
        }
            break;
            
        case HBConfirmOrderViewControllerSectionOther:{
            switch (indexPath.row) {
                case 0:
                {
                    HBConfirmOrderPayMethodCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HBConfirmOrderPayMethodCell"];
                    self.payMethodLabel = cell.payMethodLabel;
                    return cell;
                }
                    break;
                    
                case 1:
                {
                    HBConfirmOrderBalanceCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HBConfirmOrderBalanceCell"];
                    self.balanceLabel = cell.balanceLabel;
                    return cell;
                }
                    break;
                    
                case 2:
                {
                    HBConfirmOrderDeliveryMethodCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HBConfirmOrderDeliveryMethodCell"];
                    self.deliverMethodLabel = cell.deliverMethodLabel;
                    return cell;
                }
                    break;
                    
                case 3:
                {
                    HBConfirmOrderBuyerMessageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HBConfirmOrderBuyerMessageCell"];
                    self.buyerMessageTextView = cell.buyerMessageTextView;
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
            
        case HBConfirmOrderViewControllerSectionAddress:
            return 1;
            break;
            
        case HBConfirmOrderViewControllerSectionGoods:
            return self.goodsModels.count;
            break;
            
        case HBConfirmOrderViewControllerSectionOther:
            return 4;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            
        case HBConfirmOrderViewControllerSectionAddress:
            return 75.;
            break;
            
        case HBConfirmOrderViewControllerSectionGoods:
            return 100;
            break;
            
        case HBConfirmOrderViewControllerSectionOther:
            switch (indexPath.row) {
                case 3:
                    return 200.;
                    break;
                    
                default:
                    return 44.;
                    break;
            }
            break;
            
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case HBConfirmOrderViewControllerSectionAddress: {
            //选择地址
            HBAddressListViewController *vc = [HBAddressListViewController new];
            __weak typeof(self) weakSelf = self;
            vc.didSelectAddressBlock = ^(HBMallAddressModel *model) {
                weakSelf.selectedAddressModel = model;
            };
            kNavPush(vc);
        }
            break;
            
        case HBConfirmOrderViewControllerSectionGoods: {
            
        }
            break;
            
        case HBConfirmOrderViewControllerSectionOther: {
            if (indexPath.row == 0) {
                // 选择币种
                [self _showChoicePayMethodVC];
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 8.;
    }
    
    return 0.;
}

#pragma mark - Actions

- (IBAction)topUpAction:(id)sender {
    if (!_selectedCurrencyModel) {
        return;
    }
    HBTokenTopUpTableViewController *top = [HBTokenTopUpTableViewController fromStoryboard];
    top.currencyid = self.selectedCurrencyModel.currency_id;
    top.currencyname = self.selectedCurrencyModel.currency_name;
    kNavPush(top);
}


- (void)_showChoicePayMethodVC {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择结算方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.currencyModels enumerateObjectsUsingBlock:^(HBConfirmOrderCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj.currency_name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedCurrencyModel = obj;
        }];
        
        [alertController addAction:action];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)submitAction:(UIButton *)sender {
    
//    if (self.selectedAddressModel) {
//        [self showInfoWithMessage:@"请选择收货地址"];
//        return;
//    }
    
    NSString *payMessage = self.buyerMessageTextView.text;
    kShowHud;
    sender.enabled = NO;
    [HBConfirmOrderDataModel requestConfirmOrderSetp2WithCartIDs:self.cartIDs
                                                       addressID:self.selectedAddressModel.address_id
                                                      currencyID:self.selectedCurrencyModel.currency_id
                                                      payMessage:payMessage
                                                           specs:self.spec_array
                                                      isFromCart:self.isFromCart
                                                         success:^(NSString * _Nonnull orderNo, NSString *orderID, YWNetworkResultModel * _Nonnull obj)
    {
        sender.enabled = YES;
        kHideHud;
        [self _showPayPasswordViewWithOrderNo:orderNo orderID:orderID];
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        sender.enabled = YES;
        [self showErrorWithMessage:error.localizedDescription];
    }];
    
}

- (void)_showPayPasswordViewWithOrderNo:(NSString *)orderNo orderID:(NSString *)orderID {
    self.passwordView = [HBConfirmOrderPasswordView viewLoadNib];
    [self.passwordView showInWindow];
    
    __weak typeof(self) weakSelf = self;
    self.passwordView.orderNO = orderNo;
    self.passwordView.didSureBlock = ^(NSString *password) {
        [weakSelf _requestPayOrderWithPassword:password orderID:orderID];
    };
    
    self.passwordView.cancelBlock = ^{
        HBOrderManagementWebViewController *vc = [[HBOrderManagementWebViewController alloc] initOrderManagmentVC];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)_requestPayOrderWithPassword:(NSString *)password orderID:(NSString *)orderID {
    kShowHud;
    [HBConfirmOrderDataModel requestPayOrderWithOrderID:orderID password:password success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        [self.passwordView hide];
        [self showSuccessWithMessage:obj.message];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HBOrderManagementWebViewController *vc = [[HBOrderManagementWebViewController alloc] initOrderManagmentVC];
            kNavPush(vc);
        });
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}


#pragma mark - Setters

- (void)setSelectedAddressModel:(HBMallAddressModel *)selectedAddressModel {
    _selectedAddressModel = selectedAddressModel;
    [self.tableView reloadData];
}

- (void)setSelectedCurrencyModel:(HBConfirmOrderCurrencyModel *)selectedCurrencyModel {
    _selectedCurrencyModel = selectedCurrencyModel;
    
    self.payMethodLabel.text = selectedCurrencyModel.currency_name ?: @"--";
    self.balanceLabel.text = selectedCurrencyModel.balance ?: @"--";
    self.amountLabel.text = [NSString stringWithFormat:@"%@ %@", selectedCurrencyModel.amount ?: @"--", selectedCurrencyModel.currency_name ?: @""];
}

- (void)setModel:(HBConfirmOrderDataModel *)model {
    _model = model;
    if (!_selectedAddressModel) {
        _selectedAddressModel = model.address_info;
    }
   
    if (!self.selectedCurrencyModel) {
        self.selectedCurrencyModel = [model.currency filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"currency_name='KOK'"]].firstObject;
    } else {
        if (model.currency.count == 0) {
            return;
        }
        NSInteger index = [model.currency indexOfObject:self.selectedCurrencyModel];
        self.selectedCurrencyModel = model.currency[index];
    }
    
    self.goodsModels = model.goodsModels;
    self.currencyModels = model.currency;
    [self.tableView reloadData];
}

@end
