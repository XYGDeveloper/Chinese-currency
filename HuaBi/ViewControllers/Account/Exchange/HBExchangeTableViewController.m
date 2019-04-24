//
//  HBExchangeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeTableViewController.h"
#import "HBExchangeCurrencyPickerViewController.h"
#import "HBExchangeCurrencysModel+Request.h"
#import "NSObject+SVProgressHUD.h"
#import "UIViewController+HBLoadingView.h"
#import "YTMyassetDetailModel+Request.h"
#import "NSString+Operation.h"
#import "ZJPayPopupView.h"
#import "UITextField+HB.h"
#import "UITextField+ChangeClearButton.h"
#import "HBExchangeRecordViewController.h"

@interface HBExchangeTableViewController () <ZJPayPopupViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expectToNumberLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *availableActivityIndicatorView;


@property (nonatomic, strong) HBExchangeCurrencyPickerViewController *fromPickerVC;
@property (nonatomic, strong) HBExchangeCurrencyPickerViewController *toPickerVC;
@property (nonatomic, strong) HBExchangeCurrencysModel *currencysModel;
@property (nonatomic, strong) HBExchangeCurrencyModel *fromModel;
@property (nonatomic, strong) HBExchangeCurrencyModel *toModel;
@property (nonatomic, copy) NSString *availableValue;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@property (nonatomic, assign) BOOL isFetchCurrencysInProgress;

@end

@implementation HBExchangeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"Exchange");
    self.tableView.backgroundColor = kThemeBGColor;
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kColorFromStr(@"#0B132A");
    }];
    [self.numberTextField _changeClearButton];
    
    self.fromPickerVC = [HBExchangeCurrencyPickerViewController fromStoryboard];
    self.toPickerVC = [HBExchangeCurrencyPickerViewController fromStoryboard];
    
    __weak typeof(self) weakSelf = self;
    self.fromPickerVC.didSelectModelBlock = ^(HBExchangeCurrencyModel * _Nonnull model) {
        weakSelf.fromModel = model;
    };
    self.toPickerVC.didSelectModelBlock = ^(HBExchangeCurrencyModel * _Nonnull model) {
        weakSelf.toModel = model;
    };
    
    [self.numberTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [self _requestExchangeCurrencysModel];
}

- (void)dealloc {
    [self.numberTextField removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isEqual:self.numberTextField]) {
        [self _updateExpectToNumberLabel];
    }
}

#pragma mark - Private

