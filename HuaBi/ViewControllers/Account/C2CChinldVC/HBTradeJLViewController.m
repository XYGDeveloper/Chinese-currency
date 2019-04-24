//
//  HBTradeJLViewController.m
//  HuaBi
//
//  Created by l on 2018/10/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBTradeJLViewController.h"
#import "HBTradeJLTableViewCell.h"
#import "HBGetCListModel.h"
#import "HBGetC2CTradeListApi.h"
#import "EmptyManager.h"
#import "HBC2COrderModel.h"
#import "UIView+WZB.h"
#import "PayModel.h"
#import "HBC2COrderModel.h"
#import "LDYSelectivityTableViewCell.h"
#import "LDYSelectivityTypeTableViewCell.h"
#import "EmptyManager.h"
#import "TPOTCPayWayBankController.h"
#import "TPOTCPayWayBankController.h"
#import "TPOTCPayWayNoBankAddController.h"
#import "PaymentMethodView.h"

@interface HBTradeJLViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource,PaymentMethodViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)HBGetC2CTradeListApi *api;
@property (nonatomic,strong)NSMutableArray *list;
@property(nonatomic,strong)UIView *popPayModeView;
@property(nonatomic,strong)UIView *popPayModeView2;
@property(nonatomic,strong)UIView *popPayModeView3;
@property(nonatomic,strong)HBC2COrderModel *orderModel;
@property(nonatomic,strong)UIImageView *qrcode;
//
//选择试图
@property (nonatomic, strong) NSArray *datas;//数据源
@property (nonatomic, assign) BOOL ifSupportMultiple;//是否支持多选功能
@property (nonatomic, assign) NSIndexPath *selectIndexPath;//选择项的下标(单选)
@property (nonatomic, strong) NSMutableArray *selectArray;//选择项的下标数组(多选)
@property (nonatomic, strong) PayModel *paymodel;
@property (nonatomic, strong) NSString *payFlag;
@property (nonatomic, strong) UIButton *bankBtn;
@property (nonatomic, strong) UIButton *alipayBtn;
@property (nonatomic, strong) UIButton *wechatBtn;
@property(nonatomic,strong)UIView *selectPayModeView;
@property (nonatomic, strong) UITableView *selectTableView;//选择列表
@property(nonatomic,strong)UIView *addView;
//参数传递
@property(nonatomic,strong)NSString *sellUnitPrice;
@property(nonatomic,strong)NSString *sellNumber;
@property(nonatomic,strong)NSString *cuid;
@property(nonatomic,strong)NSString *payment;
//
@property (nonatomic, strong) PaymentMethodView *qrView;
@property (nonatomic, strong) PaymentMethodView *qrView1;
@end

