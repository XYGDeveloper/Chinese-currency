//
//  TPOTCPostDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostDetailController.h"
#import "TPOTCPostDetailListCell.h"
#import "TPOTCPostDetailSellCell.h"
#import "TPOTCPostDetailPayCell.h"
#import "TPOTCPayWayModel.h"
#import "TPOTCPayWayListController.h"
#import "TPOTCPostStatusController.h"
#import "NSObject+SVProgressHUD.h"
#import "HBOTCPostDetailGotoSetupPayWayView.h"
#import "HBPasswordOrVerifyInputView.h"
#import "UIButton+LSSmsVerification.h"

@interface TPOTCPostDetailController ()<UITableViewDelegate,UITableViewDataSource,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)UIButton *confirmButton;

@property(nonatomic,strong)NSMutableArray<TPOTCPayWayModel *> *payWayArray;

@property(nonatomic,strong)NSString *realVolume;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property(nonatomic,copy)NSString *verifyStr;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) HBPasswordOrVerifyInputView *passwordInputView;

@property (nonatomic, strong) HBPasswordOrVerifyInputView *verifyCodeInputView;

@end

@implementation TPOTCPostDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    _payWayArray = [NSMutableArray array];

    [self _updateBottomUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    
    [self loadPayWayInfo];
    [self initVerifyConfigure];

}

- (void)_updateBottomUI {
    self.bottomView.hidden = self.payWayArray.count == 0;
    if (self.payWayArray.count == 0) {
        _tableView.tableFooterView = [self _createToSetupPaywayView];
    } else {
        _tableView.tableFooterView = [self setupFootView];
    }
    
}


-(void)setupUI
{
    self.title = kLocat(@"OTC.TPOTCPostDetailController.title");
//    self.view.backgroundColor = kColorFromStr(@"#171F34");
    self.view.backgroundColor = kThemeColor;
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0, 0, kScreenW, kScreenH - kNavigationBarHeight - 50.) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPostDetailListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPostDetailListCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPostPaywayCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPostPaywayCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPostDetailSellCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPostDetailSellCell"];

    
    
    _tableView.tableHeaderView = [self setHeaderView];
//    _tableView.tableFooterView = [self setupFootView];
    
    [self setupBottomView];
}

-(UIView *)setHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 105)];
    headView.backgroundColor = kColorFromStr(@"#0B132A");
    
    UIImageView *icon  = [[UIImageView alloc] initWithFrame:kRectMake(12, 23, 40, 40)];
    [headView addSubview:icon];
//    icon.image = kImageFromStr(@"");
    [icon setImageWithURL:[NSURL URLWithString:ConvertToString(_currencyInfo[@"currency_logo"])] placeholder:nil];
    
    NSString *titleStr;
    if (_type == TPOTCPostDetailControllerBuy) {
        titleStr = kLocat(@"OTC_post_postbuyad");
    }else{
        titleStr = kLocat(@"OTC_post_postsellad");
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:kRectMake(icon.right + 10, 2, 200, 18) text:titleStr font:PFRegularFont(18) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [headView addSubview:title];
    title.centerY = icon.centerY;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(12, icon.bottom + 18, 300, 15) text:kLocat(@"OTC_post_confirmthemesg") font:PFRegularFont(14) textColor:kColorFromStr(@"#FFD401") textAlignment:0 adjustsFont:YES];
    [headView addSubview:tipsLabel];
    
    return headView;
}


- (UIView *)_createToSetupPaywayView {
    
    
    HBOTCPostDetailGotoSetupPayWayView *view = [HBOTCPostDetailGotoSetupPayWayView viewLoadNib];
    
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
        kNavPush(vc);
    }]];
    return view;
}

-(UIView *)setupFootView
{
    __weak typeof(self)weakSelf = self;

    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 60)];
    view.backgroundColor = kColorFromStr(@"#0B132A");

    UIButton *button = [[UIButton alloc]initWithFrame:kRectMake(0, 0, 300, 14)];
    [view addSubview:button];
    [button alignVertical];
    button.centerX = kScreenW/2+5;
    NSString *str = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_post_haverad"),kLocat(@"OTC_post_userpro")];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:kLocat(@"OTC_post_userpro")];
    
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kColorFromStr(@"#CCCCCC")
                 range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSFontAttributeName
                 value:PFRegularFont(12)
                 range:NSMakeRange(0, str.length)];
    
    
    [attr addAttribute:NSForegroundColorAttributeName
                          value:kColorFromStr(@"#4173C8")
                          range:range];
    [button setAttributedTitle:attr forState:UIControlStateNormal];
    
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //协议
        [weakSelf showPrototcolWebVCAction:sender];
    }];
    
    UIButton *statusButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 26, 26)];
    [view addSubview:statusButton];
    statusButton.centerY = button.centerY;
    statusButton.right = button.x;

    [statusButton setImage:kImageFromStr(@"kuang_icon") forState:UIControlStateNormal];
    [statusButton setImage:kImageFromStr(@"kuang_icon_gou") forState:UIControlStateSelected];
    statusButton.selected = YES;
    _confirmButton = statusButton;

    [statusButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        weakSelf.confirmButton.selected = !weakSelf.confirmButton.selected;

    }];
    return view;
}

