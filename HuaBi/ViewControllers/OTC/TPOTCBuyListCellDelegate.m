//
//  TPOTCBuyListCellDelegate.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyListCellDelegate.h"
#import "YWAlert.h"
#import "TPOTCPayWayListController.h"
#import "HBOTCTradeBankModel+Request.h"
#import "TPOTCBuyOrderDetailView.h"
#import "HBOTCTradeInfoDetailTableViewController.h"
#import "NSObject+SVProgressHUD.h"
#import "ZJPayPopupView.h"
#import "NTESVerifyCodeManager+HB.h"

@interface TPOTCBuyListCellDelegate () <NTESVerifyCodeManagerDelegate, ZJPayPopupViewDelegate>

@property (nonatomic, weak) YJBaseViewController *vc;

@property (nonatomic, copy) NSArray<NSString *> *myPayWays;

@property(nonatomic,strong)TPOTCBuyOrderDetailView *detailView;

@property (nonatomic, strong) TPOTCOrderModel *model;

@property (nonatomic, copy) NSString *verifyStr;

@property (nonatomic, copy) NSString *password;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@end

@implementation TPOTCBuyListCellDelegate

- (instancetype)initWithViewController:(YJBaseViewController *)vc {
    self = [super init];
    if (self) {
        self.vc = vc;
        
    }
    return self;
}

#pragma mark - Public
- (void)requestMyPaywas {
    [HBOTCTradeBankModel requestPayWaysWithSuccess:^(NSArray<NSString *> * _Nonnull payWays, YWNetworkResultModel * _Nonnull obj) {
        self.myPayWays = payWays;
        [self.vc.view hideHUD];
    } failure:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - TPOTCBuyListCellDelegate

- (void)buyListCell:(TPOTCBuyListCell *)cell didSelectModel:(TPOTCOrderModel *)model {
    self.model = model;
    if ([Utilities isExpired]) {
        [self.vc gotoLoginVC];
    }else if(kUserInfo.verify_state.intValue != 1){
        [self.vc showTips:kLocat(@"k_in_c2c_tips")];
    }else{
        if (!model.isTypeOfBuy) {
            [self _getMyPaywaysWithCompletion:^(NSArray<NSString *> *myPayways) {
                BOOL hasSupportedPayWays =  [self _checkMyPayWays:myPayways hasSupportedPayWays:model.money_type];
                if (hasSupportedPayWays) {
                    [self checkCurrentOrderStatusWith:model];
                } else {
                    // Alert View
                    [self _showHaveNoAnySupportedPayWays:model.money_type];
                }
            }];
        } else {
            [self checkCurrentOrderStatusWith:model];
        }
    }
}

#pragma mark - Private

- (BOOL)_checkMyPayWays:(NSArray<NSString *> *)myPayWays hasSupportedPayWays:(NSArray<NSString *> *)supportedPayWays {
    BOOL result = NO;
    
    for (NSString *pay in supportedPayWays) {
        if ([myPayWays containsObject:pay]) {
            result = YES;
            break;
        }
    }
    return result;
}

- (void)_showHaveNoAnySupportedPayWays:(NSArray<NSString *> *)payways {
    
    NSMutableString *paywaysString = @"".mutableCopy;
    for (NSString *payway in payways) {
        NSString *key = [NSString stringWithFormat:@"k_popview_select_pay%@", payway];
        [paywaysString appendFormat:@"%@、", kLocat(key)];
    }
    if (paywaysString.length > 0) {
        paywaysString = [paywaysString substringToIndex:paywaysString.length - 1].mutableCopy;
    }
    
    
    NSString *tips = kLocat(@"TPOTCBuyListCellDelegate.tips");
    tips = [tips stringByReplacingOccurrencesOfString:@"xxx" withString:paywaysString.copy ?: @"--"];
    [YWAlert alertWithTitle:nil message:tips sureTitle:kLocat(@"TPOTCBuyListCellDelegate.add") cancelTitle:kLocat(@"Cancel") sureAction:^{
        [self.vc.navigationController pushViewController:[TPOTCPayWayListController new] animated:YES];
    } cancelAction:nil inViewController:self.vc];
}



- (void)_getMyPaywaysWithCompletion:(void(^)(NSArray<NSString *> *myPayways))completion {
    [self.vc.view showHUD];
    if (self.myPayWays) {
        [self.vc.view hideHUD];
        if (completion) {
            completion(self.myPayWays);
        }
    } else {
        [HBOTCTradeBankModel requestPayWaysWithSuccess:^(NSArray<NSString *> * _Nonnull payWays, YWNetworkResultModel * _Nonnull obj) {
            self.myPayWays = payWays;
            if (completion) {
                completion(self.myPayWays);
            }
            [self.vc.view hideHUD];
        } failure:^(NSError * _Nonnull error) {
            [self.vc.view hideHUD];
            [self showInfoWithMessage:error.localizedDescription];
        }];
    }
}

-(void)gotoBuyOrderDetailVC
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (self.detailView.isTypeOfNumber) {
        param[@"num"] = self.detailView.getNumber;
    } else {
        param[@"money"] = self.detailView.getTotalMoney;
    }
    
    param[@"orders_id"] = self.detailView.model.orders_id;
    param[@"validate"] = _verifyStr;
    if (!self.model.isTypeOfBuy) {
        param[@"pwd"] = self.password;
    }
    [self.vc.view showHUD];
    NSString *apiURIString = self.model.isTypeOfBuy ? @"/TradeOtc/buy" : @"/TradeOtc/sell";
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:apiURIString] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [self.vc.view hideHUD];
        if (error) {
            [self showInfoWithMessage:error.localizedDescription];
            return ;
        }
        if (success) {
            [self.detailView hide];
            self.password = nil;
            NSString *tradeID = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"trade_id"];
            HBOTCTradeInfoDetailTableViewController *svc = [HBOTCTradeInfoDetailTableViewController fromStoryboard];
            svc.tradeID = tradeID;
            [self.vc.navigationController pushViewController:svc animated:YES];
        }else{
            
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            if (code == 10100) {
            }else{
                [self showInfoWithMessage:[responseObj ksObjectForKey:kMessage]];
            }
        }
    }];
}