@implementation HBTradeJLViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_popview_3");
    self.view.backgroundColor = kColorFromStr(@"#0B132A");
    [self.tableview registerNib:[UINib nibWithNibName:@"HBTradeJLTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HBTradeJLTableViewCell class])];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        lang = KoreanLanage;
    }else if ([currentLanguage containsString:Japanese]){//繁体
        lang = Japanese;
    }else{//泰文
        lang = ThAI;
    }
    self.api  = [[HBGetC2CTradeListApi alloc]initWithType:kUserInfo.token tokid:kUserInfo.user_id lanage:lang];
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];
    
    self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api loadNextPage];
    }];
    [self.tableview.mj_header beginRefreshing];
   
    self.payFlag = @"0";
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.selectTableView) {
        return 1;
    }else{
        return self.list.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.selectTableView) {
        if ([self.payFlag isEqualToString:@"0"]) {
            return self.paymodel.yinhang.count;
        }else if ([self.payFlag isEqualToString:@"1"]){
            return self.paymodel.alipay.count;
        }else{
            return self.paymodel.wechat.count;
        }
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.selectTableView) {
        
        if ([self.payFlag isEqualToString:@"0"]) {
            LDYSelectivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDYSelectivityTableViewCell class])];
            if (self.ifSupportMultiple == NO) {
                if (self.selectIndexPath == indexPath) {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_select"];
                }else{
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_normal"];
                }
            }else{
                if ([self.selectArray containsObject:@(indexPath.row)]) {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_select"];
                }else {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_normal"];
                }
            }
            bankModel *model = [self.paymodel.yinhang objectAtIndex:indexPath.row];
            [cell refreshWithModel:model];
            return cell;
        }else if ([self.payFlag isEqualToString:@"1"]){
            LDYSelectivityTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDYSelectivityTypeTableViewCell class])];
            if (self.ifSupportMultiple == NO) {
                if (self.selectIndexPath == indexPath) {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_select"];
                }else{
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_normal"];
                }
            }else{
                if ([self.selectArray containsObject:@(indexPath.row)]) {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_select"];
                }else {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_normal"];
                }
            }
            AlipayModel *model = [self.paymodel.alipay objectAtIndex:indexPath.row];
            [cell refreshWithModel:model];
            return cell;
        }else{
            LDYSelectivityTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDYSelectivityTypeTableViewCell class])];
            if (self.ifSupportMultiple == NO) {
                if (self.selectIndexPath == indexPath) {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_select"];
                }else{
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_normal"];
                }
            }else{
                if ([self.selectArray containsObject:@(indexPath.row)]) {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_select"];
                }else {
                    cell.selectIV.image = [UIImage imageNamed:@"selectpaymode_normal"];
                }
            }
            WechatModel *model = [self.paymodel.wechat objectAtIndex:indexPath.row];
            [cell refreshWithModel:model];
            return cell;
        }
    }else{
        HBTradeJLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HBTradeJLTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HBGetCListModel *model = [self.list objectAtIndex:indexPath.section];
        cell.pay = ^{
            if ([model.type isEqualToString:@"1"]) {
                [self getOrderId:model.id];
            }else{
//                self.sellUnitPrice = model.price;
//                self.sellNumber = model.number;
//                self.cuid = model.currency_id;
//                self.payment = model.id;
//                [self getBankList];
            }
        };
        [cell refreshWithModel:model];
        return cell;
    }
}