-(void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(0, _tableView.bottom, kScreenW, 50.)];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(12., 0, bottomView.width - 2 * 12., 45.) title:kLocat(@"OTC_post_postad") titleColor:kWhiteColor font:PFRegularFont(15) titleAlignment:0];
    [bottomView addSubview:leftButton];
    leftButton.layer.cornerRadius = 8.;
    leftButton.backgroundColor = kColorFromStr(@"#4173C8");
    [leftButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)loadPayWayInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Bank/active"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            [self.payWayArray removeAllObjects];
            NSMutableArray *tmp = @[].mutableCopy;
            if ([dic[@"alipay"] isKindOfClass:[NSDictionary class]]) {
                TPOTCPayWayModel *model = [TPOTCPayWayModel modelWithJSON:dic[@"alipay"]];
                model.isSelected = YES;
                model.type = @"alipay";
                [tmp addObject:model];
            }
            if ([dic[@"wechat"] isKindOfClass:[NSDictionary class]]) {
                TPOTCPayWayModel *model = [TPOTCPayWayModel modelWithJSON:dic[@"wechat"]];
                model.isSelected = YES;
                model.type = @"wechat";

                [tmp addObject:model];
            }
            if ([dic[@"bank"] isKindOfClass:[NSDictionary class]]) {
                TPOTCPayWayModel *model = [TPOTCPayWayModel modelWithJSON:dic[@"bank"]];
                model.isSelected = YES;
                model.type = @"bank";

                [tmp addObject:model];
            }
            self.payWayArray = tmp.mutableCopy;
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
            
            if (self.payWayArray.count == 0) {
                [self showTips:kLocat(@"OTC_post_setpayway")];
            }
        }else{
            [self.payWayArray removeAllObjects];
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
            
            [self showTips:kLocat(@"OTC_post_setpayway")];

        }
        
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return self.titleArray.count - 2;
    }else{
        
//        if (self.payWayArray.count == 0) {
//            return 1;
//        }else{
            return self.payWayArray.count;
//        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2) {
        
        static NSString *rid = @"TPOTCPostDetailListCell";
        TPOTCPostDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        if (indexPath.section == 0) {
            cell.itemLabel.text = self.titleArray[indexPath.row];
            if (indexPath.row == 1) {
                cell.lineView.hidden = NO;
                cell.infoLabel.text = _price;
            }else{
                cell.lineView.hidden = YES;
                cell.infoLabel.text = _currencyInfo[@"currency_name"];
            }
        }else{
            cell.itemLabel.text = self.titleArray[indexPath.row+2];
            if (indexPath.row == 7) {
                cell.lineView.hidden = NO;
            }else{
                cell.lineView.hidden = YES;
            }
            if (indexPath.row == 0) {
                cell.infoLabel.text = _volume;

            }else if (indexPath.row == 1){
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_sum];
            }else if (indexPath.row == 2){//最高交易额
                if (_maxDeal) {
                    cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_maxDeal];
                }else{
                    cell.infoLabel.text = @"0 CNY";
                }
            }else if (indexPath.row == 3){//最低交易额
                if (_minDeal) {
                    cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_minDeal];
                }else{
                    cell.infoLabel.text = @"0 CNY";
                }
            }else if (indexPath.row == 4){//手续费率
                cell.infoLabel.text = [NSString stringWithFormat:@"%@%%",_currencyInfo[@"currency_otc_sell_fee"]];
            }else if (indexPath.row == 5){//手续费
                
                cell.infoLabel.text = [NSString floatOne:_volume calculationType:CalculationTypeForMultiply floatTwo:[NSString stringWithFormat:@"%@",@([_currencyInfo[@"currency_otc_sell_fee"] doubleValue]/100.0)]];
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@",cell.infoLabel.text,_currencyInfo[@"currency_name"]];
                
            }else if (indexPath.row == 6){//扣费方式
                if (self.type == TPOTCPostDetailControllerBuy) {
                    cell.infoLabel.text = kLocat(@"OTC_post_Settlement_deduction");
                } else {
                    cell.infoLabel.text = kLocat(@"OTC_post_directpayfee");
                }
                
            }else if (indexPath.row == 7){//实际支付数量

                cell.infoLabel.text = [NSString floatOne:_volume calculationType:CalculationTypeForMultiply floatTwo:[NSString stringWithFormat:@"%@",@([_currencyInfo[@"currency_otc_sell_fee"] doubleValue]/100.0 + 1)]];
                
                _realVolume = cell.infoLabel.text;
            }

            
        }
        
        
        
        return cell;
        
    }else{
        
//        if (_type == TPOTCPostDetailControllerBuy) {
//            static NSString *rid = @"TPOTCPostDetailPayCell";
//            TPOTCPostDetailPayCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//            if (cell == nil) {
//                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
//            }
//
//            return cell;
//        }else{
//
//            if (self.payWayArray.count > 0) {
            
                static NSString *rid = @"TPOTCPostDetailSellCell";
                TPOTCPostDetailSellCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
                }
                
                cell.model = self.payWayArray[indexPath.row];
                cell.swtch.tag = indexPath.row;
            
            cell.swtch.on = self.payWayArray[indexPath.row].isSelected;
            __weak typeof(self)weakSelf = self;

                [cell.swtch addTarget:self action:@selector(selectPayWayAction:) forControlEvents:UIControlEventValueChanged];
                [cell.modifyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
                    kNavPushSafe(vc);
                }];
                
                return cell;
