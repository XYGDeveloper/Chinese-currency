//
//  TPOTCPostViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostViewController.h"
#import "TPOTCPostCell.h"
#import "TPOTCPostDetailController.h"

@interface TPOTCPostViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,strong)NSDictionary *currencyInfo;

@property(nonatomic,strong)UITextField *priceTF;
@property(nonatomic,strong)UITextField *volumeTF;
@property(nonatomic,strong)UITextField *sumTF;
@property(nonatomic,strong)UITextField *lowTF;
@property(nonatomic,strong)UITextField *highTF;
@property(nonatomic,strong)IQTextView *remarkTV;
@property(nonatomic,strong)UIButton *lowButton;
@property(nonatomic,strong)UIButton *highButton;
@property(nonatomic,strong)UISlider *slider;

@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *maxLabel;



@end

@implementation TPOTCPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
   
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

#pragma mark - Private

-(void)setupUI
{
    self.enablePanGesture = NO;

    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight - 45 - 44) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kThemeColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPostCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPostCell"];
    
    [self setupBottomView];
}
-(void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(0, _tableView.bottom, kScreenW, 45)];
    [self.view addSubview:bottomView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, bottomView.width/2, bottomView.height) title:kLocat(@"OTC_post_next") titleColor:kWhiteColor font:PFRegularFont(15) titleAlignment:0];
    [bottomView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:kRectMake(leftButton.right, 0, bottomView.width/2, bottomView.height) title:kLocat(@"Cancel") titleColor:kColorFromStr(@"#9BBBEB") font:PFRegularFont(15) titleAlignment:0];
    [bottomView addSubview:rightButton];
    
    leftButton.backgroundColor = kColorFromStr(@"#4173C8");
    rightButton.backgroundColor = kColorFromStr(@"#37415C");
        
    leftButton.tag = 0;
    rightButton.tag = 1;
    [leftButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)loadData
{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _model.currencyID;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/TradeOtc/icon_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
         
            _userInfo = [responseObj ksObjectForKey:kData][@"user"];
            
            _currencyInfo = [responseObj ksObjectForKey:kData][@"currency"];
            
            [self.tableView reloadData];
            
        }
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPOTCPostCell";
    TPOTCPostCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    if (_type == TPOTCPostViewControllerTypeSell) {
        cell.type = 1;
        _slider =  cell.sslide;
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [cell.allButton addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.type = 0;
    }
    cell.sumTF.userInteractionEnabled = NO;
    if (_userInfo) {
        
        if ([_currencyInfo[@"newprice"] doubleValue] + [_currencyInfo[@"newprice2"] doubleValue] > 0) {
            cell.limiteInfoLabel.hidden = NO;
            cell.limiteInfoLabel.text = [NSString stringWithFormat:@"%@：￥%@,%@：%@",kLocat(@"OTC_post_upperprice"),_currencyInfo[@"newprice2"],kLocat(@"OTC_post_lowerprice"),_currencyInfo[@"newprice"]];
        }else if([_currencyInfo[@"newprice"] doubleValue] + [_currencyInfo[@"newprice2"] doubleValue]) {
            cell.limiteInfoLabel.hidden = YES;
        }
        if ([_currencyInfo[@"newprice"] doubleValue] > 0 &&  [_currencyInfo[@"newprice2"] doubleValue] > 0) {
            cell.limiteInfoLabel.hidden = NO;
            cell.limiteInfoLabel.text = [NSString stringWithFormat:@"%@：￥%@,%@：￥%@",kLocat(@"OTC_post_upperprice"),_currencyInfo[@"newprice2"],kLocat(@"OTC_post_lowerprice"),_currencyInfo[@"newprice"]];
        }else if ([_currencyInfo[@"newprice"] doubleValue] == 0 &&  [_currencyInfo[@"newprice2"] doubleValue] > 0){
            cell.limiteInfoLabel.hidden = NO;
            cell.limiteInfoLabel.text = [NSString stringWithFormat:@"%@：￥%@",kLocat(@"OTC_post_upperprice"),_currencyInfo[@"newprice2"]];
        }else if ([_currencyInfo[@"newprice"] doubleValue] > 0 &&  [_currencyInfo[@"newprice2"] doubleValue] == 0){
            cell.limiteInfoLabel.hidden = NO;
            cell.limiteInfoLabel.text = [NSString stringWithFormat:@"%@：%@",kLocat(@"OTC_post_lowerprice"),_currencyInfo[@"newprice"]];
        }else{
            cell.limiteInfoLabel.hidden = YES;
        }
        
        if (_type == TPOTCPostViewControllerTypeSell) {
             cell.ownVolumeLabel.hidden = NO;
            cell.ownVolumeLabel.text = [NSString stringWithFormat:@"%@: %@ %@",kLocat(@"OTC_post_own"),_userInfo[@"currency_num"],_model.currencyName];
        }else{
           cell.ownVolumeLabel.hidden = YES;
        }
        
        [cell.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.minusButton addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.leftLabel.text = [NSString stringWithFormat:@"%@: %@ %@",kLocat(@"OTC_post_postleft"),_userInfo[@"sell_num"],_model.currencyName];
        cell.maxLabel.text = [NSString stringWithFormat:@"%@ %@",_userInfo[@"sell_num"],_model.currencyName];
        _leftLabel = cell.leftLabel;
        _maxLabel = cell.maxLabel;
        
    }

    NSString *max = [_currencyInfo ksObjectForKey:@"make_max_num"];
    NSString *min = [_currencyInfo ksObjectForKey:@"make_min_num"];
    cell.minAndMaxNumberRangeLabel.text = [NSString stringWithFormat:@"%@%@, %@%@", kLocat(@"OTC_Min"), min ?: @"", kLocat(@"OTC_Max"), max ?: @""];
    
    cell.currencyMarkLabel.text = _model.currencyName ?: @"--";
    _priceTF = cell.priceTF;
    _volumeTF = cell.volumeTF;
    _sumTF = cell.sumTF;
    _lowTF = cell.lowLimitTF;
    _highTF = cell.highLimitTF;
    _remarkTV = cell.remarkTV;
    _lowButton = cell.limiteLowButton;
    _highButton = cell.limiteHighButton;
    
    cell.priceTF.delegate = self;
    cell.volumeTF.delegate = self;
    cell.highLimitTF.delegate = self;
    cell.lowLimitTF.delegate = self;
    __weak typeof(self)weakSelf = self;

    [cell.limiteLowButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton  *_Nonnull sender) {
        weakSelf.lowButton.selected = !weakSelf.lowButton.isSelected;
        
        weakSelf.lowTF.userInteractionEnabled = weakSelf.lowButton.isSelected;
        if (!sender.isSelected) {
            weakSelf.lowTF.text = nil;
        }
    }];
    
    [cell.limiteHighButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * _Nonnull sender) {
        weakSelf.highButton.selected = !weakSelf.highButton.isSelected;
        weakSelf.highTF.userInteractionEnabled = weakSelf.highButton.isSelected;
        if (!sender.isSelected) {
            weakSelf.highTF.text = nil;
        }
    }];
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == TPOTCPostViewControllerTypeSell) {
        return 706-50 - 50;
    }else{
        return 706-50 - 50 - 85;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 50)];
    headView.backgroundColor = kColorFromStr(@"#0B132A");
    UIView *lineView = [[UIView alloc] initWithFrame:kRectMake(12, 0, 3, 18)];
    [headView addSubview:lineView];
    lineView.backgroundColor = kColorFromStr(@"#4173C8");
    [lineView alignVertical];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(20, 0, 200, 50) text:kLocat(@"OTC_post_postad") font:PFRegularFont(18) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [headView addSubview:label];
    return headView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}