- (void)getBankList{
    NSString *path;
    path = @"Api/Bank/index";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = kUserInfo.user_id;
    param[@"key"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:path] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        if (success) {
            PayModel *model = [PayModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            self.paymodel = model;
            if (self.paymodel.yinhang.count <= 0 && self.paymodel.alipay.count <= 0 && self.paymodel.wechat.count <= 0) {
                [[EmptyManager sharedManager]showEmptyOnView:self.selectTableView withImage:nil explain:kLocat(@"k_popview_input_branchbank_confirm_noadd") operationText:nil operationBlock:nil];
                [self.selectTableView reloadData];
                [self toSelectPayModeView];
            }else{
                [[EmptyManager sharedManager] removeEmptyFromView:self.selectTableView];
                [self.selectTableView reloadData];
                [self toSelectPayModeView];
            }
            
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)toSelectPayModeView{
    [UIView animateWithDuration:0.25 animations:^{
        self.selectPayModeView.y = 227;
        self.enablePanGesture = NO;
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.selectTableView) {
        return 44;
    }else{
        return 211;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.selectTableView) {
        if (@available(iOS 11.0, *)) {
            return 0.01;
        }else{
            return 0.01;
        }
    }else{
        if (@available(iOS 11.0, *)) {
            return 5;
        }else{
            return 5;
        }
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.selectTableView) {
        if (self.ifSupportMultiple == NO) {
            self.selectIndexPath = indexPath;
            if ([self.payFlag isEqualToString:@"0"]) {
                if (self.selectIndexPath) {
                    bankModel *model = [self.paymodel.yinhang objectAtIndex:indexPath.row];
                    self.payment = model.id;
                }else{
                    for (bankModel *model in self.paymodel.yinhang) {
                        if ([model.status isEqualToString:@"1"]) {
                            self.payment = model.id;
                        }
                    }
                }
                
            }else if ([self.payFlag isEqualToString:@"1"]){
                if (self.selectIndexPath) {
                    AlipayModel *model = [self.paymodel.alipay objectAtIndex:indexPath.row];
                    self.payment = model.id;
                }else{
                    for (AlipayModel *model in self.paymodel.alipay) {
                        if ([model.status isEqualToString:@"1"]) {
                            self.payment = model.id;
                        }
                    }
                }
                
            }else{
                if (self.selectIndexPath) {
                    WechatModel *model = [self.paymodel.wechat objectAtIndex:indexPath.row];
                    self.payment = model.id;
                }else{
                    for (WechatModel *model in self.paymodel.wechat) {
                        if ([model.status isEqualToString:@"1"]) {
                            self.payment = model.id;
                        }
                    }
                }
            }
            [tableView reloadData];
        }else{
        }
    }

}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    NSArray *array = responsObject;
    if (array.count <= 0) {
        
    } else {
        self.tableview.tableFooterView = nil;
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:array];
        [self.tableview reloadData];
    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    //    [self showTips:command.response.msg];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    if (self.list.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ListModel *model = [self.infoList objectAtIndex:indexPath.row];
//    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/%@",kBasePath,icon_info_currency,model.currency_id]];
//    //                vc.showNaviBar = YES;
//    kNavPush(vc);
//}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.tableview.mj_footer endRefreshing];
    [self.list addObjectsFromArray:responsObject];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


-(UIView *)popPayModeView
{
    if (_popPayModeView == nil) {
        UIView *addView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH )];
        
        [self.navigationController.view addSubview:addView];
        
        addView.backgroundColor = kColorFromStr(@"#F4F4F4");
        kViewBorderRadius(addView, 10, 0, kRedColor);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:kLocat(@"k_popview_input_branchbank_confirm_carnumber") font:PFRegularFont(17) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel];
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 50, 50)];
        [cancelButton setImage:kImageFromStr(@"gb_icon") forState:UIControlStateNormal];
        [addView addSubview:cancelButton];
        cancelButton.right = kScreenW;
        cancelButton.centerY = titleLabel.centerY;
        __weak typeof(self)weakSelf = self;
        
        [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [UIView animateWithDuration:0.25 animations:^{
                sender.superview.y = kScreenH;
                weakSelf.enablePanGesture = YES;
            }];
        }];
        UILabel *titleLabel0 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel.frame)+20, kScreenW - 24, 16) text:kLocat(@"k_popview_input_branchbank_confirm_Tips01") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel0];
        NSArray *dataArr;
        //银行卡
        dataArr = @[kLocat(@"k_popview_input_name"),self.orderModel.pay_info.truename,kLocat(@"k_popview_input_bank"), self.orderModel.pay_info.name,kLocat(@"k_popview_input_branchbank"),self.orderModel.pay_info.bankadd, kLocat(@"k_popview_select_paywechat_rece_accoun"),[NSString stringWithFormat:@"%@    %@",self.orderModel.pay_info.bankcard,kLocat(@"OTC_copySuccess_copy")],kLocat(@"k_popview_input_branchbank_confirm_order"),self.orderModel.pay_info.money,kLocat(@"k_popview_input_branchbank_confirm_ordernote"),self.orderModel.pay_info.order_sn,kLocat(@"k_popview_input_branchbank_confirm_orderstatus"),kLocat(@"k_popview_input_branchbank_confirm_wailttopay")];
        [addView wzb_drawListWithRect:CGRectMake(10, CGRectGetMaxY(titleLabel0.frame)+20, kScreenW - 20, 185) line:2 columns:7 datas:dataArr colorInfo:@{@"13" : [UIColor redColor],@"11" : [UIColor redColor],@"11" : [UIFont systemFontOfSize:16]}];
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel0.frame)+20+200, 200, 16) text:kLocat(@"k_popview_input_branchbank_confirm_Tips02") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel1];
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel1.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips03") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel2];
        
        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel2.frame), kScreenW - 24, 40) text:kLocat(@"k_popview_input_branchbank_confirm_Tips04") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        titleLabel3.numberOfLines = 0;
        [addView addSubview:titleLabel3];
        
        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel3.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips05") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel4];
        
        UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
        surebutton.backgroundColor = kColorFromStr(@"#4173C8");
        [surebutton setTitle:kLocat(@"k_popview_select_paywechat_edit_sure") forState:UIControlStateNormal];
        [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addView addSubview:surebutton];
        [surebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-32);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];
        surebutton.layer.cornerRadius = 50/2;
        surebutton.layer.masksToBounds = YES;
        [surebutton addTarget:self action:@selector(tosure:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.orderModel.pay_info.bankcard;
            [[UIApplication sharedApplication].keyWindow showWarning:kLocat(@"OTC_copySuccess")];
        }];
        [addView addGestureRecognizer:tap];
        _popPayModeView = addView;
    }
    return _popPayModeView;
}


