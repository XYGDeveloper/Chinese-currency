//
//  HBSubscribeMenuViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeMenuViewController.h"
#import "HBSubscribeModel+Request.h"
#import "NSObject+SVProgressHUD.h"
#import "XLBKeyboardMan.h"
#import "NSString+Operation.h"
#import "HBTokenTopUpTableViewController.h"

@interface HBSubscribeMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

// Names
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@property (weak, nonatomic) IBOutlet UIButton *topUpButton;
@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) XLBKeyboardMan *keyboardMan;
@property (nonatomic, assign) CGFloat containerY;
@property (nonatomic, copy) NSString *myBalance;

@end

@implementation HBSubscribeMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textFieldContainerView.layer.borderColor = kColorFromStr(@"#CCCCCC").CGColor;
    self.textFieldContainerView.layer.borderWidth = 1.;
    [self _setupLabelNames];
    [self _updateUI];
    
//    self.keyboardMan = [[XLBKeyboardMan alloc] initWithKeyboardAppearBlock:^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardIncrementHeight) {
//        self.containerView.y -= keyboardHeight;
//    } disappearBlock:^(CGFloat keyboardHeight) {
//        self.containerView.y += keyboardHeight;
//    }];
    
    [self.numberTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_hideKeyBoard) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
    [self.numberTextField removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.numberTextField]) {
        [self _calculateRealNumber];
    }
}

#pragma mark - Private

- (void)_hideKeyBoard {
    [self.view endEditing:YES];
}

- (void)_setupLabelNames {
    self.priceNameLabel.text = kLocat(@"Subscription menu price_");
    self.balanceNameLabel.text = kLocat(@"Subscription menu balance");
    self.paymentNameLabel.text = kLocat(@"Subscription menu payment");
    self.tipsLabel.text = kLocat(@"Subscription menu tips");
    self.numberTextField.placeholder = kLocat(@"Subscription menu text field placeholder");
    [self.allButton setTitle:kLocat(@"Subscription menu all") forState:UIControlStateNormal];
    [self.topUpButton setTitle:kLocat(@"Subscription menu topUp") forState:UIControlStateNormal];
    self.tipsLabel.text = kLocat(@"Subscription menu tips");
    
    [self.subscribeButton setTitle:kLocat(@"Subscription menu subscribe") forState:UIControlStateNormal];
    [self.cancelButton setTitle:kLocat(@"Subscription menu cancel") forState:UIControlStateNormal];
}

- (void)_calculateRealNumber {
    NSString *number = self.numberTextField.text;
    if ([number isEqualToString:@""] || !self.model.price) {
        self.realPriceLabel.text = @"--";
    } else {
        NSString *realPrice = [self.model.price resultByMultiplyingByNumber:number];
        self.realPriceLabel.text = [NSString stringWithFormat:@"%@ %@", realPrice ?: @"--", self.model.buy_name];
    }
}

- (void)_updateUI {
    self.priceLabel.text = self.model.priceAndCurrency;
    self.currencyLabel.text = self.model.name;
    self.projectTitleLabel.text = self.model.title;
}

- (void)_requestBalanceNum {
    self.balanceLabel.hidden = YES;
    [self.activityIndicatorView startAnimating];
    [self.model requestSubscribeBalanceWithSuccess:^(NSString *num, YWNetworkResultModel * _Nonnull obj) {
        self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", num ?: @"--", self.model.buy_name];
        self.balanceLabel.hidden = NO;
        self.myBalance = num;
        [self.activityIndicatorView stopAnimating];
    } failure:^(NSError * _Nonnull error) {
        self.balanceLabel.hidden = NO;
        [self.activityIndicatorView stopAnimating];
    }];
}

#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Subscribe" bundle:nil] instantiateViewControllerWithIdentifier:@"HBSubscribeMenuViewController"];
}

- (void)showInViewController:(UIViewController *)vc {
    self.numberTextField.text = nil;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [vc addChildViewController:self];
    [self didMoveToParentViewController:vc];
    [vc.view addSubview:self.view];
    self.view.frame = vc.view.bounds;
    CGFloat constant = 20.;
    if (@available(iOS 11.0, *)) {
        constant += window.safeAreaInsets.bottom;
    } 
    
    
    self.containerView.y = kScreenH;
    self.view.alpha = 0.01;
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1;
    }];
    [UIView animateWithDuration:0.2 delay:0.1 options:(7 << 16) |UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.y = kScreenH - 357.;
    } completion:nil];
    
    
    [self _requestBalanceNum];
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
    
    NSString *number = self.numberTextField.text;
    
    if ([number integerValue] < [self.model.min_limit integerValue]) {
        [self.numberTextField becomeFirstResponder];
        NSString *msg = [NSString stringWithFormat:@"%@ %@", kLocat(@"Subscription menu number must not be less than"), self.model.min_limit];
        [self showInfoWithMessage:msg];
        return;
    }
    sender.enabled = NO;
    kShowHud;
    [HBSubscribeModel subscribeWithID:self.model.ID num:number success:^(YWNetworkResultModel * _Nonnull obj) {
        sender.enabled = YES;
        kHideHud;
        [self showSuccessWithMessage:obj.message];
        if (self.operatedDoneBlock) {
            self.operatedDoneBlock();
        }
        [self hide];
    } failure:^(NSError * _Nonnull error) {
        sender.enabled = YES;
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
    
}

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

- (IBAction)allAction:(id)sender {
    double balance = [self.myBalance doubleValue];
    double price = [self.model.price doubleValue];
    if (price != 0) {
        NSInteger canBuyNumber = balance / price;
        self.numberTextField.text = [NSString stringWithFormat:@"%@", @(canBuyNumber)];
    }
}

- (IBAction)topUpAction:(id)sender {
    [self hideWithCompletion:^{

        
        HBTokenTopUpTableViewController *vc = [HBTokenTopUpTableViewController fromStoryboard];
        vc.currencyid = self.model.buy_currency_id;
        vc.currencyname = self.model.buy_name;
        kNavPush(vc);
    }];
}

#pragma mark - Setters

- (void)setModel:(HBSubscribeModel *)model {
    _model = model;
    
    [self _updateUI];
}

@end