/**  检查订单可交易量  */
-(void)checkCurrentOrderStatusWith:(TPOTCOrderModel *)model
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"orders_id"] = model.orders_id;
    
    [self.vc.view showHUD];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/updateavail"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        [self.vc.view hideHUD];
        if (error) {
            [self showInfoWithMessage:error.localizedDescription];
            return ;
        }
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideBaseOTCTopViewKey" object:nil];
            
            
            model.avail = ConvertToString([responseObj ksObjectForKey:kData][@"avail"]);
            
            self.detailView.model = model;
            [self.detailView show];
        }else{
            [self.vc showTips:[responseObj ksObjectForKey: kMessage]];
        }
    }];
}

#pragma mark - Getters

-(TPOTCBuyOrderDetailView *)detailView {
    if (_detailView == nil) {
        
        _detailView =  [TPOTCBuyOrderDetailView viewLoadNib];
        _detailView.frame = kRectMake(0, 0, kScreenW, kScreenH);
        
        SEL action = self.model.isTypeOfBuy ? @selector(showVerifyInfo) : @selector(showPayPassowrdPopupView);
        [_detailView.dealButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _detailView;
}

#pragma mark - 图形验证码

-(void)showVerifyInfo
{

    if (![self isValidNumberOrMoney]) {
        return;
    }
    
    [self.manager openVerifyCodeView:nil];
}

- (BOOL)isValidNumberOrMoney {
    NSString *moneyOrNumber = self.detailView.moneyOrNumberTextField.text;
    [self.detailView.moneyOrNumberTextField resignFirstResponder];
    [self.vc.view endEditing:YES];
    if (moneyOrNumber.length == 0){
        NSString *warning = self.detailView.isTypeOfNumber ? kLocat(@"OTC_buylist_inputvolume") : kLocat(@"OTC_buylist_inputmoney");
        [kKeyWindow showInfoWithMessage:warning];
        return NO;
    }
    
    return YES;
}

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message {

    if (result == YES) {
        _verifyStr = validate;
        [self gotoBuyOrderDetailVC];
        
    }else{
        _verifyStr = @"";
        [self.vc showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}

- (void)verifyCodeNetError:(NSError *)error {
    [self showInfoWithMessage:error.localizedDescription];
}

- (void)verifyCodeInitFailed:(NSString *)error {
    [self showInfoWithMessage:error];
}

- (void)showPayPassowrdPopupView {
    if (![self isValidNumberOrMoney]) {
        return;
    }
    self.payPopupView = [ZJPayPopupView new];
    self.payPopupView.delegate = self;
}

#pragma mark - ZJPayPopupViewDelegate
- (void)didPasswordInputFinished:(NSString *)password {
    [self.payPopupView hidePayPopView];
    self.password = password;
    [self gotoBuyOrderDetailVC];
}

-(NTESVerifyCodeManager *)manager {
    if (!_manager) {
        _manager = [NTESVerifyCodeManager getHBManager];
        _manager.delegate = self;
    }
    return _manager;
}



@end
