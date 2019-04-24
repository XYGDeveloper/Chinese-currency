//
//  YTBuyAndSellDetailTableViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTBuyAndSellDetailTableViewController.h"
#import "YTTradeRequest.h"
#import "YTData_listModel.h"
#import "YTTradeIndexModel.h"
#import "YTSellTrendingContaineeViewController.h"
#import "NSString+RemoveZero.h"
#import "HBCurrentEntrustContaineeTableViewController.h"
#import "HBCurrentEntrustViewController.h"
#import "YTTradeUserOrderModel+Request.h"
#import "ZJPayPopupView.h"
#import "NSString+Operation.h"
#import "StepSlider.h"
#import "YTMyassetDetailModel.h"
#import "NSObject+SVProgressHUD.h"
#import "UITextField+HB.h"
#import "HBTradeLimitTimeModel.h"

@interface YTBuyAndSellDetailTableViewController () <ZJPayPopupViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *calculateContainerViews;
@property (weak, nonatomic) IBOutlet UIButton *buyOrSellButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UIView *circleView;


@property (weak, nonatomic) IBOutlet UIButton *limitButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *zeroCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fristCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (nonatomic, assign) BOOL isChangeOfNumberByStepSlider;




@property (nonatomic, strong) YTSellTrendingContaineeViewController *sellTrendingContaineeVC;
@property (nonatomic, strong) YTSellTrendingContaineeViewController *buyTrendingContaineeVC;
@property (nonatomic, strong) HBCurrentEntrustContaineeTableViewController *entrustContaineeVC;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

/**
 买入 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

/**
 卖出 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sellButton;

/**
 ≈ 多少 CNY
 */
@property (weak, nonatomic) IBOutlet UILabel *myCurrentPriceLabel;

/**
 可用
 */
@property (weak, nonatomic) IBOutlet UITextField *availableLabel;


/**
 当前币种 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

/**
 当前币种价格换算成 CNY 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *currentUsdPriceLabel;


/**
 数量滑动条
 */
@property (weak, nonatomic) IBOutlet StepSlider *stepSlider;

@property (nonatomic, strong) NSArray<YTTradeUserOrderModel *> *orders;

/**
 交易额值
 */
@property (weak, nonatomic) IBOutlet UILabel *tradeNumLabel;

/**
 ”交易额“ label
 */
@property (weak, nonatomic) IBOutlet UILabel *tradeNumNameLabel;

@property (nonatomic, strong) ZJPayPopupView *payPopupView;


/**
 "当前委托" label
 */
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

/**
 全部 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *allButton;

/**
 盘口
 */
@property (weak, nonatomic) IBOutlet UILabel *pkLabel;

/**
 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**
 数量
 */
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


/**
 数量 币种名称
 */
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *myPriceContainerViews;

@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *stopPriceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitPriceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeLabel;
@property (weak, nonatomic) IBOutlet UIStackView *limitStackView;
@property (weak, nonatomic) IBOutlet UIStackView *timeStackView;

@property (nonatomic, copy) NSString *maxNumber;

@property (nonatomic, strong) NSArray<NSString *> *typesOfPrice;
@property (nonatomic, copy) NSString *selectedTypeOfPrice;

@end

@implementation YTBuyAndSellDetailTableViewController




#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isTypeOfBuy = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupUI];
    
    [self _addObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _updateUI];
    [self _updateMyCurrentPriceLabel];
}

- (void)dealloc {
    [self _removeObservers];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCurrentEntrustVC"]) {
        HBCurrentEntrustViewController *vc = segue.destinationViewController;
        vc.model = self.model;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showCurrentEntrustVC"]) {
        if ([Utilities isExpired]) {
            [self gotoLoginVC];
            return NO;
        }
    }
    return YES;
}


#pragma mark - Public

+ (instancetype)buyDetailTableViewController {
    YTBuyAndSellDetailTableViewController *vc = [self fromStoryboard];
    vc.isTypeOfBuy = YES;
    return vc;
}

+ (instancetype)sellDetailTableViewController {
    YTBuyAndSellDetailTableViewController *vc = [self fromStoryboard];
    vc.isTypeOfBuy = NO;
    return vc;
}

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTBuyAndSellDetailTableViewController"];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - UITableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        if ((!self.limitTimeModel || (!self.limitTimeModel.is_time && !self.limitTimeModel.is_limit))) {
            return 0;
        }
        
        if (!self.limitTimeModel.is_time || !self.limitTimeModel.is_limit) {
            return 36.;
        }
        
    } else if (indexPath.row == 3) {
        return [self.entrustContaineeVC getHeight];
    } 
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - ZJPayPopupViewDelegate