- (void)_requestExchangeCurrencysModel {
    [self showLoadingView];
    if (self.isFetchCurrencysInProgress) {
        return;
    }
    self.isFetchCurrencysInProgress = YES;
    
    [HBExchangeCurrencysModel requestExchangeCurrencysWithSuccess:^(HBExchangeCurrencysModel * _Nonnull currencysModel, YWNetworkResultModel * _Nonnull obj)
    {
        self.isFetchCurrencysInProgress = NO;
        self.currencysModel = currencysModel;
        [self hideLoadingView];
    } failure:^(NSError * _Nonnull error)
    {
        self.isFetchCurrencysInProgress = NO;
        [self hideLoadingView];
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

- (void)_requestMyCurrencyNumber {
    self.availableValue = nil;
    [self.availableActivityIndicatorView startAnimating];
    [YTMyassetDetailModel requestMyAssetDetailWithCurrencyID:self.fromModel.currency_id success:^(YTMyassetDetailModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj)
     {
         [self.availableActivityIndicatorView stopAnimating];
         self.availableValue = model.currency_user.num;
     } failure:^(NSError *error) {
         [self.availableActivityIndicatorView stopAnimating];
     }];
}

#pragma mark - Actions

- (IBAction)showRecordsVC:(id)sender {
    UIViewController *vc = [HBExchangeRecordViewController new];
    kNavPush(vc);
}
- (IBAction)allAction:(id)sender {
    self.numberTextField.text = self.fromModel.num;
}

- (IBAction)submitAction:(id)sender {
    
    NSString *fromID = self.fromModel.currency_id;
    NSString *toID = self.toModel.currency_id;
    NSString *fromNum = self.numberTextField.text;
    
    if (fromID == nil || toID == nil) {
        //TODO
        [self _requestExchangeCurrencysModel];
        return;
    }
    
    if ([fromNum isEqualToString:@"0"] || [fromNum isEqualToString:@""]) {
        [self.numberTextField becomeFirstResponder];
        return;
    }
    
    self.payPopupView = [[ZJPayPopupView alloc] init];
    self.payPopupView.delegate = self;
    [self.payPopupView showPayPopView];
}


#pragma mark - ZJPayPopupViewDelegate

- (void)didPasswordInputFinished:(NSString *)password {
    
    NSString *fromID = self.fromModel.currency_id;
    NSString *toID = self.toModel.currency_id;
    NSString *fromNum = self.numberTextField.text;
    kShowHud;
    [HBExchangeCurrencysModel requestExchangeAddAPIWithPwd:password
                                                    fromID:fromID
                                                      toID:toID
                                                   fromNum:fromNum
                                                   success:^(YWNetworkResultModel * _Nonnull obj)
     {
         kHideHud;
        if ([obj succeeded]) {
            self.numberTextField.text = nil;
            [self.payPopupView hidePayPopView];
            [self showSuccessWithMessage:obj.message];
        } else {
            [self showInfoWithMessage:obj.message];
        }
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.fromPickerVC.currencyModes = self.currencysModel.from;
            [self.fromPickerVC show];
            break;
            
        case 3:
            self.toPickerVC.currencyModes = self.currencysModel.to;
            [self.toPickerVC show];
            break;
    }
}


#pragma mark - Setters

- (void)setCurrencysModel:(HBExchangeCurrencysModel *)currencysModel {
    _currencysModel = currencysModel;
    
    self.fromModel = _currencysModel.from.firstObject;
    self.toModel = _currencysModel.to.firstObject;
}

- (void)setFromModel:(HBExchangeCurrencyModel *)fromModel {
    if ([_fromModel isEqual:fromModel]) {
        return;
    }
    _fromModel = fromModel;
    
    [self _updateAvailableValueLabel];
    [self _updateFromTextFieldAndLabel];
//    [self _requestMyCurrencyNumber];
    [self _updateRateLabel];
}

- (void)setToModel:(HBExchangeCurrencyModel *)toModel {
    _toModel = toModel;
    
    [self _updateToTextField];
    [self _updateRateLabel];
}



- (void)setRate:(NSString *)rate {
    _rate = rate;
    
    [self _updateExpectToNumberLabel];
}

#pragma mark - Update UI

- (void)_updateRateLabel {
    if (self.fromModel == nil || self.toModel == nil) {
        return;
    }
    
    NSString *fromCny = self.fromModel.cny;
    NSString *toCny = self.toModel.cny;
    
    self.rate = [fromCny resultByDividingByNumber:toCny];
    
    self.rateLabel.text = [NSString stringWithFormat:@"1 %@ ≈ %@ %@", self.fromModel.currency_name, [self.rate roundWithScale:6], self.toModel.currency_name];
}

- (void)_updateAvailableValueLabel {
    self.availableValueLabel.text = [NSString stringWithFormat:@"(%@ %@)", self.fromModel.num ?: @"--", self.fromModel.currency_name ?: @""];
}

- (void)_updateToTextField {
    self.toTextField.text = _toModel.currency_name;
}

- (void)_updateFromTextFieldAndLabel {
    self.fromTextField.text = _fromModel.currency_name;
    self.fromLabel.text = _fromModel.currency_name;
}

- (void)_updateExpectToNumberLabel {
    NSString *number = self.numberTextField.text;
    number = [self.rate resultByMultiplyingByNumber:number];
    NSString *feePrecent = [self.toModel.fee resultByDividingByNumber:@"100"];
    NSString *fee = [number resultByMultiplyingByNumber:feePrecent];
    NSString *result = [number resultBySubtractingByNumber:fee];
    self.expectToNumberLabel.text = result;
}

@end