//            }else{
//                UITableViewCell *cell = [UITableViewCell new];
//                cell.selectionStyle = 0;
//                cell.contentView.backgroundColor = kColorFromStr(@"1E1F22");
//
//                UIImageView *img = [[UIImageView alloc] initWithFrame:kRectMake((kScreenW - 35)/2, 5, 35, 35)];
//                [cell.contentView addSubview:img];
//                img.image = kImageFromStr(@"shoukuan_icon_shc");
//
//                return cell;
//            }
   
//        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (self.payWayArray.count == 0) {
            TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
            kNavPush(vc);
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
//        if (_type == TPOTCPostDetailControllerBuy) {
//            return 54;
//        }else{
////            if (self.payWayArray.count == 0) {
////                return 45;
////            }else{
//                return 70;
////            }
//        }
        return 70;
    }else{
        return 25;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        return 38;
    }
    
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 38)];
        view.backgroundColor = kColorFromStr(@"#0B132A");
        view.userInteractionEnabled = YES;
        NSString *str;
        if (_type == TPOTCPostDetailControllerSell) {
            str = kLocat(@"OTC_post_setgetway");
        }else{
            str = kLocat(@"OTC_post_setpayway1");
        }
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 10, 200, 30) text:str font:PFRegularFont(16) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
        [view addSubview:label];
        [label alignVertical];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
            kNavPush(vc);
        }]];

        UIImageView *arrow = [[UIImageView alloc] initWithFrame:kRectMake(kScreenW - 12 - 8, 0, 8, 15)];
        [view addSubview:arrow];
        arrow.image = kImageFromStr(@"user_icon_getin");
        [arrow alignVertical];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 37.5, kScreenW-24, 0.5)];
        lineView.backgroundColor = kColorFromStr(@"171F34");

        [view addSubview:lineView];
        return view;
    }

    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 5.)];
    view.backgroundColor = kColorFromStr(@"#171F34");
    return view;
}




#pragma mark - 点击事件

- (void)showPrototcolWebVCAction:(id)sender {
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,register_agreement,[Utilities dataChangeUTC]]];
    kNavPush(vc);
}

-(void)bottomButtonAction:(UIButton *)button
{
    BOOL hasPayway = NO;
    
    for (TPOTCPayWayModel *model in self.payWayArray) {
        if (model.isSelected) {
            hasPayway = YES;
            break;
        }
    }
    
    if (hasPayway == NO) {
        [self showTips:kLocat(@"OTC_post_atleaset1payway")];
        return;
    }
    
    [self showTipsView];
    
}