- (void)didPasswordInputFinished:(NSString *)password {
    [self.payPopupView hidePayPopView];
    if (password.length == 0) {
        NSString *msg = kLocat(@"k_YTBuyAndSellDetailTableViewController_TransactionCannotBeEmpty");
        [self.view showWarning:msg];
        return;
    }
    kShowHud;
    NSString *price = self.priceTextField.text;
    NSString *number = self.numberTextField.text;
    [YTTradeRequest operateTradeWithCurrencyID:self.model.currency_id isTypeOfBuy:self.isTypeOfBuy price:price number:number password:password success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        [self.view showWarning:obj.message];
        if ([obj succeeded]) {
            if (self.operateDoneBlock) {
                self.operateDoneBlock();
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self.view showWarning:error.localizedDescription];
    }];
}

#pragma mark - Private

- (void)_removeObservers {
    [self.priceTextField removeObserver:self forKeyPath:@"text"];
    [self.numberTextField removeObserver:self forKeyPath:@"text"];
    [self.availableLabel removeObserver:self forKeyPath:@"text"];
}

- (void)_addObservers {
    [self.priceTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.numberTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.availableLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
   
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textFieldDidChangeWithNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)_setupUI {
    
    //国际化
    self.typesOfPrice = @[kLocat(@"limit_price"), kLocat(@"market_price"), ];
    [self.buyButton setTitle:kLocat(@"buy_2") forState:UIControlStateNormal];
    [self.sellButton setTitle:kLocat(@"sell_2") forState:UIControlStateNormal];
    [self.limitButton setTitle:kLocat(@"limit_price") forState:UIControlStateNormal];
    self.currentLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_header_label");
    [self.allButton setTitle:kLocat(@"k_MyassetDetailViewController_tableview_all") forState:UIControlStateNormal];
    self.pkLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_pankou");
    self.priceLabel.text = kLocat(@"Price");
    self.numberLabel.text = kLocat(@"Number");
    self.tradeNumNameLabel.text = kLocat(@"k_MyassetViewController_tableview_list_cell_right_jye");
    
    self.limitTimeNameLabel.text = kLocat(@"k_TradeViewController_Deal time");
    self.stopPriceNameLabel.text = kLocat(@"k_TradeViewController_Stop price");
    self.limitPriceNameLabel.text = kLocat(@"k_TradeViewController_Limit price");
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_setTextOfPriceTextFieldToTextOfCurrentPriceLabel)];
    [self.currentPriceLabel addGestureRecognizer:tapGR];
    
    [self.stepSlider addTarget:self action:@selector(_stepSliderProgressChangedAction:) forControlEvents:UIControlEventValueChanged];
    
    self.limitButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.operateDoneBlock) {
            weakSelf.operateDoneBlock();
        }
    }];
    
    //设置颜色
    [self.calculateContainerViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 1.;
        obj.layer.borderColor = kColorFromStr(@"#262A43").CGColor;
    }];
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    
    self.tableView.backgroundColor = kThemeColor;
    self.zeroCell.backgroundColor = kThemeBGColor;
    self.fristCell.backgroundColor = kThemeBGColor;
    self.secondCell.backgroundColor = kThemeBGColor;
    self.numberTextField.placeholder = kLocat(@"Number");
    
    self.numberTextField.delegate = self;
    self.priceTextField.delegate = self;
    

}

