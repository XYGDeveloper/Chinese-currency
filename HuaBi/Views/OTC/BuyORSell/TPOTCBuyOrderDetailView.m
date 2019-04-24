//
//  TPOTCBuyOrderDetailView.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyOrderDetailView.h"
#import "NSString+Operation.h"
#import "XLBKeyboardMan.h"
#import "HMSegmentedControl+HB.h"

@interface TPOTCBuyOrderDetailView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceOfCurrencyLabel;

@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;

@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeTotalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;

@property (nonatomic, strong) XLBKeyboardMan *keyboardMan;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

static CGFloat const kViewHeight = 370.;

@implementation TPOTCBuyOrderDetailView

#pragma mark - Lifecycle

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    // 创建BezierPath 并设置角 和 半径 这里只设置了 右上 和 右下
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    self.maskLayer = layer;
    self.containerView.layer.mask = layer;
    
    
    _nameLabel.textColor = kColorFromStr(@"#CDD2E3");
    _nameLabel.font = PFRegularFont(18);
    
    
    _priceOfCurrencyLabel.font = PFRegularFont(12);
    
    _limitLabel.textColor = kColorFromStr(@"#979CAD");
    _limitLabel.font = PFRegularFont(12);
    
    
    _moneyOrNumberTextField.textColor = _nameLabel.textColor;
    _moneyOrNumberTextField.font = PFRegularFont(14);
    
    _markLabel.textColor = kColorFromStr(@"#9BBBEB");
    _markLabel.font = PFRegularFont(14);
    
    [_buyAllButton setTitleColor:kColorFromStr(@"#11B1ED") forState:UIControlStateNormal];
    _buyAllButton.titleLabel.font = PFRegularFont(14);
    
    
    [_timeButton setTitleColor:kColorFromStr(@"#9BBBEB") forState:UIControlStateNormal];
    _timeButton.titleLabel.font = PFRegularFont(14);
    _timeButton.backgroundColor = kColorFromStr(@"#434A5D");
    
    [_dealButton setTitleColor:kColorFromStr(@"#8D92A0") forState:UIControlStateNormal];
    _dealButton.titleLabel.font = PFRegularFont(14);
    
    _markLabel.textColor = kColorFromStr(@"#979CAD");
    _markLabel.font = PFRegularFont(14);
    
    self.containerView.backgroundColor = kThemeColor;
    kTextFieldPlaceHoldColor(self.moneyOrNumberTextField, [UIColor redColor]);
    
    _moneyOrNumberTextField.delegate = self;
    
    
    [_buyAllButton addTarget:self action:@selector(allButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_timeButton addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buyAllButton setTitle:kLocat(@"OTC_view_buyall") forState:UIControlStateNormal];
    [_dealButton setTitle:kLocat(@"OTC_view_placeorder") forState:UIControlStateNormal];
    self.priceNameLabel.text = kLocat(@"OTC.myADCell.price");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    self.textFieldContainerView.layer.borderWidth = 1.;
    self.textFieldContainerView.layer.borderColor = kColorFromStr(@"#37415C").CGColor;
    
    __weak typeof(self) weakSelf = self;
    self.keyboardMan = [[XLBKeyboardMan alloc] initWithKeyboardAppearBlock:^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardIncrementHeight) {
        weakSelf.containerView.y -= keyboardHeight;
    } disappearBlock:^(CGFloat keyboardHeight) {
        weakSelf.containerView.y += keyboardHeight;
    }];
    
    self.segmentedControl.sectionTitles = @[kLocat(@"OTC_order_deal_fiat_price"), kLocat(@"OTC_order_deal_number_of_buy")];
    [self _setupSegmentedControl];
    [self _updateMoneyOrNumberTextFieldPlaceHolder];
    [self.moneyOrNumberTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.moneyOrNumberTextField removeObserver:self forKeyPath:@"text"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if ( !CGRectContainsPoint(self.containerView.frame, point)) {
        [self hide];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.moneyOrNumberTextField]) {
        [self textFieldTextDidChange:nil];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.layer.mask.frame = self.containerView.bounds;
    self.maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)].CGPath;
}

#pragma mark - Private

- (void)_setupSegmentedControl {
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 1.5f;
    self.segmentedControl.selectionIndicatorColor = kColorFromStr(@"#DEE5FF");
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:12],NSFontAttributeName, [UIColor colorWithHexString:@"#7582A4"], NSForegroundColorAttributeName,nil];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],NSFontAttributeName, kColorFromStr(@"#DEE5FF"), NSForegroundColorAttributeName,nil];
    self.segmentedControl.titleTextAttributes = attributesNormal;
    self.segmentedControl.selectedTitleTextAttributes = attributesSelected;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) weakSelf = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        weakSelf.segmentedSelectIndex = index;
    };
}
/**
 计算 最大可买 CNY

 @param model model
 @return 最大可买(CNY)
 */
- (NSString *)_calculateTheMaxBuyingOfCNYForModel:(TPOTCOrderModel *)model {
    NSString *myMax = [NSString floatOne:model.avail calculationType:CalculationTypeForMultiply floatTwo:model.price];
    NSString *result = nil;
    if ([myMax doubleValue] > [model.max_money doubleValue]) {
        result = model.max_money;
    } else {
        result = myMax;
    }
    
    return [result rouningDownByScale:6];
}


/**
  计算 最大可买 数量

 @param model model
 @return 最大可买(数量)
 */
