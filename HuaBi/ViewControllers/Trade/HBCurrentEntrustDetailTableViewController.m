//
//  HBCurrentEntrustTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCurrentEntrustDetailTableViewController.h"
#import "YTTradeUserOrderModel.h"

@interface HBCurrentEntrustDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;

//Values
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fee2Label;

//Label Names
@property (weak, nonatomic) IBOutlet UILabel *sumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumber2NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeName2Label;
@property (weak, nonatomic) IBOutlet UILabel *consumeName2Label;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceNameLabel;



//Marks
@property (weak, nonatomic) IBOutlet UILabel *sumMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeMarkLabel;

//Other
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@end

@implementation HBCurrentEntrustDetailTableViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"HBCurrentEntrustDetailTableViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kThemeBGColor;
    self.title = kLocat(@"Trade_Details");
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    
    //set Values
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.price ?: @"", self.model.trade_currency_mark ?: @""];
    self.numberLabel.text = self.model.num;
    self.tradeNumberLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.trade_num ?: @"", self.model.currenc_mark ?: @""];
    self.sumLabel.text = self.model.totalMeney;
    self.averagePriceLabel.text = self.model.avgcPrice;
    NSString *key = [NSString stringWithFormat:@"%@_2", self.model.type];
    self.typeLabel.text = kLocat(key);
    self.typeLabel.textColor = [self.model typeColor];
    self.timeLabel.text = [Utilities returnTimeWithSecond:[self.model.add_time integerValue] formatter:@"HH:mm MM/dd"];
    self.currencyNameLabel.text = self.model.comMarkName;
    self.feeLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.totalfee ?: @" ", self.model.trade_currency_mark ?: @""];
    self.fee2Label.text = self.model.totalfee ?: @" ";
    
    //set Marks
    NSString *tradeCurrencyMarkString = [NSString stringWithFormat:@"(%@)", self.model.trade_currency_mark];
    self.feeMarkLabel.text = tradeCurrencyMarkString;
    self.sumMarkLabel.text = tradeCurrencyMarkString;
    self.averagePriceMarkLabel.text = tradeCurrencyMarkString;
    self.tradeNumberMarkLabel.text = [NSString stringWithFormat:@"(%@)", self.model.currenc_mark];
    
    //set Label Names
    self.timeNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_time");
    self.sumNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_wtze");
    self.averagePriceNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_cjjj");
    self.tradeNumberNameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_cjl");
    self.tradeNumber2NameLabel.text = kLocat(@"k_MyassetDetailViewController_wt_cjl");
    self.feeNameLabel.text = kLocat(@"OTC_fee");
    self.feeName2Label.text = kLocat(@"OTC_fee");
    self.tradePriceNameLabel.text = kLocat(@"Trade_price2");
//    self.consumeNameLabel.text = kLocat(@"ConsumptionOfCard");
//    self.consumeName2Label.text = kLocat(@"ConsumptionOfCard");
}


@end