- (void)_updateUI {
    
   
    
    self.sellButton.selected = !self.isTypeOfBuy;
    self.buyButton.selected = self.isTypeOfBuy;
    self.availableLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_avali"), self.availableNumber ?: @"0", self.currencyMark ?: @""];
    
    self.currentPriceLabel.text = self.model.price;
    self.currentPriceLabel.textColor = [self.model statusColor];
//    self.priceTextField.text = self.model.price;
    NSString *currencyPrice = [self.model.price_current_currency _addSuffixCurrentCurrency];

    self.currentUsdPriceLabel.text = [currencyPrice _addPrefix:@"≈"];
    self.currencyNameLabel.text = self.model.currency_mark ?: @"";
    
    UIColor *currentColor = self.isTypeOfBuy ? kGreenColor : kOrangeColor;
    
    NSString *buttonTitle = self.isTypeOfBuy ? kLocat(@"buy_2") : kLocat(@"sell_2");
    
    buttonTitle = [NSString stringWithFormat:@"%@ %@", buttonTitle, self.model.currency_mark ?: @""];
    if ([Utilities isExpired]) {
        buttonTitle = kLocat(@"HBLoginTableViewController_password_login");
    }
    self.buyOrSellButton.backgroundColor = currentColor;
    [self.buyOrSellButton setTitle:buttonTitle forState:UIControlStateNormal];
    self.stepSlider.sliderCircleColor = currentColor;
    self.stepSlider.tintColor = currentColor;
    self.numberTextField.textColor = currentColor;

    self.entrustContaineeVC.isTypeOfBuy = self.isTypeOfBuy;
  
}

- (void)_switchTypeOfPrice {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.typesOfPrice enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *aciton = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedTypeOfPrice = obj;
        }];
        [alertController addAction:aciton];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_updateLimitTimeUI {
    self.limitStackView.hidden = !self.limitTimeModel.is_limit;
    self.timeStackView.hidden = !self.limitTimeModel.is_time;
    self.limitPriceLabel.text = self.limitTimeModel.max_limit;
    self.stopPriceLabel.text = self.limitTimeModel.min_limit;
    self.limitTimeLabel.text = [NSString stringWithFormat:@"%@-%@", self.limitTimeModel.min_time ?: @"-", self.limitTimeModel.max_time ?: @""];
}

#pragma mark - Actions

- (void)_stepSliderProgressChangedAction:(StepSlider *)stepSlider {
    CGFloat progress = stepSlider.progress;
    NSString *number = [self.maxNumber resultByMultiplyingByNumber:[NSString stringWithFormat:@"%@", @(progress)]];
    self.isChangeOfNumberByStepSlider = YES;
    if ([number doubleValue] > [self.maxNumber doubleValue]) {
        return;
    }
    self.numberTextField.text = number;
}

- (void)_setTextOfPriceTextFieldToTextOfCurrentPriceLabel {
    [self.priceTextField _animateWithText:self.model.price];
}

- (void)tapButtonWithIsBuy:(BOOL)isbuy {
    if (isbuy) {
        [self tapBuyButtonAction:self.buyButton];
    } else {
        [self tapSellButtonAction:self.sellButton];
    }
}

- (IBAction)tapBuyButtonAction:(UIButton *)sender {
    self.isTypeOfBuy = YES;
}

- (IBAction)tapSellButtonAction:(UIButton *)sender {
    self.isTypeOfBuy = NO;
}

- (IBAction)loginAction:(id)sender {
    [self gotoLoginVC];
}

- (IBAction)plusPriceAction:(id)sender {
    NSString *factor = [self.model.price getAddFactor];
    [self _add:factor textField:self.priceTextField];
}

- (IBAction)minusPriceAction:(id)sender {
    NSString *factor = [self.model.price getMinusFactor];
    [self _add:factor textField:self.priceTextField];
}

- (void)_add:(NSString *)number textField:(UITextField *)textField {
    NSDecimalNumber *textNumber = [NSDecimalNumber decimalNumberWithString:textField.text];
    NSDecimalNumber *add = [NSDecimalNumber decimalNumberWithString:number];
    textNumber = [textNumber decimalNumberByAdding:add];
    if (textNumber.doubleValue < 0) {
        return;
    }
    NSMutableString *result = [NSString stringWithFormat:@"%@", textNumber].mutableCopy;
    NSInteger realCount = [result getCountOfDecimal];

    NSInteger neededCount = [self.model.price getCountOfDecimal];
    if (realCount == 0 && neededCount!= 0) {
        [result appendString:@"."];
    }
    for (int i= 0; i < neededCount - realCount; i++) {
        [result appendString:@"0"];
    }
    
    textField.text = result.copy;
}