#pragma mark - 点击事件

-(void)bottomButtonAction:(UIButton *)button
{
    if (button.tag == 0) {//下一步
        [self nextAction];
    }else{//取消
        kNavPop;
    }
}

#pragma mark - 下一步事件

-(void)nextAction
{
    
    if (_priceTF.text.doubleValue == 0) {
        [self showTips:kLocat(@"OTC_post_priceshouldbigthan0")];
        return;
    }
    if (_volumeTF.text.doubleValue == 0) {
        [self showTips:kLocat(@"OTC_post_volumeshouldbigthan0")];
        return;
    }
    if (_remarkTV.text.length == 0) {
        [self showTips:kLocat(@"OTC_post_inputremark")];
        return;
    }
    
    double lowPrice = [_currencyInfo[@"newprice"] doubleValue];
    double highPrice = [_currencyInfo[@"newprice2"] doubleValue];
    if (lowPrice > 0 && _priceTF.text.doubleValue < lowPrice) {
        [self showTips:kLocat(@"OTC_post_pricesmall")];
        return;
    }
    if (highPrice > 0 && _priceTF.text.doubleValue > highPrice) {
        [self showTips:kLocat(@"OTC_post_pricebig")];
        return;
    }
    
    
    
    
    

    TPOTCPostDetailController *vc = [[TPOTCPostDetailController alloc] init];
    
    if (_type == TPOTCPostViewControllerTypeBuy) {
        vc.type = TPOTCPostDetailControllerBuy;
    }else{
        vc.type = TPOTCPostDetailControllerSell;
    }
    
    
    vc.currencyInfo = _currencyInfo;
    vc.price = _priceTF.text;
    vc.volume = _volumeTF.text;
    vc.sum = _sumTF.text;
    vc.remark = _remarkTV.text;
    if (_lowButton.isSelected) {
        vc.minDeal = _lowTF.text;
        if (_lowTF.text.doubleValue > _sumTF.text.doubleValue) {
            [self showTips:kLocat(@"OTC_post_sumbig")];
            return;
        }
        
    }
    
    
    
    if (_highButton.isSelected) {
        if (_highTF.text.doubleValue < 0 ) {
            [self showTips:kLocat(@"OTC_post_sumshouldbigthan0")];
            return;
        }
        if (_highTF.text.doubleValue >_sumTF.text.doubleValue) {
            [self showTips:kLocat(@"OTC_post_maxshouldsmallthansum")];
            return;
        }
 
        vc.maxDeal = _highTF.text;
    }
    
    if (_lowButton.selected && _highButton.selected) {
        
        if (_highTF.text.doubleValue < _lowTF.text.doubleValue) {
            [self showTips:kLocat(@"OTC_post_highsumlessthanlowsum")];
            return;
        }
    }
    

    
    
    
    
    kNavPush(vc);
 
    
}