-(void)selectPayWayAction:(UISwitch *)swith
{

    swith.on = !swith.on;
    
    self.payWayArray[swith.tag].isSelected = swith.on;
    
    [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)postActionWithVerifyCode:(NSString *)verifyCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"price"] = _price;
    param[@"num"] = _volume;
    param[@"currency_id"] = _currencyInfo[@"currency_id"];
    param[@"order_message"] = _remark;
    param[@"code_deal"] = verifyCode ?: @"";
    param[@"validate"] = _verifyStr;
    if (_maxDeal) {
        param[@"max_money"] = _maxDeal;
    }
    if (_minDeal) {
        param[@"min_money"] = _minDeal;
    }
//    NSMutableString *payway = [NSMutableString string];
//    for (TPOTCPayWayModel *model in self.payWayArray) {
//        if (model.isSelected) {
//            [payway appendString:[NSString stringWithFormat:@"%@,",model.pid]];
//        }
//    }
//
//    if ([payway hasSuffix:@","]) {
//        payway = [payway substringWithRange:NSMakeRange(0, payway.length - 1)].mutableCopy;
//    }
//    param[@"money_type"] = payway;
    for (TPOTCPayWayModel *model in self.payWayArray) {
        if (model.isSelected) {
            
            if ([model.type isEqualToString:@"bank"]) {
                param[@"bank"] = model.pid;
            }else if ([model.type isEqualToString:@"alipay"]){
                param[@"alipay"] = model.pid;
            }else{
                param[@"wechat"] = model.pid;
            }
        }
    }
    NSString *apiURIString = (_type == TPOTCPostDetailControllerSell) ? @"/TradeOtc/sell_num" : @"/TradeOtc/buy_num";
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:apiURIString] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
//            [self showTips:@"发布成功"];
            [self.verifyCodeInputView hide];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidPostAdKey" object:_currencyInfo[@"currency_id"]];
            
            
            TPOTCPostStatusController *vc = [TPOTCPostStatusController new];
            vc.type = TPOTCPostStatusControllerTypeSuccess;
            kNavPush(vc);
            
            /**
             result =     {
             "orders_id" = 2;
             };
             
             */
        }else{
            NSInteger code = [[responseObj ksObjectForKey:@"code"] integerValue];
            if (code == 30100) {//未设置昵称
                [self _alertNicknameTextField];
            } else {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
            
        }
        
    }];

}




-(NSArray *)titleArray
{
    if (_titleArray == nil) {
//        if (_type == TPOTCPostDetailControllerBuy) {
//
//            _titleArray = @[@""];
//        }else{
//            _titleArray = @[@"币种:",@"限价:",@"发布数量:",@"交易额:",@"最高交易额:",@"最低家交易额:",@"手续费费率:",@"手续费:",@"扣款方式:",@"实际支付数量:"];
//        }
        _titleArray = @[@"幣種:",@"限價:",@"發布數量:",@"交易額:",@"最高交易額:",@"最低交易額:",@"手續費費率:",@"手續費:",@"扣款方式:",@"實際支付數量:"];
        NSString *kRealvolume = self.type == TPOTCPostDetailControllerSell ? kLocat(@"OTC_post_realvolume") : kLocat(@"OTC_post_realvolume_buy");
        _titleArray = @[kLocat(@"OTC_post_currency"),kLocat(@"OTC_post_limitprice"),kLocat(@"OTC_post_volume"),kLocat(@"OTC_post_sum"),kLocat(@"OTC_post_maxsum"),kLocat(@"OTC_post_minsum"),kLocat(@"OTC_post_feerate"),kLocat(@"OTC_post_fee"),kLocat(@"OTC_post_payway"), kRealvolume];

        
    }
    return _titleArray;
}


-(void)showTipsView
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 190 *kScreenHeightRatio, kScreenW - 56, 230)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 63) text:kLocat(@"OTC_post_attention") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, midView.height - 45, midView.width/2, 45) title:kLocat(@"Cancel") titleColor:kColorFromStr(@"#31AAD7") font:PFRegularFont(16) titleAlignment:YES];
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, midView.height - 45, midView.width/2, 45) title:kLocat(@"OTC_post_ihaveknow") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");
    
    __weak typeof(self)weakSelf = self;

    [confirmlButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
        
        [sender.superview.superview removeFromSuperview];

        [weakSelf showVerifyInfo];
    }];
    NSString *tips;
    if (self.type == TPOTCPostDetailControllerBuy) {
        tips = kLocat(@"OTC_post_posttips_buy");
    } else {
        NSString *volAndToken = [NSString stringWithFormat:@"%@%@", _realVolume, _currencyInfo[@"currency_name"]];
        NSString *fee = [NSString stringWithFormat:@"%@", @([_currencyInfo[@"currency_otc_sell_fee"] floatValue])];
        tips = kLocat(@"OTC_post_posttips");
        tips = [tips stringByReplacingOccurrencesOfString:@"****" withString:volAndToken];
        tips = [tips stringByReplacingOccurrencesOfString:@"XXX" withString:fee];
    }

    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom-20, midView.width - 56, midView.height - 30 - titleLabel.height) text:tips font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    
}