-(UIView *)popPayModeView2
{
        UIView *addView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH )];
        [self.navigationController.view addSubview:addView];
        addView.backgroundColor = kColorFromStr(@"#F4F4F4");
        kViewBorderRadius(addView, 10, 0, kRedColor);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:kLocat(@"k_popview_input_branchbank_confirm_carnumber") font:PFRegularFont(17) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel];
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 50, 50)];
        [cancelButton setImage:kImageFromStr(@"gb_icon") forState:UIControlStateNormal];
        [addView addSubview:cancelButton];
        cancelButton.right = kScreenW;
        cancelButton.centerY = titleLabel.centerY;
        __weak typeof(self)weakSelf = self;

        [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [UIView animateWithDuration:0.25 animations:^{
                sender.superview.y = kScreenH;
                weakSelf.enablePanGesture = YES;
            }];
        }];

        UILabel *titleLabel0 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel.frame)+20, 200, 16) text:kLocat(@"k_popview_input_branchbank_confirm_Tips01") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel0];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12, CGRectGetMaxY(titleLabel0.frame)+5, 100, 40);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gmxq_icon_zfb"] forState:UIControlStateNormal];
        [button setTitle:kLocat(@"k_popview_select_payalipay") forState:UIControlStateNormal];
        [addView addSubview:button];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(button.frame)+10, kScreenW - 24, 40)];
        contentView.backgroundColor = [UIColor blackColor];
        [addView addSubview:contentView];

        UILabel *accLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 120, 40) text:self.orderModel.pay_info.username font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [contentView addSubview:accLabel];
        UILabel *accNameLabel = [[UILabel alloc] initWithFrame:kRectMake(CGRectGetMaxX(accLabel.frame), 0, 120, 40) text:self.orderModel.pay_info.username font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        accLabel.userInteractionEnabled = YES;
        [contentView addSubview:accNameLabel];
//        UITapGestureRecognizer*tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveImg:)];

    UIButton *rightImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightImg setBackgroundImage:[UIImage imageNamed:@"shou_icon_ewm"] forState:UIControlStateNormal];
    [contentView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    [rightImg addTarget:self action:@selector(toSee) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(contentView.frame)+5, kScreenW-24, 20)];
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.textColor = kColorFromStr(@"#666666");
    noteLabel.font = [UIFont systemFontOfSize:14.0f];
    NSString *tempstr = [NSString stringWithFormat:@"%@%@%@",kLocat(@"k_in_c2c_tips_beizhu01"),self.orderModel.pay_info.order_sn,kLocat(@"k_in_c2c_tips_beizhu02")];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempstr];
    [str addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#BD2D36") range:NSMakeRange(7,6)];
    noteLabel.attributedText = str;
    [addView addSubview:noteLabel];
    
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(noteLabel.frame)+5, kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips02") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel1];
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel1.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips03") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel2];

        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel2.frame), kScreenW - 24, 40) text:kLocat(@"k_popview_input_branchbank_confirm_Tips04") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        titleLabel3.numberOfLines = 0;
        [addView addSubview:titleLabel3];

        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel3.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips05") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel4];

        UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
        surebutton.backgroundColor = kColorFromStr(@"#4173C8");
        [surebutton setTitle:kLocat(@"k_popview_select_paywechat_edit_sure") forState:UIControlStateNormal];
        [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addView addSubview:surebutton];
        [surebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-32);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];
        surebutton.layer.cornerRadius = 50/2;
        surebutton.layer.masksToBounds = YES;
        [surebutton addTarget:self action:@selector(tosure1:) forControlEvents:UIControlEventTouchUpInside];
    
    self.qrView = [[PaymentMethodView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, kScreenH) qrcode:self.orderModel.pay_info.qrcode];
    _qrView.delegate = self;
    [addView addSubview:self.qrView];
    
        _popPayModeView2 = addView;
    return _popPayModeView2;
}