-(void)addAction:(UIButton *)button
{
    [self hideKeyBoard];
    _priceTF.text = [NSString floatOne:_priceTF.text calculationType:CalculationTypeForAdd floatTwo:@"0.1"];
    [self handleSumTF];
}

-(void)minusAction:(UIButton *)button
{
    [self hideKeyBoard];

    _priceTF.text = [NSString floatOne:_priceTF.text calculationType:CalculationTypeForSubtract floatTwo:@"0.1"];
    if (_priceTF.text.doubleValue < 0) {
        _priceTF.text = @"0";
    }
    
    [self handleSumTF];
}
-(void)handleSumTF
{
    double sum = _priceTF.text.doubleValue * _volumeTF.text.doubleValue;
    if (sum > 0) {
        _sumTF.text = [NSString floatOne:_priceTF.text calculationType:CalculationTypeForMultiply floatTwo:_volumeTF.text];
        
        BOOL isHaveDian = YES;
        if ([_sumTF.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if (isHaveDian) {
            
            NSArray *arr = [_sumTF.text componentsSeparatedByString:@"."];
            
            NSString *str = arr.lastObject;
            
            if (str.length > 2) {
                str = [str substringToIndex:2];
            }
            _sumTF.text = [NSString stringWithFormat:@"%@.%@",arr.firstObject,str];
        }
        
    }else{
        _sumTF.text = @"0.00";
    }
}



#pragma mark - 滑杆事件


-(void)sliderAction:(UISlider *)slider
{
    [self hideKeyBoard];
    _volumeTF.text = [NSString floatOne:ConvertToString(_userInfo[@"currency_num"]) calculationType:CalculationTypeForMultiply floatTwo:ConvertToString(@(slider.value))];
    
    _volumeTF.text = [NSString stringWithFormat:@"%.6f",_volumeTF.text.doubleValue];
    
    if (_type == TPOTCPostViewControllerTypeSell) {
        _leftLabel.text = [NSString stringWithFormat:@"%@: %@ %@",kLocat(@"OTC_post_postleft"),[NSString floatOne:ConvertToString(_userInfo[@"currency_num"]) calculationType:CalculationTypeForSubtract floatTwo:_volumeTF.text],_model.currencyName];
    }
    
    [self handleSumTF];
}


- (void)allAction:(id)sender {
    _volumeTF.text = ConvertToString(_userInfo[@"sell_num"] ?: @"0");
    if (_currencyInfo) {
        if (_volumeTF.text.doubleValue > [[_currencyInfo ksObjectForKey:@"make_max_num"] doubleValue]) {
            NSString *string = ConvertToString([_currencyInfo ksObjectForKey:@"make_max_num"]);
            _volumeTF.text = string;
        }
    }
}

#pragma mark - textfield代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    //                    showMsg(@"数据格式有误");
                    NSLog(@"数据格式有误");
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    //                    showMsg(@"数据格式有误");
                    NSLog(@"数据格式有误");
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    
                    if (textField == _priceTF) {
                        if (range.location - ran.location <= 4) {
                            return YES;
                        }else{
                            NSLog(@"最多两位小数");
                            return NO;
                        }
                    }else if(textField == _volumeTF){
                        if (range.location - ran.location <= 6) {
                            return YES;
                        }else{
                            NSLog(@"最多两位小数");
                            return NO;
                        }
                    }else {
                        if (textField == _lowTF || textField == _highTF) {//限额
                            if (range.location - ran.location <= 2) {
                                return YES;
                            }else{
                                NSLog(@"最多两位小数");
                                return NO;
                            }
                        }else{
                            return YES;
                        }
                    }
                    
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //            showMsg(@"数据格式有误");
            NSLog(@"数据格式有误");
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_volumeTF]) {
        NSString *volume = _volumeTF.text;
        NSString *makeMinNum = [_currencyInfo ksObjectForKey:@"make_min_num"];
        if ([volume doubleValue] < [makeMinNum doubleValue]) {
            _volumeTF.text = makeMinNum;
        }
    }
    
    if (textField == self.lowTF) {
        NSString *text = _lowTF.text;
        if (text.length > 0 && [text doubleValue] < 1) {
            _lowTF.text = @"1";
        }
    }
}