-(void)showVerifyInfo
{
    [self hideKeyBoard];
  
    if (_confirmButton.selected == NO) {
        [self showTips:kLocat(@"OTC_post_pleaseacceptpro")];
        return;
    }
    
    BOOL hasPayway = NO;
    
    for (TPOTCPayWayModel *model in self.payWayArray) {
        if (model.isSelected) {
            hasPayway = YES;
            break;
        }
    }
    if (hasPayway == NO) {
        [self showTips:kLocat(@"OTC_post_atleaset1payway")];
        return;
    }
    

    [self.manager openVerifyCodeView:nil];
}
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        [self validateYiDunCode:validate];
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}


/**
 1.验证滑动校验码

 @param validate 滑动校验码
 */
- (void)validateYiDunCode:(NSString *)validate {
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/TradeOtc/validateYiDun" parameters:@{@"validate" : validate ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            [self showPasswordInputView];
        } else {
            [self showTips:model.message];
        }
        kHideHud;
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}


/**
 2.1 输入交易密码并校验交易密码
 */
- (void)showPasswordInputView {
    self.passwordInputView = [HBPasswordOrVerifyInputView getPasswordView];
    [self.passwordInputView showInWindow];
    __weak typeof(self) weakSelf = self;
    self.passwordInputView.callBackBlock = ^(UIButton * _Nonnull sureButton, NSString * _Nonnull text) {
        if (text.length < 0) {
            return ;
        }
        [weakSelf validatePassword:text];
    };
}


/**
  2.2 校验交易密码

 @param password 交易密码
 */
- (void)validatePassword:(NSString *)password {
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/TradeOtc/validatePayPwd" parameters:@{@"pay_pwd" : password ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        kHideHud;
        if ([model succeeded]) {
            [self.passwordInputView hideWithCompletion:^{
                [self showVerifyCodeView];
            }];
        } else {
            [self showTips:model.message];
        }
        
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}


/**
 3.1 获取手机或邮箱验证码
 */
- (void)showVerifyCodeView {
    self.verifyCodeInputView = [HBPasswordOrVerifyInputView getVerifyCodeView];
    [self.verifyCodeInputView showInWindow];
    __weak typeof(self) weakSelf = self;
    self.verifyCodeInputView.sendBlock = ^(UIButton * _Nonnull sendButton) {
        [weakSelf getVerifyCode];
    };
    self.verifyCodeInputView.callBackBlock = ^(UIButton * _Nonnull sureButton, NSString * _Nonnull text) {
        if (text.length <= 0) {
            return ;
        }
        [weakSelf postActionWithVerifyCode:text];
    };
}

- (void)getVerifyCode {
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/TradeOtc/OtcSandPhone" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        kHideHud;
        if (model.succeeded) {
            [self.verifyCodeInputView startCountDownTime];
        } else {
            [self showTips:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}


-(void)initVerifyConfigure
{
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    
    // 设置透明度
    self.manager.alpha = 0;
    
    // 设置frame
    self.manager.frame = CGRectNull;
    
    // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = kVerifyKey;
    [self.manager configureVerifyCode:captchaId timeout:7];
}

#pragma mark - Alert

- (void)_alertNicknameTextField {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocat(@"HBMemberViewController_set_nickname") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *nickName = alertController.textFields.firstObject.text;
        [self modifyNick:nickName];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)modifyNick:(NSString *)nick {
    if (!nick) {
        return;
    }
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/Account/modifynick" parameters:@{@"nick" : nick ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        
        kHideHud;
        if ([model succeeded]) {
            [self showSuccessWithMessage:model.message];
            kUserInfo.nick = nick;
            [kUserInfo saveUserInfo];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

#pragma mark - Setter

- (void)setPayWayArray:(NSMutableArray<TPOTCPayWayModel *> *)payWayArray {
    _payWayArray = payWayArray;
    
    [self _updateBottomUI];
}

@end