- (IBAction)opreateAction:(id)sender {
  
    
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return;
    }
    
    NSString *price = self.priceTextField.text;
    NSString *number = self.numberTextField.text;
    
    if (price.length == 0) {
        NSString *msg = self.isTypeOfBuy ? kLocat(@"k_YTBuyAndSellDetailTableViewController_buyPriceCannotBeEmpty") : kLocat(@"k_YTBuyAndSellDetailTableViewController_sellPriceCannotBeEmpty");
        [self showInfoWithMessage:msg];
        return;
    }
    
    if (number.length == 0) {
        NSString *msg = self.isTypeOfBuy ? kLocat(@"k_YTBuyAndSellDetailTableViewController_TheNumberOfBuyingCannotBeEmpty") : kLocat(@"k_YTBuyAndSellDetailTableViewController_TheNumberOfSellingCannotBeEmpty");
        [self showInfoWithMessage:msg];
        return;
    }
    

    
    kShowHud;
    [YTTradeRequest operateTradeWithCurrencyID:self.model.currency_id ?: @"" isTypeOfBuy:self.isTypeOfBuy price:price number:number password:@"" success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        
        if ([obj succeeded]) {
            [self showSuccessWithMessage:obj.message];
            if (self.operateDoneBlock) {
                self.numberTextField.text = nil;
                self.operateDoneBlock();
            }
        } else {
            [self showInfoWithMessage:obj.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

- (IBAction)tapTypeOfPriceAction:(id)sender {
    
//    [self _switchTypeOfPrice];
}

#pragma mark - Setters & Getters

- (NSString *)currencyMark {
    return self.isTypeOfBuy ? self.model.trade_currency_mark : self.model.currency_mark;
}

- (NSString *)availableNumber {
    return self.isTypeOfBuy ? self.tradeAssetModel.currency_user.num : self.assetModel.currency_user.num;
}

- (YTSellTrendingContaineeViewController *)sellTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[0];
    vc.isTypeOfBuy = NO;
    __weak typeof(self) weakSelf = self;
    vc.didSelectCellBlock = ^(NSString *price) {
        [weakSelf.priceTextField _animateWithText:price];
    };
    return vc;
}

- (YTSellTrendingContaineeViewController *)buyTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[1];
    vc.isTypeOfBuy = YES;
    __weak typeof(self) weakSelf = self;
    vc.didSelectCellBlock = ^(NSString *price) {
        [weakSelf.priceTextField _animateWithText:price];
    };
    return vc;
}


- (HBCurrentEntrustContaineeTableViewController *)entrustContaineeVC {
    if (self.childViewControllers.count < 3) {
        return nil;
    }
    if (!_entrustContaineeVC) {
        _entrustContaineeVC = self.childViewControllers[2];
        _entrustContaineeVC.isTypeOfBuy = self.isTypeOfBuy;
        __weak typeof(self) weakSelf = self;
        _entrustContaineeVC.heightChangedBlock = ^{
            [weakSelf.tableView reloadData];
        };
    }
    
    return _entrustContaineeVC;
}


- (void)setModel:(ListModel *)model {
    if (_model != model) {
        self.priceTextField.text = nil;
    }
    _model = model;
    [self _updateUI];
    self.entrustContaineeVC.model = model;
}

- (void)setAssetModel:(YTMyassetDetailModel *)assetModel {
    _assetModel = assetModel;
    
    [self _updateUI];
}

- (void)setTradeAssetModel:(YTMyassetDetailModel *)tradeAssetModel {
    _tradeAssetModel = tradeAssetModel;
    
    [self _updateUI];
}

- (void)setLimitTimeModel:(HBTradeLimitTimeModel *)limitTimeModel {
    _limitTimeModel = limitTimeModel;
    
    [self _updateLimitTimeUI];
    [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

- (void)setTradeIndexs:(YTTradeIndexModel *)tradeIndexs {
    _tradeIndexs = tradeIndexs;
    self.sellTrendingContaineeVC.models = _tradeIndexs.sell_list;
    self.buyTrendingContaineeVC.models = _tradeIndexs.buy_list;
    self.limitTimeModel = tradeIndexs.currency_limit;
    [self _updateUI];
    [self _updateMyCurrentPriceLabel];
    if (self.priceTextField.text.length == 0) {
        if (self.priceTextField.isFirstResponder) {
            return;
        }
        [self _updatePriceTextField];
    }
}

- (void)_updatePriceTextField {

    NSString *price = !self.isTypeOfBuy ? _tradeIndexs.buy_list.firstObject.price : _tradeIndexs.sell_list.lastObject.price;
    self.priceTextField.text = price;
}

- (void)setIsTypeOfBuy:(BOOL)isTypeOfBuy {
    _isTypeOfBuy = isTypeOfBuy;
    self.numberTextField.text = nil;
    self.tradeNumLabel.text = @"--";
    [self _updateUI];
    [self _updatePriceTextField];
}

- (void)setSelectedTypeOfPrice:(NSString *)selectedTypeOfPrice {
    _selectedTypeOfPrice = selectedTypeOfPrice;
    
    [self.limitButton setTitle:selectedTypeOfPrice forState:UIControlStateNormal];
    BOOL needHide = [selectedTypeOfPrice isEqualToString:self.typesOfPrice.lastObject];
    [self.myPriceContainerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = needHide;
    }];
}

- (void)setMaxNumber:(NSString *)maxNumber {
    _maxNumber = maxNumber;
    [self _updateMaxNumberLabel];
}

- (void)_updateMaxNumberLabel {
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@ %@", self.maxNumber ?: @"0", self.model.currency_mark ?: @""];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return NO;
    } else {
        return YES;
    }
}

- (void)_textFieldDidChangeWithNotification:(NSNotification *)notification {
    [self _textFieldDidChange:notification.object];
}

- (void)_textFieldDidChange:(UITextField *)textField {
    if ([textField isEqual:self.priceTextField]) {
        [self _updateMyCurrentPriceLabel];
        [self _calculateMaxNumberOfMyBalance];
    }
    
    if ([textField isEqual:self.priceTextField] || [textField isEqual:self.numberTextField]) {
        [self _calculateTotalPriceOfTrade];
    }
    
    if ([textField isEqual:self.numberTextField]) {
        if (self.isChangeOfNumberByStepSlider) {
            self.isChangeOfNumberByStepSlider = NO;
            return;
        }
        [self _calculateProgressOfStepSlider];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.numberTextField]) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = 6;//小数点后需要限制的个数
        for (int i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
    }
    
    return YES;
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[UITextField class]]) {
        [self _textFieldDidChange:object];
    }
    
    if ([object isEqual:self.availableLabel]) {
        [self _calculateMaxNumberOfMyBalance];
    }
}