-(UIView *)popPayModeView3
{
        UIView *addView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH )];
        [self.navigationController.view addSubview:addView];
        addView.backgroundColor = kColorFromStr(@"#F4F4F4");
        kViewBorderRadius(addView, 10, 0, kRedColor);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:kLocat(@"k_popview_input_branchbank_confirm_carnumber") font:PFRegularFont(17) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel];
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 50, 50)];
        [cancelButton setImage:kImageFromStr(@"gb_icon") forState:UIControlStateNormal];
        [addView addSubview:cancelButton];
        cancelButton.right = kScreenW;
        cancelButton.centerY = titleLabel.centerY;
        __weak typeof(self)weakSelf = self;
        
        [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [UIView animateWithDuration:0.25 animations:^{
                sender.superview.y = kScreenH;
                weakSelf.enablePanGesture = YES;
            }];
        }];
        
        UILabel *titleLabel0 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel.frame)+20, kScreenW - 24, 16) text:kLocat(@"k_popview_input_branchbank_confirm_Tips01") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel0];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12, CGRectGetMaxY(titleLabel0.frame)+5, 100, 40);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gmxq_icon_wx"] forState:UIControlStateNormal];
        [button setTitle:kLocat(@"k_popview_select_paywechat") forState:UIControlStateNormal];
        [addView addSubview:button];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(button.frame)+10, kScreenW - 24, 40)];
        contentView.backgroundColor = [UIColor blackColor];
        [addView addSubview:contentView];
        
        UILabel *accLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 120, 40) text:self.orderModel.pay_info.username font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [contentView addSubview:accLabel];
        UILabel *accNameLabel = [[UILabel alloc] initWithFrame:kRectMake(CGRectGetMaxX(accLabel.frame), 0, 120, 40) text:self.orderModel.pay_info.username font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        accLabel.userInteractionEnabled = YES;
        [contentView addSubview:accNameLabel];
//        UITapGestureRecognizer*tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveImg:)];
    
    UIButton *rightImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightImg setBackgroundImage:[UIImage imageNamed:@"shou_icon_ewm"] forState:UIControlStateNormal];
    [contentView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    [rightImg addTarget:self action:@selector(toSee1) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(contentView.frame)+5, kScreenW-24, 20)];
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.textColor = kColorFromStr(@"#666666");
    noteLabel.font = [UIFont systemFontOfSize:14.0f];
    NSString *tempstr = [NSString stringWithFormat:@"%@%@%@",kLocat(@"k_in_c2c_tips_beizhu01"),self.orderModel.pay_info.order_sn,kLocat(@"k_in_c2c_tips_beizhu02")];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempstr];
    [str addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#BD2D36") range:NSMakeRange(7,6)];
    noteLabel.attributedText = str;
    [addView addSubview:noteLabel];

        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(noteLabel.frame)+5, 200, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips02") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel1];
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel1.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips03") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel2];
        
        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel2.frame), kScreenW - 24, 40) text:kLocat(@"k_popview_input_branchbank_confirm_Tips04") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        titleLabel3.numberOfLines = 0;
        [addView addSubview:titleLabel3];
        
        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel3.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips05") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel4];
        
        UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
        surebutton.backgroundColor = kColorFromStr(@"#4173C8");
        [surebutton setTitle:kLocat(@"k_popview_select_paywechat_edit_sure") forState:UIControlStateNormal];
        [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addView addSubview:surebutton];
        [surebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-32);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(50);
        }];
        surebutton.layer.cornerRadius = 50/2;
        surebutton.layer.masksToBounds = YES;
        [surebutton addTarget:self action:@selector(tosure1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.qrView1 = [[PaymentMethodView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, kScreenH) qrcode:self.orderModel.pay_info.qrcode];
    _qrView1.delegate = self;
    [addView addSubview:self.qrView1];
        _popPayModeView3 = addView;
       return _popPayModeView3;
}


-(void)addPayModeAction
{
    [UIView animateWithDuration:0.25 animations:^{
        self.popPayModeView.y = kStatusBarHeight;
        self.enablePanGesture = NO;
    }];
}

-(void)addPayModeAction2
{
    [UIView animateWithDuration:0.25 animations:^{
        self.popPayModeView2.y = kStatusBarHeight;
        self.enablePanGesture = NO;
    }];
}

-(void)addPayModeAction3
{
    [UIView animateWithDuration:0.25 animations:^{
        self.popPayModeView3.y = kStatusBarHeight;
        self.enablePanGesture = NO;
    }];
}

- (void)tosure1:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.y = kScreenH;
        self.enablePanGesture = YES;
    }];
}