#pragma mark - 输入框通知
-(void)textFieldTextDidChange:(NSNotification *)noti
{
    UITextField *tf = noti.object;
    
    if (tf == _priceTF || tf == _volumeTF) {//计算金额
        [self handleSumTF];
    }
    
    if (tf == _volumeTF) {
        
        if (_type == TPOTCPostViewControllerTypeSell) {
            CGFloat sell_num = [_userInfo[@"sell_num"] doubleValue];
            if (_volumeTF.text.doubleValue > sell_num) {
                _volumeTF.text = ConvertToString(_userInfo[@"sell_num"]);
            }
        }
        
        if (_currencyInfo) {
            if (_volumeTF.text.doubleValue > [[_currencyInfo ksObjectForKey:@"make_max_num"] doubleValue]) {
                NSString *string = ConvertToString([_currencyInfo ksObjectForKey:@"make_max_num"]);
                _volumeTF.text = string;
            }
        }
        
        
        if ([_userInfo[@"sell_num"] doubleValue] > 0) {//滑杆数值改变
            _slider.value = _volumeTF.text.doubleValue / [_userInfo[@"sell_num"]doubleValue];
            NSString *vol = [NSString floatOne:ConvertToString(_userInfo[@"sell_num"]) calculationType:CalculationTypeForSubtract floatTwo:_volumeTF.text];
            _leftLabel.text = [NSString stringWithFormat:@"%@: %@ %@",kLocat(@"OTC_post_postleft"),vol,_model.currencyName];
        }
    }
    
    if (tf == _highTF) {
        NSString *highText = _highTF.text;
        NSString *sumText = _sumTF.text;
        //当输入最高交易额大于总交易额是 数值自动变成总交易额
        if ([highText doubleValue] > [sumText doubleValue]) {
            _highTF.text = _sumTF.text;
        }
    }
    
   
}






-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
