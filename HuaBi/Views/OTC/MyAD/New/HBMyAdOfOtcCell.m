//
//  HBMyAdOfOtcCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/3.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBMyAdOfOtcCell.h"
#import "UITableViewCell+HB.h"
#import "TPOTCMyADModel.h"

@interface HBMyAdOfOtcCell ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@property (weak, nonatomic) IBOutlet UIButton *showDetailButton;

//values
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//names
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;
@end

@implementation HBMyAdOfOtcCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self _addSelectedBackgroundView];
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    
    self.showDetailButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
    self.numberNameLabel.text = kLocat(@"OTC.myADCell.number");
    self.priceNameLabel.text = kLocat(@"OTC.myADCell.price");
    self.tradeMoneyNameLabel.text = kLocat(@"OTC.myADCell.tradeMoney");
    self.timeNameLabel.text = kLocat(@"OTC.myADCell.time");
    self.orderIDNameLabel.text = kLocat(@"OTC.myADCell.AD_No");
    [self.showDetailButton setTitle:kLocat(@"OTC.myADCell.showDetail") forState:UIControlStateNormal];
}

#pragma mark - Public

- (void)configureCellWithModel:(TPOTCMyADModel *)model isHistory:(BOOL)isHistory {
    self.model = model;
    
//    if (isHistory) {
//        self.statusLabel.text = model.statusString;
//         self.statusLabel.textColor = model.statusColor;
//    } else {
//        self.statusLabel.text = kLocat(@"OTC_view_dealing");
//        self.statusLabel.textColor = kColorFromStr(@"#4173C8");
//    }
}

#pragma mark - Setter

- (void)setModel:(TPOTCMyADModel *)model {
    _model = model;
    
    self.currencyNameLabel.text = model.currencyName;
    self.numberLabel.text = model.num;
    self.priceLabel.text = model.price;
    self.tradeMoneyLabel.text = model.money;
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
    self.statusLabel.text = model.statusString;
    self.statusLabel.textColor = model.statusColor;
    
    self.numberNameLabel.text = !model.isTypeOfBuy ? kLocat(@"OTC.myADCell.buy_number") : kLocat(@"OTC.myADCell.number");
}
@end