- (void)tosure:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.y = kScreenH;
        self.enablePanGesture = YES;
    }];
}

- (void)getOrderId:(NSString *)orderid{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        lang = KoreanLanage;
    }else if ([currentLanguage containsString:Japanese]){//繁体
        lang = Japanese;
    }else{//泰文
        lang = ThAI;
    }
    param[@"language"] = lang;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"key"] = kUserInfo.token;
    param[@"id"] = orderid;
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/getCPayInfo"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        kHideHud;
        if (success) {
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
            self.orderModel = [HBC2COrderModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            if ([self.orderModel.pay_info.pay_type isEqualToString:@"1"]) {
                [self addPayModeAction];
            }else if ([self.orderModel.pay_info.pay_type isEqualToString:@"2"]) {
                [self addPayModeAction2];
            }else if ([self.orderModel.pay_info.pay_type isEqualToString:@"3"]) {
                [self addPayModeAction3];
            }
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)saveImg:(UITapGestureRecognizer *)ges{
    UIAlertController *con = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存图片" preferredStyle:1];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_sure") style:0 handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.qrcode.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),NULL); // 写入相册
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_cancel") style:0 handler:nil];
           [con addAction:action];
    [con addAction:action1];
    [self presentViewController:con animated:YES completion:nil];
    
}

- (UIView *)selectPayModeView{
    if (_selectPayModeView == nil) {
        UIView *addView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH )];
        [self.navigationController.view addSubview:addView];
        
        addView.backgroundColor = kColorFromStr(@"#F4F4F4");
        kViewBorderRadius(addView, 10, 0, kRedColor);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:kLocat(@"k_popview_select_paymode") font:PFRegularFont(17) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 50, 50)];
        [cancelButton setImage:kImageFromStr(@"gb_icon") forState:UIControlStateNormal];
        [addView addSubview:cancelButton];
        cancelButton.right = kScreenW;
        cancelButton.centerY = titleLabel.centerY;
        __weak typeof(self)weakSelf = self;
        
        [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [UIView animateWithDuration:0.25 animations:^{
                sender.superview.y = kScreenH;
                weakSelf.enablePanGesture = YES;
            }];
        }];
        
        self.bankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bankBtn setTitle:kLocat(@"k_popview_select_paybank") forState:UIControlStateNormal];
        [self.bankBtn setTitleColor:kColorFromStr(@"#E96E44") forState:UIControlStateNormal];
        self.bankBtn.frame = CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+10, 60, 40);
        [self.bankBtn addTarget:self action:@selector(bankListAction:) forControlEvents:UIControlEventTouchUpInside];
        [addView addSubview:self.bankBtn];
        
        self.alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alipayBtn setTitle:kLocat(@"k_popview_select_payalipay") forState:UIControlStateNormal];
        [self.alipayBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
        self.alipayBtn.frame = CGRectMake(CGRectGetMaxX(self.bankBtn.frame), CGRectGetMaxY(titleLabel.frame)+10, 60, 40);
        [self.alipayBtn addTarget:self action:@selector(alipayListAction:) forControlEvents:UIControlEventTouchUpInside];
        [addView addSubview:self.alipayBtn];
        
        self.wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.wechatBtn setTitle:kLocat(@"k_popview_select_paywechat") forState:UIControlStateNormal];
        [self.wechatBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
        self.wechatBtn.frame = CGRectMake(CGRectGetMaxX(self.alipayBtn.frame), CGRectGetMaxY(titleLabel.frame)+10, 60, 40);
        [self.wechatBtn addTarget:self action:@selector(wechatListAction:) forControlEvents:UIControlEventTouchUpInside];
        [addView addSubview:self.wechatBtn];
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.alipayBtn.frame)+10, kScreenW, 1)];
        lineview.backgroundColor = kColorFromStr(@"#DEDEDE");
        [addView addSubview:lineview];
        self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineview.frame), kScreenW - 40, kScreenH - 227- 80 - 60- 30) style:UITableViewStylePlain];
        self.selectTableView.delegate = self;
        self.selectTableView.dataSource = self;
        self.selectTableView.showsVerticalScrollIndicator = NO;
        [self.selectTableView registerClass:[LDYSelectivityTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LDYSelectivityTableViewCell class])];
        [self.selectTableView registerClass:[LDYSelectivityTypeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LDYSelectivityTypeTableViewCell class])];
        //        self.ifSupportMultiple = ifSupportMultiple;
        self.selectTableView.backgroundColor = kColorFromStr(@"#F4F4F4");
        self.selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        self.datas = datas;
        self.ifSupportMultiple = NO;
        if (self.ifSupportMultiple == YES){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [self.selectTableView addGestureRecognizer:tap];
            [tap addTarget:self action:@selector(clickTableView:)];
        }
        
        [addView addSubview:self.selectTableView];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.backgroundColor = kColorFromStr(@"#4173C8");
        [confirmBtn setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateNormal];
        confirmBtn.frame = CGRectMake(20, CGRectGetMaxY(self.selectTableView.frame)+10, 150, 45);
        confirmBtn.layer.cornerRadius = 8;
        confirmBtn.layer.masksToBounds = YES;
        [addView addSubview:confirmBtn];
        
        if (self.paymodel.yinhang.count <= 0 && self.paymodel.alipay.count <= 0 && self.paymodel.wechat.count <= 0) {
            [confirmBtn setTitle:kLocat(@"k_popview_list_counter_emptyData") forState:UIControlStateNormal];
        }else{
            [confirmBtn setTitle:kLocat(@"k_popview_list_counter_confirmOrder") forState:UIControlStateNormal];
        }
        [confirmBtn addTarget:self action:@selector(confirmOrder:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = kColorFromStr(@"#CCCCCC");
        [cancelBtn setTitle:kLocat(@"k_popview_select_paywechat_edit_cancel") forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(kScreenW/2+23, CGRectGetMaxY(self.selectTableView.frame)+10, 150, 45);
        cancelBtn.layer.cornerRadius = 8;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn addTarget:self action:@selector(canOrder:) forControlEvents:UIControlEventTouchUpInside];
        [addView addSubview:cancelBtn];
        _selectPayModeView = addView;
        
    }
    return _selectPayModeView;
    
}

