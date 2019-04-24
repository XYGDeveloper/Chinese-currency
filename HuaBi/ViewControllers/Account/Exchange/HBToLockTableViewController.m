//
//  HBTurnToLockUpTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBToLockTableViewController.h"
#import "HBExchangeRequest.h"
#import "NSObject+SVProgressHUD.h"
#import "UIViewController+HBLoadingView.h"
#import "UITextField+ChangeClearButton.h"

@interface HBToLockTableViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, copy) NSString *numberString;

//Label names

@property (weak, nonatomic) IBOutlet UILabel *toLockTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnInNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation HBToLockTableViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Exchange" bundle:nil] instantiateViewControllerWithIdentifier:@"HBToLockTableViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"To_Lock");
    self.nameLabel.text = kLocat(@"Asset_name_");
    self.availableNumberLabel.text = kLocat(@"Available_Number");
    self.turnInNumberLabel.text = kLocat(@"Transfer_Number");
    self.tradePasswordLabel.text = kLocat(@"Transaction_password_");
    self.toLockTitleLabel.text = kLocat(@"Turn_lock_operation");
    self.tipsLabel.text = kLocat(@"HBToLockTableViewController_Tips");
    [self.allButton setTitle:kLocat(@"OTC_order_all") forState:UIControlStateNormal];
    self.rightBarButtonItem.title = kLocat(@"Turn_lock_records");
    self.numberTextField.placeholder = kLocat(@"Enter_the_Transfer_Number");
    self.passwordTextField.placeholder = kLocat(@"Enter_the_Transaction_password_");
    [self.confirmButton setTitle:kLocat(@"Confirm_transfer") forState:UIControlStateNormal];
    self.tableView.backgroundColor = kThemeBGColor;
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    
    [self.numberTextField _changeClearButton];
    [self _requestKokNumber];
}

#pragma mark - Private


- (void)_requestKokNumber {
    [self.activityIndicatorView startAnimating];
    self.numberString = nil;
    self.numberLabel.hidden = YES;
    [HBExchangeRequest requestExchangeKokNumberWithSuccess:^(NSString * _Nonnull number, YWNetworkResultModel * _Nonnull obj) {
        self.numberString = number;
        [self.activityIndicatorView stopAnimating];
        [self hideLoadingView];
        self.numberLabel.hidden = NO;
    } failure:^(NSError * _Nonnull error) {
        [self hideLoadingView];
        [self.activityIndicatorView stopAnimating];
        [self showErrorWithMessage:error.localizedDescription];
        self.numberLabel.hidden = NO;
    }];
}

#pragma mark - Actions

- (IBAction)allAction:(id)sender {
    self.numberTextField.text = self.numberLabel.text;
}

- (IBAction)submitAction:(id)sender {
    NSString *num = self.numberTextField.text;
    NSString *pwd = self.passwordTextField.text;
    if ([num floatValue] < 100) {
        [self showInfoWithMessage:kLocat(@"HBToLockTableViewController_msg1")];
        [self.numberTextField becomeFirstResponder];
        return;
    }
    if (pwd.length != 6) {
        [self showInfoWithMessage:kLocat(@"LPWDLengthLessThan6")];
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    
    kShowHud;
    [HBExchangeRequest requestExchangeToLockWithNumber:num pwd:pwd success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        if ([obj succeeded]) {
            [self showSuccessWithMessage:obj.message];
            self.numberTextField.text = nil;
            self.passwordTextField.text = nil;
            [self _requestKokNumber];
        } else {
            [self showInfoWithMessage:obj.message];
        }
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

#pragma mark - Setters

- (void)setNumberString:(NSString *)numberString {
    _numberString = numberString;
    
    self.numberLabel.text = numberString ?: @"--";
}

@end
