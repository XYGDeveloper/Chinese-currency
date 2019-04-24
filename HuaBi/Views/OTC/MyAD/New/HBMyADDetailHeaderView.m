//
//  HBMyADDetailHeaderView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/4.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBMyADDetailHeaderView.h"
#import "NSString+toCNY.h"

@interface HBMyADDetailHeaderView ()

//values
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *status2Label;


//names
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldMoneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindMoneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldNumberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindNumberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation HBMyADDetailHeaderView

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.backgroundColor = kThemeColor;
    
    self.numberNameLabel.text = kLocat(@"OTC.myADCell.number");
    self.priceNameLabel.text = kLocat(@"OTC.myADCell.price");
    self.tradeMoneyNameLabel.text = kLocat(@"OTC.myADCell.tradeMoney");
    self.timeNameLabel.text = kLocat(@"OTC.myADCell.time");
    self.orderIDNameLabel.text = kLocat(@"OTC.myADCell.AD_No");
    self.soldMoneyNameLabel.text = kLocat(@"OTC.myADCell.soldMoney");
    self.remindMoneyNameLabel.text = kLocat(@"OTC.myADCell.remindMoney");
    self.soldNumberNameLabel.text = kLocat(@"OTC.myADCell.soldNumber");
    self.remindNumberNameLabel.text = kLocat(@"OTC.myADCell.remindNumber");
    self.limitNameLabel.text = kLocat(@"OTC.myADCell.limit");
    [self.cancelButton setTitle:kLocat(@"OTC.myADCell.cancelAD") forState:UIControlStateNormal];
}

#pragma mark - Public

- (void)configureCellWithModel:(TPOTCMyADModel *)model isHistory:(BOOL)isHistory {
    _model = model;
    
    
    self.currencyNameLabel.text = model.currencyName;
    self.numberLabel.text = model.num;
    self.priceLabel.text = [model.price _addCNY];
    self.tradeMoneyLabel.text = [model.money _addCNY];
    self.timeLabel.text = model.add_time;
    
    BOOL isShowAlipay = [model.money_type containsObject:kZFB];
    BOOL isShowWechatpay = [model.money_type containsObject:kWechat];
    BOOL isShowBank = [model.money_type containsObject:kYHK];
    
    self.alipayImageView.hidden = !isShowAlipay;
    self.wechatImageView.hidden = !isShowWechatpay;
    self.bankImageView.hidden = !isShowBank;
    
    NSString *key = [NSString stringWithFormat:@"OTC.myADCell.%@", model.type];
    self.typeLabel.text = kLocat(key);
    self.typeLabel.textColor = model.typeColor;
    
    self.orderIDLabel.text = model.orders_id;
    
    self.soldMoneyLabel.text = [model.trade_money _addCNY];
    self.soldNumberLabel.text = model.trade_num;
    self.remindMoneyLabel.text = [model.avail_money _addCNY];
    self.remindNumberLabel.text = model.avail;
    
    NSString *limitValue = [NSString stringWithFormat:@"%@-%@", model.min_money, model.max_money];
    self.limitLabel.text = [limitValue _addCNY];
    
    if (isHistory) {
        self.statusLabel.text =  kLocat(@"OTC_order_done");
        self.cancelButton.hidden = YES;
        self.status2Label.hidden = NO;
        self.status2Label.text = model.statusString;
    } else {
        self.cancelButton.hidden = NO;
        self.status2Label.hidden = YES;
        self.statusLabel.text = model.statusString;
    }
    
    self.statusLabel.text = isHistory ? kLocat(@"OTC_order_done") : kLocat(@"OTC_view_dealing");
    self.statusLabel.textColor = model.statusColor;
    
    self.numberNameLabel.text = model.isTypeOfBuy ? kLocat(@"OTC.myADCell.number") : kLocat(@"OTC.myADCell.buy_number");
    
     self.soldNumberNameLabel.text = model.isTypeOfBuy ? kLocat(@"OTC.myADCell.soldNumber") : kLocat(@"OTC.myADCell.boughtNumber");
    self.soldMoneyNameLabel.text = model.isTypeOfBuy ? kLocat(@"OTC.myADCell.soldMoney") : kLocat(@"OTC.myADCell.boughtMoney");
}

#pragma mark - Action

- (IBAction)cancelAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cancelWithMyADDetailHeaderView:)]) {
        [self.delegate cancelWithMyADDetailHeaderView:self];
    }
}


@end