- (void)bankListAction:(UIButton *)sender{
    self.payFlag = @"0";
    self.selectIndexPath = nil;
    [sender setTitleColor:kColorFromStr(@"#E96E44") forState:UIControlStateNormal];
    [self.alipayBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.selectTableView reloadData];
}

- (void)alipayListAction:(UIButton *)sender{
    self.payFlag = @"1";
    self.selectIndexPath = nil;
    [sender setTitleColor:kColorFromStr(@"#E96E44") forState:UIControlStateNormal];
    [self.bankBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.selectTableView reloadData];
}

- (void)wechatListAction:(UIButton *)sender{
    self.payFlag = @"2";
    self.selectIndexPath = nil;
    [sender setTitleColor:kColorFromStr(@"#E96E44") forState:UIControlStateNormal];
    [self.bankBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.alipayBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.selectTableView reloadData];
}

- (void)canOrder:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.y = kScreenH;
        self.enablePanGesture = YES;
    }];
}

- (void)confirmOrder:(UIButton *)sender{
    if (self.selectIndexPath == nil) {
        [self.selectTableView showWarning:kLocat(@"k_popview_select_paymode")];
        //         showTips:kLocat(@"k_popview_select_paymode")];
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.y = kScreenH;
        self.enablePanGesture = YES;
    }];
    if (self.paymodel.yinhang.count <= 0 && self.paymodel.alipay.count <= 0 && self.paymodel.wechat.count <= 0) {
        [self addAction];
    }else{
        [self toPay];
    }
}

-(void)addAction
{
    [UIView animateWithDuration:0.25 animations:^{
        self.addView.y = kStatusBarHeight;
        self.enablePanGesture = NO;
    }];
    
}