- (NSString *)_calculateTheMaxBuyingOfNumberForModel:(TPOTCOrderModel *)model {
    NSString *maxOfNumber = [NSString floatOne:model.max_money calculationType:CalculationTypeForDivide floatTwo:model.price];
    
    NSString *result = model.avail;
    if ([maxOfNumber doubleValue] < [model.avail doubleValue]) {
        result = maxOfNumber;
    }
    
    return [result rouningDownByScale:6];
}



#pragma mark - Public

- (NSString *)getNumber {
    NSString *moneyOrNumber = self.moneyOrNumberTextField.text;
    NSString *result = self.isTypeOfNumber ? moneyOrNumber : [moneyOrNumber resultByDividingByNumber:_model.price];
    result = [result rouningDownByScale:6];
    return result;
}

- (NSString *)getTotalMoney {
    NSString *moneyOrNumber = self.moneyOrNumberTextField.text;
    NSString *result = !self.isTypeOfNumber ? moneyOrNumber : [moneyOrNumber resultByMultiplyingByNumber:_model.price];
    result = [result rouningDownByScale:6];
    return result;
}

- (BOOL)isTypeOfNumber {
    return self.segmentedSelectIndex == 1;
}

- (void)show {
    
    if (!self.superview) {
        [kKeyWindow addSubview:self];
    }
    
    self.containerView.y = kScreenH;
    self.alpha = 0.01;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
    [UIView animateWithDuration:0.2 delay:0.1 options:(7 << 16) |UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.y = kScreenH - kViewHeight;
    } completion:nil];
}

- (void)hide {
    [self.timer invalidate];
    
    
    [UIView animateWithDuration:0.2 delay:0 options:(7 << 16) animations:^{
        self.containerView.y = kScreenH;
    } completion:^(BOOL finished) {
       
        _model = nil;
        [self removeFromSuperview];
    }];
}

- (IBAction)hideAction:(id)sender
{
    [self hide];
}

#pragma mark - Actions

-(void)allButtonAction
{
    if (_model.isTypeOfBuy) {//购买
        NSString *moneyOrNumber = self.isTypeOfNumber ? [self _calculateTheMaxBuyingOfNumberForModel:_model] : [self _calculateTheMaxBuyingOfCNYForModel:_model];
        
        _moneyOrNumberTextField.text = moneyOrNumber;
    }else{//出售
        NSString *moneyOrNumber = self.isTypeOfNumber ? _model.num : _model.max_money;
        
        _moneyOrNumberTextField.text = moneyOrNumber;
       
    }
    
   

}


-(void)countDown
{
    _second --;
    [_timeButton setTitle:[NSString stringWithFormat:@"%zds%@",_second,kLocat(@"net_alert_load_message_cancel")] forState:UIControlStateNormal];
    if (_second == 0) {
        [self.timer invalidate];
        [self hideAction:nil];
    }
}
#pragma mark - textfield代理
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//}
#pragma mark - 输入框通知
-(void)textFieldTextDidChange:(NSNotification *)noti
{
    
    [self _updateTradeNumberLabel];
    [self _updateTradeTotalMoneyNumber];
}

#pragma mark - Setter

-(void)setModel:(TPOTCOrderModel *)model
{
    _model = model;
    
    [self.timer invalidate];
    _second = 60;
    
    self.timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    
    
    if ([model.type isEqualToString:@"sell"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_main_buy"),model.currencyName];
        
        [_buyAllButton setTitle:kLocat(@"OTC_view_buyall") forState:UIControlStateNormal];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_main_sell"),model.currencyName];
        [_buyAllButton setTitle:kLocat(@"OTC_view_sellall") forState:UIControlStateNormal];
        
    }
    _moneyOrNumberTextField.text = nil;
    
    [_icon setImageWithURL:model.currency_logo.ks_URL placeholder:nil];
    _priceOfCurrencyLabel.text = [NSString stringWithFormat:@"¥%@", model.price ?: @"--"];
    
    _limitLabel.text = [NSString stringWithFormat:@"%@ %@-%@ CNY",kLocat(@"OTC_view_limtesum"),model.min_money,model.max_money];
    
    
    [_timeButton setTitle:[NSString stringWithFormat:@"%zds%@",_second,kLocat(@"Cancel")] forState:UIControlStateNormal];
    
    _dealButton.backgroundColor = kColorFromStr(@"4173C8");
    [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
}

- (void)setSegmentedSelectIndex:(NSInteger)segmentedSelectIndex {
    _segmentedSelectIndex = segmentedSelectIndex;
    
    self.moneyOrNumberTextField.text = nil;
    
    self.markLabel.text = self.isTypeOfNumber ? _model.currencyName : @"CNY";
    [self _updateMoneyOrNumberTextFieldPlaceHolder];
    [self _updateTradeNumberLabel];
    [self _updateTradeTotalMoneyNumber];
}

- (void)_updateMoneyOrNumberTextFieldPlaceHolder {
    self.moneyOrNumberTextField.placeholder = self.isTypeOfNumber  ? kLocat(@"OTC_buylist_inputvolume" ) : kLocat(@"OTC_buylist_inputmoney");
    
    kTextFieldPlaceHoldColor(self.moneyOrNumberTextField, kColorFromStr(@"#37415C"));
}

- (void)_updateTradeNumberLabel {
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", kLocat(@"OTC_order_dealvolume"), self.getNumber ?: @"--", self.model.currencyName ?: @""];
    self.tradeNumberLabel.text = text;
}

- (void)_updateTradeTotalMoneyNumber {
    NSString *text = [NSString stringWithFormat:@"%@ ￥%@", kLocat(@"OTC_order_deal_total_money"), self.getTotalMoney ?: @"--"];
    self.tradeTotalMoneyLabel.text = text;
}



@end
