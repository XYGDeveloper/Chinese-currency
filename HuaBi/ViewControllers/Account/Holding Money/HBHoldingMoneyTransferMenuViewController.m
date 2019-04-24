//
//  HBHoldingMoneyTransferMenuViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHoldingMoneyTransferMenuViewController.h"
#import "HBMoneyInterestModel.h"
#import "NSObject+SVProgressHUD.h"
#import "XLBKeyboardMan.h"
#import "NSString+Operation.h"
#import "HBMoneyInterestSettingModel+Request.h"
#import "HBTokenTopUpTableViewController.h"

@interface HBHoldingMoneyTransferMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UILabel *monthsLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currency2Label;

// Names
@property (weak, nonatomic) IBOutlet UILabel *monthsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *topUpButton;
@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;

@property (nonatomic, strong) XLBKeyboardMan *keyboardMan;
@property (nonatomic, assign) CGFloat containerY;
@property (nonatomic, copy) NSString *myBalance;

@property (nonatomic, assign) CGFloat bottomConstraintConstant;

@end

@implementation HBHoldingMoneyTransferMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFieldContainerView.layer.borderColor = kColorFromStr(@"#CCCCCC").CGColor;
    self.textFieldContainerView.layer.borderWidth = 1.;
    [self _setupLabelNames];
    [self _updateUI];
    
//    self.keyboardMan = [[XLBKeyboardMan alloc] initWithKeyboardAppearBlock:^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardIncrementHeight) {
//        self.bottomConstraintConstant += keyboardHeight;
////        self.containerView.y -= keyboardHeight;
//    } disappearBlock:^(CGFloat keyboardHeight) {
////        self.containerView.y += keyboardHeight;
//        self.bottomConstraintConstant -= keyboardHeight;
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_hideKeyBoard) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.numberTextField isFirstResponder]) {
        [self.numberTextField resignFirstResponder];
        return;
    }
    
    CGPoint point = [touches.anyObject locationInView:self.view];
    if (!CGRectContainsPoint(self.containerView.frame, point)) {
        [self hide];
    }
}



#pragma mark - Private

- (void)_hideKeyBoard {
    [self.view endEditing:YES];
}

- (void)_setupLabelNames {
    
    self.projectTitleLabel.text = kLocat(@"Money Interest Menu title");
    self.paymentNameLabel.text = kLocat(@"Money Interest Menu Expected annualized income");
    self.monthsNameLabel.text = kLocat(@"Money Interest Menu Management period");
    self.balanceNameLabel.text = kLocat(@"Money Interest Menu Balance");
    self.numberTextField.placeholder = kLocat(@"Money Interest Menu text field placeholder");
    [self.allButton setTitle:kLocat(@"Money Interest Menu All") forState:UIControlStateNormal];
    [self.topUpButton setTitle:kLocat(@"Subscription menu topUp") forState:UIControlStateNormal];
    self.currencyNameLabel.text = kLocat(@"Money Interest Menu Currency");
    [self.subscribeButton setTitle:kLocat(@"Money Interest Menu Transfer button title") forState:UIControlStateNormal];
    [self.cancelButton setTitle:kLocat(@"Subscription menu cancel") forState:UIControlStateNormal];
}



- (void)_updateUI {
    self.monthsLabel.text = self.model.name;
    self.currencyLabel.text = self.model.interestModel.currency_name;
    self.currency2Label.text = self.model.interestModel.currency_name;
    self.balanceLabel.text = self.model.interestModel.numAndCurrency;
    self.rateLabel.text = self.model.rateOfPrecent;
}

#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"HoldingMoney" bundle:nil] instantiateViewControllerWithIdentifier:@"HBHoldingMoneyTransferMenuViewController"];
}

- (void)showInViewController:(UIViewController *)vc {
    self.numberTextField.text = nil;
    [vc addChildViewController:self];
    [self didMoveToParentViewController:vc];
    [vc.view addSubview:self.view];
    self.view.frame = vc.view.bounds;
    
    self.containerView.y = kScreenH;
    self.view.alpha = 0.01;
//    self.bottomConstraintConstant = -377;
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1;
    }];
    [UIView animateWithDuration:0.2 delay:0.1 options:(7 << 16) |UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.y = kScreenH - 357.;
//        self.bottomConstraintConstant = -20;
    } completion:nil];
    
    
}

- (void)hideWithCompletion:(void(^)(void))completion {
    
    _myBalance = 0;
    [UIView animateWithDuration:0.2 delay:0 options:(7 << 16) animations:^{
        self.containerView.y = kScreenH;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        _model = nil;
        [self didMoveToParentViewController:nil];
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
    }];
}

- (void)hide {
    [self hideWithCompletion:nil];
}

#pragma mark - Actions

- (IBAction)sureAction:(UIButton *)sender {
    if (!self.model) {
        return;
    }
    
    NSString *number = self.numberTextField.text;
    
    NSString *errorMessage = [self.model errorMessageWithCheckTransferNumber:number];
    
    if (errorMessage) {
        [self.numberTextField becomeFirstResponder];
        [self showInfoWithMessage:errorMessage];
        return;
    }
    sender.enabled = NO;
    kShowHud;
    __weak typeof(self) weakSelf = self;
    [self.model addMoneyInterestWithNumber:number success:^(YWNetworkResultModel * _Nonnull obj) {
        sender.enabled = YES;
        [weakSelf.view hideHUD];
        if (obj.succeeded) {
            [weakSelf showSuccessWithMessage:obj.message];
            
            [weakSelf hideWithCompletion:^{
                if (weakSelf.operatedDoneBlock) {
                    weakSelf.operatedDoneBlock();
                }
            }];
        } else {
            [weakSelf showInfoWithMessage:obj.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        sender.enabled = YES;
        [weakSelf.view hideHUD];
        [weakSelf showInfoWithMessage:error.localizedDescription];
    }];
    
}

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

- (IBAction)allAction:(id)sender {
    self.numberTextField.text = self.model.interestModel.user_num;
}

- (IBAction)topUpAction:(id)sender {
    [self hideWithCompletion:^{
        HBTokenTopUpTableViewController *vc = [HBTokenTopUpTableViewController fromStoryboard];
        vc.currencyid = self.model.currency_id;
        vc.currencyname = self.model.interestModel.currency_name;
        kNavPush(vc);
    }];
}

#pragma mark - Setters

- (void)setModel:(HBMoneyInterestSettingModel *)model {
    _model = model;
    
    [self _updateUI];
}

- (void)setBottomConstraintConstant:(CGFloat)bottomConstraintConstant {
    _bottomConstraintConstant = bottomConstraintConstant;
    [UIView animateWithDuration:0.1 animations:^{
        self.containerViewBottomConstraint.constant = bottomConstraintConstant;
    }];
    
}

@end