-(UIView *)addView
{
    if (_addView == nil) {
        UIView *addView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH )];
        
        [self.navigationController.view addSubview:addView];
        
        addView.backgroundColor = kColorFromStr(@"#F4F4F4");
        kViewBorderRadius(addView, 10, 0, kRedColor);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:kLocat(@"k_popview_select_paymode") font:PFRegularFont(17) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 50, 50)];
        [cancelButton setImage:kImageFromStr(@"gb_icon") forState:UIControlStateNormal];
        [addView addSubview:cancelButton];
        cancelButton.right = kScreenW;
        cancelButton.centerY = titleLabel.centerY;
        __weak typeof(self)weakSelf = self;
        
        [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [UIView animateWithDuration:0.25 animations:^{
                sender.superview.y = kScreenH;
                weakSelf.enablePanGesture = YES;
            }];
        }];
        
        UIButton *bankButton = [[UIButton alloc] initWithFrame:kRectMake(12, 50, kScreenW - 24, 55) title:kLocat(@"k_popview_select_paybank") titleColor:kColorFromStr(@"#434C63") font:PFRegularFont(16) titleAlignment:0];
        [addView addSubview:bankButton];
        bankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, bankButton.bottom, bankButton.width, 0.5)];
        lineView.backgroundColor = kColorFromStr(@"#D6D6D6");
        [addView addSubview:lineView];
        
        UIButton *zfbButton = [[UIButton alloc] initWithFrame:kRectMake(12, lineView.bottom, kScreenW - 24, 55) title:kLocat(@"k_popview_select_payalipay") titleColor:kColorFromStr(@"#434C63") font:PFRegularFont(16) titleAlignment:0];
        [addView addSubview:zfbButton];
        zfbButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(12, zfbButton.bottom, zfbButton.width, 0.5)];
        lineView1.backgroundColor = kColorFromStr(@"#D6D6D6");
        [addView addSubview:lineView1];
        
        UIButton *wxButton = [[UIButton alloc] initWithFrame:kRectMake(12, lineView1.bottom, kScreenW - 24, 55) title:kLocat(@"k_popview_select_paywechat") titleColor:kColorFromStr(@"#434C63") font:PFRegularFont(16) titleAlignment:0];
        [addView addSubview:wxButton];
        wxButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(12, wxButton.bottom, wxButton.width, 0.5)];
        lineView2.backgroundColor = kColorFromStr(@"#D6D6D6");
        [addView addSubview:lineView2];
        
        bankButton.tag = 0;
        zfbButton.tag = 1;
        wxButton.tag = 2;
        [bankButton addTarget:self action:@selector(payWayAction:) forControlEvents:UIControlEventTouchUpInside];
        [zfbButton addTarget:self action:@selector(payWayAction:) forControlEvents:UIControlEventTouchUpInside];
        [wxButton addTarget:self action:@selector(payWayAction:) forControlEvents:UIControlEventTouchUpInside];
        _addView = addView;
    }
    return _addView;
}

-(void)payWayAction:(UIButton *)button
{
    [UIView animateWithDuration:0.25 animations:^{
        self.addView.y = kScreenH;
    }];
    
    self.enablePanGesture = YES;
    if (button.tag == 0) {
        TPOTCPayWayBankController *vc = [TPOTCPayWayBankController new];
        vc.isNew = YES;
        vc.type = TPOTCPayWayBankControllerTypeAdd;
        kNavPush(vc);
    }else if (button.tag == 1){
        TPOTCPayWayNoBankAddController *vc = [TPOTCPayWayNoBankAddController new];
        vc.isNew = YES;
        vc.type = TPOTCPayWayNoBankAddControllerTypeAddZFB;
        kNavPush(vc);
    }else{
        TPOTCPayWayNoBankAddController *vc = [TPOTCPayWayNoBankAddController new];
        vc.isNew = YES;
        vc.type = TPOTCPayWayNoBankAddControllerTypeAddWX;
        kNavPush(vc);
    }
    
}

- (void)toPay{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = kUserInfo.user_id;
    param[@"key"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    param[@"sellUnitPrice"] = self.sellUnitPrice;
    param[@"sellNumber"] = self.sellNumber;
    param[@"cuid"] = self.cuid;
    param[@"payment"] = self.payment;
    param[@"pay_type"] = self.payFlag;
    NSLog(@"%@",param);
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/addOrderSell"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        kHideHud;
        if (success) {
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


- (void)toSee{
    NSLog(@"1111111");
    __weak HBTradeJLViewController *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.qrView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)toSee1{
    NSLog(@"1111111");
    __weak HBTradeJLViewController *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.qrView1.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        
    }];
}




@end