#pragma mark - Calculate


/**
 计算 滑动条进度值
 */
- (void)_calculateProgressOfStepSlider {
    NSString *number = self.numberTextField.text;
    if (number.length == 0) {
        return;
    }
    
    if ([number doubleValue] > [self.maxNumber doubleValue]) {
        [self showInfoWithMessage:kLocat(@"Insufficient balance")];
        return;
    }
    
    CGFloat progress = [[number resultByDividingByNumber:self.maxNumber] floatValue];
    [self.stepSlider setProgress:progress animated:YES];
}


/**
 计算 最大可买数量
 */
- (void)_calculateMaxNumberOfMyBalance {
    NSString *price = self.priceTextField.text;
    
    if (price.length > 0) {
        NSString *factorString = [self.model getFeeFactorStringByIsBuy:self.isTypeOfBuy];
        NSString *maxNumber = nil;
        if (self.isTypeOfBuy) {
            NSString *priceOfHasFee = [price resultByMultiplyingByNumber:factorString];
            maxNumber = [self.availableNumber resultByDividingByNumber:priceOfHasFee] ?: @"0";
        } else {
            maxNumber = [self.availableNumber resultByMultiplyingByNumber:factorString];
        }
        maxNumber = [maxNumber rouningDownByScale:6];//截取小数点后6位，使用 rouning Down 方式如：0.0001116 -> 0.000111
        self.maxNumber = maxNumber;
    }
}


/**
 计算 交易额
 */
- (void)_calculateTotalPriceOfTrade {
    NSString *price = self.priceTextField.text;
    NSString *number = self.numberTextField.text;
    
    if (price.length > 0 && number.length > 0) {
        NSString *factorString = [self.model getFeeFactorStringByIsBuy:self.isTypeOfBuy];
        NSString *tradeNum = [[price resultByMultiplyingByNumber:number] resultByMultiplyingByNumber:factorString];
        self.tradeNumLabel.text = [NSString stringWithFormat:@"%@ %@", tradeNum, self.model.trade_currency_mark];
    }
}


/**
 计算 当前选择的币种价格 ≈ 多少 CNY
 */
- (void)_updateMyCurrentPriceLabel {
    NSString *text = self.priceTextField.text;
    text = [text resultByDividingByNumber:self.model.price];
    NSString *price = [text resultByMultiplyingByNumber:self.model.price_current_currency];
    
    self.myCurrentPriceLabel.text =[[price _addSuffixCurrentCurrency] _addPrefix:@"≈"] ;
}


@end
