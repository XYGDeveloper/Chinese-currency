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
#import "YTTradeModel.h"
#import "YTTradeIndexModel.h"
#import "YTSellTrendingContaineeViewController.h"
#import "YTTradeIndexModel.h"
#import "NSString+RemoveZero.h"

@interface YTBuyAndSellDetailTableViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *calculateContainerViews;
@property (weak, nonatomic) IBOutlet UIButton *buyOrSellButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;


@property (weak, nonatomic) IBOutlet UILabel *latestDealLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *limitButton;

@property (weak, nonatomic) IBOutlet UIStackView *loginStackView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@property (nonatomic, assign) BOOL isTypeOfBuy;

@property (nonatomic, strong) YTSellTrendingContaineeViewController *sellTrendingContaineeVC;
@property (nonatomic, strong) YTSellTrendingContaineeViewController *buyTrendingContaineeVC;


@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;

@end

@implementation YTBuyAndSellDetailTableViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupUI];
    self.limitButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    __weak typeof(self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (weakSelf.operateDoneBlock) {
//            weakSelf.operateDoneBlock();
//        }
//    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - Public

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - UITableDelegate

#pragma mark - Private

- (void)_setupUI {
    [self.calculateContainerViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 1.;
        obj.layer.borderColor = kColorFromStr(@"#262A43").CGColor;
    }];
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    
    self.tableView.backgroundColor = kThemeBGColor;
    
//    self.buyOrSellButton.layer.cornerRadius = 8.;
    
    NSString *buttonTitle = self.isTypeOfBuy ? kLocat(@"Buy_immediately") : kLocat(@"Sell_immediately");
    [self.buyOrSellButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    UIColor *themeColor = self.isTypeOfBuy ? kGreenColor : kOrangeColor;
    
    self.buyOrSellButton.backgroundColor = themeColor;
    self.numberTextField.textColor = themeColor;
    self.circleView.backgroundColor = themeColor;
    

    
    self.numberTextField.placeholder = kLocat(@"Number");
    
    self.timeLabel.text = kLocat(@"Time");
    self.typeLabel.text = kLocat(@"Type");
    self.tradePriceLabel.text = kLocat(@"Trade_price");
    self.tradeNumberLabel.text = kLocat(@"Trade_volume");
    self.totalLabel.text = kLocat(@"Total");
    [self.loginButton setTitle:kLocat(@"LLogin") forState:UIControlStateNormal];
    [self.registerButton setTitle:kLocat(@"LRegister") forState:UIControlStateNormal];
}

- (void)_updateUI {

}

#pragma mark - Actions

- (IBAction)tapBuyButtonAction:(UIButton *)sender {
    sender.selected = YES;
    self.sellButton.selected = NO;
  
}

- (IBAction)tapSellButtonAction:(UIButton *)sender {
    sender.selected = YES;
    self.buyButton.selected = NO;
}

- (IBAction)loginAction:(id)sender {
    [self _gotoLoginVC];
}
- (IBAction)registerAction:(id)sender {
    [self _gotoRegisterVC];
}


- (IBAction)plusPriceAction:(id)sender {
//    [self _add:1 textField:self.priceTextField];
}

- (IBAction)minusPriceAction:(id)sender {
//    [self _add:-1 textField:self.priceTextField];
}

- (IBAction)plusNumberAction:(id)sender {
//    [self _add:1 textField:self.numberTextField];
}

- (IBAction)minusNumberAction:(id)sender {
//    [self _add:-1 textField:self.numberTextField];
}

- (void)_add:(NSInteger)number textField:(UITextField *)textField {
    double value = [textField.text doubleValue];
    value += number;
    if (value < 0) {
        return;
    }
    
    textField.text = [NSString stringWithFormat:@"%@", @(value)];
}

- (void)_gotoLoginVC {
    ICNLoginViewController*vc = [[ICNLoginViewController alloc]init];
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

-(void)_gotoRegisterVC
{
    ICNRegisterViewController *vc = [[ICNRegisterViewController alloc]init];
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

- (IBAction)opreateAction:(id)sender {
    
    
    
}


#pragma mark - Setters & Getters

- (YTSellTrendingContaineeViewController *)sellTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[0];
    vc.isTypeOfBuy = NO;
    if (self.isTypeOfBuy) {
        __weak typeof(self) weakSelf = self;
        vc.didSelectCellBlock = ^(NSString *price) {
        };
    }
    return vc;
}

- (YTSellTrendingContaineeViewController *)buyTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[1];
    vc.isTypeOfBuy = YES;
    if (!self.isTypeOfBuy) {
        __weak typeof(self) weakSelf = self;
        vc.didSelectCellBlock = ^(NSString *price) {
        };
    }
    return vc;
}


- (void)setModel:(ListModel *)model {
    _model = model;
    
    self.tradeModel = nil;
}

- (void)setTradeModel:(YTTradeModel *)tradeModel {
    _tradeModel = tradeModel;
    
    [self _updateUI];
}



- (void)setTradeIndexs:(YTTradeIndexModel *)tradeIndexs {
    _tradeIndexs = tradeIndexs;
    
    self.sellTrendingContaineeVC.models = _tradeIndexs.sell_list;
    self.buyTrendingContaineeVC.models = _tradeIndexs.buy_list;
    
}

@end
