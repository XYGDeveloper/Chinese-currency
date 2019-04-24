//
//  HBOTCOrderStateTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/14.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBOTCTradeInfoDetailTableViewController.h"
#import "UIView+RoundCorner.h"
#import "HBOTCTradeInfoModel+Request.h"
#import "NSObject+SVProgressHUD.h"
#import "UIViewController+HBLoadingView.h"
#import "NSString+Operation.h"
#import "HBChatWebViewController.h"
#import "HBOTCOrderDetailAlertView.h"
#import "ZJPayPopupView.h"
#import "YWAlert.h"
#import "TPOTCAppealViewController.h"
#import "TPOTCQRViewController.h"

NSString *const HBOTCTradeInfoDetailTableViewControllerNeedRefreshKey = @"HBOTCTradeInfoDetailTableViewControllerNeedRefreshKey";

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeTopCorner,
    CellTypeAccount,
    CellTypeSelectPayMethod,
    CellTypeFee,
    CellTypeRealMoney,
    CellTypeBuyOrSellUserName,
    CellTypeReciveName,
    CellTypeAccountNumber,
    CellTypeBankInfoOrQR,
    CellTypeTime,
    CellTypeOrderNo,
    CellTypePayMethod,
    CellTypeRefNo,
    CellTypeMoneyType,
    CellTypeRemark,
    CellTypeBottomSeparateLine,
    CellTypeAlertMessage,
    CellTypeButtons,
    CellTypeBottomCorner,
    CellTypeTips,
};


@interface HBOTCTradeInfoDetailTableViewController () <HBOTCOrderDetailAlertViewDelegate, ZJPayPopupViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tipsContainerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *separateLineViews;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIStackView *chatStackView;
@property (weak, nonatomic) IBOutlet UILabel *statusDesLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *refNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payMethodIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;


//names
@property (weak, nonatomic) IBOutlet UILabel *sellerOrBuyerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qrOrBankInfoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankOrAccountNoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchBankTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyDesNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNumNameLabel;

@property (weak, nonatomic) IBOutlet UIStackView *timerStackView;

@property (nonatomic, strong) HBOTCTradeInfoModel *model;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIView *rightButtomView;

@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveNameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *refNoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactHeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchPayWayNameLabel;


@property (nonatomic, strong) HBOTCTradeBankModel *selectedBankModel;

//Other
@property (nonatomic, strong) UIButton *confirmCancelButton;
@property (nonatomic, assign) NSInteger countDownSecond;
@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, strong) HBOTCOrderDetailAlertView *tipsAlertView;
@property (nonatomic, strong) ZJPayPopupView *payPopupView;
@property (nonatomic, assign) BOOL isFirstAppear;

@end

@implementation HBOTCTradeInfoDetailTableViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"OTC" bundle:nil] instantiateViewControllerWithIdentifier:@"HBOTCTradeInfoDetailTableViewController"];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupUI];
    [self _firstLoadData];
    self.isFirstAppear = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_rqeuestTradeInfoModel) name:HBOTCTradeInfoDetailTableViewControllerNeedRefreshKey object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirstAppear) {
        self.isFirstAppear = NO;
    } else {
        [self _rqeuestTradeInfoModel];
    }
    
}


#pragma mark - Private

- (void)_setupUI {
    self.tableView.backgroundColor = kThemeColor;
    self.tipsContainerView.layer.borderWidth = 1.;
    self.tipsContainerView.layer.borderColor = kColorFromStr(@"#171F34").CGColor;
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kColorFromStr(@"#171F34");
    }];
    
    [self.separateLineViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    
    UIGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toChatVC)];
    [self.chatStackView addGestureRecognizer:tapGR];

    UIGestureRecognizer *rightButtonTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonViewAction)];
    [self.rightButtomView addGestureRecognizer:rightButtonTapGR];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_rqeuestTradeInfoModel)];
    
    //国际化
    self.priceNameLabel.text = kLocat(@"OTC_order_price");
    self.numberNameLabel.text = kLocat(@"OTC_order_dealvolume");
    self.feeNameLabel.text = kLocat(@"OTC_fee");
    self.receiveNameNameLabel.text = kLocat(@"OTC_buy_skr");
    self.timeNameLabel.text = kLocat(@"OTC_ordertime");
    self.orderNoNameLabel.text = kLocat(@"OTC_ordernumber");
    self.payMethodNameLabel.text = kLocat(@"OTC_order_payment");
    self.refNoNameLabel.text = kLocat(@"OTC_payreference");
    self.moneyTypeNameLabel.text = kLocat(@"k_popview_1");
    self.remarkNameLabel.text = kLocat(@"OTC_view_sellerremark");
    self.contactHeNameLabel.text = kLocat(@"OTC_order_contact");
    self.tipsNameLabel.text = kLocat(@"C_Tip");
    self.switchPayWayNameLabel.text = kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.Switch");
}

- (void)_updateUI {
    self.statusLabel.text = self.model.status_txt ?: @"--";
    self.statusDesLabel.text = self.model.status_txt_des ?: @"--";
    self.statusLabel.textColor = self.model.statusColor;
    self.orderNoLabel.text = [NSString stringWithFormat:@"#%@", self.model.only_number ?: @"--"];
    self.refNoLabel.text = self.model.pay_number;
    self.nameLabel.text = self.model.username;
    self.timeLabel.text = self.model.add_time;
    self.priceLabel.text = [self.model.price _addPreCNYSymbol];
    self.numberLabel.text = [self.model.num _addSuffix:self.model.currency_name];
    self.moneyLabel.text = [self.model.money _addPreCNYSymbol];
    self.feeLabel.text = [self.model.fee _addSuffix:self.model.currency_name];
    self.realNumLabel.text = [self.model.real_num _addSuffix:self.model.currency_name];
    self.moneyTypeLabel.text = self.model.moneyTypeString;
    self.moneyDesNameLabel.text = self.model.status_txt_type ?: @"--";
    self.sellerOrBuyerNameLabel.text = self.model.sellerOrBuyerString;
    self.remarkLabel.text = self.model.order_message ?: @"--";
    self.realNumNameLabel.text = self.model.isTypeOfBuy ? kLocat(@"OTC_order_Actual_arrival") : kLocat(@"OTC_order_Actual_deduct");
    
    [self _updateTipsLabel];
    [self _updateButtons];
    [self _updateAlertMessageLabel];
    [self _updatePayMethodLabel];
}

- (void)_updatePayMethodLabel {
    NSString *text = @"--";
    self.payMethodIconImageView.hidden = YES;
    if (self.model) {
        self.payMethodIconImageView.hidden = NO;
        text = self.model.moneyTypeString?: @"--";
        self.payMethodIconImageView.image = [UIImage imageNamed:self.model.moneyTypeIconString];
    }
    self.payMethodLabel.text = text;
}

- (void)_updateAlertMessageLabel {
    NSString *buyAlertMessage = kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.buyAlertMessage");
    NSString *sellAlertMessage = kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.sellAlertMessage");
    self.alertMessageLabel.text = self.model.isTypeOfBuy ? buyAlertMessage : sellAlertMessage;
}

- (void)_updateTipsLabel {
    NSString *buyTips = kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.buyTips");
    NSString *sellTips = kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.sellTips");
    NSString *tips = self.model.isTypeOfBuy ? buyTips : sellTips;
    self.tipsLabel.attributedText = [tips attributedStringWithParagraphSize:4.];
}

- (void)_updateButtons {
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    self.leftButton.backgroundColor = kColorFromStr(@"#37415C");
    self.leftButton.enabled = YES;
    self.rightButtomView.backgroundColor = kColorFromStr(@"#4173C8");
    self.rightButtomView.userInteractionEnabled = YES;
    switch (self.model.status) {
        case HBOTCTradeInfoModelStatusNotPay://未付款
            self.timerStackView.hidden = NO;
            self.countDownSecond = [self.model.limit_time integerValue];
            [self.countDownTimer invalidate];
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(_countDownAction) userInfo:nil repeats:YES];
            if (self.model.isTypeOfBuy) {//我是买家，leftButton:取消订单, rightButton: 我已付款 倒计时
                [self.leftButton setTitle:kLocat(@"OTC_order_cancelorder") forState:UIControlStateNormal];
                self.rightButtonLabel.text = kLocat(@"OTC_order_I_have_paid");
            } else {//我是卖家，leftButton:申诉, rightButton: 放行 倒计时
                [self.leftButton setTitle:kLocat(@"OTC_order_appleal") forState:UIControlStateNormal];
                self.rightButtonLabel.text = kLocat(@"OTC_order_discharged");//放行
                self.leftButton.enabled = NO;
                self.rightButtomView.userInteractionEnabled = NO;
                self.leftButton.backgroundColor = kColorFromStr(@"#CCCCCC");
                self.rightButtomView.backgroundColor = kColorFromStr(@"#CCCCCC");
            }
            break;
        case HBOTCTradeInfoModelStatusPaid://已付款，放行
            self.timerStackView.hidden = YES;
            if (self.model.isTypeOfBuy) {//我是买家，leftButton:取消订单, rightButton: 申诉
                [self.leftButton setTitle:kLocat(@"OTC_order_cancelorder") forState:UIControlStateNormal];
                self.rightButtonLabel.text = kLocat(@"OTC_order_appleal");
            } else {//我是卖家，leftButton:申诉, rightButton: 放行
                [self.leftButton setTitle:kLocat(@"OTC_order_appleal") forState:UIControlStateNormal];
                self.rightButtonLabel.text = [NSString stringWithFormat:@"%@ %@", kLocat(@"OTC_order_discharged"), self.model.currency_name ?: @"--"];
            }
            break;
        default:
            break;
    }
}

- (void)_firstLoadData {
    [self showLoadingView];
    [self _rqeuestTradeInfoModel];
}

- (void)_rqeuestTradeInfoModel {

    [HBOTCTradeInfoModel requestTradeInfoModelWithTradeID:self.tradeID success:^(HBOTCTradeInfoModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        self.model = model;
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self showInfoWithMessage:error.localizedDescription];
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Actions

- (void)_toChatVC {
    HBChatWebViewController *vc = [HBChatWebViewController new];
    vc.tradeID = self.tradeID;
    kNavPush(vc);
}

- (IBAction)leftButtonAction:(id)sender {
    switch (self.model.status) {
        case HBOTCTradeInfoModelStatusPaid:
        case HBOTCTradeInfoModelStatusNotPay:
            if (self.model.isTypeOfBuy) {//我是买家:取消订单
                [self _toCancel];
            } else {//我是卖家:申诉
                [self _toAppeal];
            }
            break;
        default:
            break;
    }
}



- (void)rightButtonViewAction {
    switch (self.model.status) {
        
        case HBOTCTradeInfoModelStatusNotPay:
            if (self.model.isTypeOfBuy) {//我是买家:我已付款
                [self _toIHavePaid];
            } else {//我是卖家:放行
                [self _toRelease];
            }
            break;
        case HBOTCTradeInfoModelStatusPaid:
            if (self.model.isTypeOfBuy) {//我是买家:申诉
                [self _toAppeal];
            } else {//我是卖家:放行
                [self _toRelease];
            }
            break;
        default:
            break;
    }
}

- (void)_toCancel {
    [self checkCancelTime];
}

- (void)_toAppeal {
    TPOTCAppealViewController *vc = [TPOTCAppealViewController new];
    vc.isBuy = self.model.isTypeOfBuy;
    vc.trade_id = self.tradeID;
    vc.appealWait = [self.model.appeal_wait integerValue];
    vc.appeal_minute = [self.model.appeal_minute integerValue];
    
    kNavPush(vc);
}

- (void)_toIHavePaid {
    [YWAlert alertWithTitle:kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.confirm_payment") message:nil sureAction:^{
        kShowHud;
        NSString *moneyType = [NSString stringWithFormat:@"%@:%@", self.selectedBankModel.bankname,  self.selectedBankModel.ID];
        [HBOTCTradeInfoModel requestPayTradeWithTradeID:self.tradeID moneyType:moneyType success:^(YWNetworkResultModel * _Nonnull obj) {
            [self.tableView.mj_header beginRefreshing];
            kHideHud;
        } failure:^(NSError * _Nonnull error) {
            kHideHud;
            [self showInfoWithMessage:error.localizedDescription];
        }];
    } cancelAction:nil inViewController:self];
    
}

- (void)_toRelease {
    [self.tipsAlertView showInWindow];
}

- (void)_showBanksSheetVC {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.model.bank_list enumerateObjectsUsingBlock:^(HBOTCTradeBankModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.bankTypeString) {
    
            NSString *title = [NSString stringWithFormat:@"%@(%@)", obj.bankTypeString, obj.last4CharactersOfCardNumber];
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.selectedBankModel = obj;
            }];
            [alertController addAction:action];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_countDownAction {
    self.countDownSecond--;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CellTypeSelectPayMethod: {
            [self _showBanksSheetVC];
             break;
        }
        case CellTypeBankInfoOrQR: {
            if (self.selectedBankModel && !self.selectedBankModel.isYHK) {
                TPOTCQRViewController *vc = [TPOTCQRViewController new];
                vc.qrString = self.selectedBankModel.img;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case CellTypeReciveName:
            [self _copyString:self.selectedBankModel.truename];
            break;
        case CellTypeAccountNumber:
            [self _copyString:self.selectedBankModel.cardnum];
            break;
        case CellTypeOrderNo:
            [self _copyString:self.model.only_number];
            break;
        case CellTypeRefNo:
            [self _copyString:self.model.pay_number];
            break;
        default:
            break;
    }
}

- (void)_copyString:(NSString *)string {
    if (string.length == 0) {
        return;
    }
    [UIPasteboard generalPasteboard].string = string;
    [self showSuccessWithMessage:kLocat(@"Copied")];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.model.status) {
        case HBOTCTradeInfoModelStatusNotPay: {
            return [self _tableView:tableView heightForNotPayRowAtIndexPath:indexPath];
            break ;
        }
        case HBOTCTradeInfoModelStatusPaid: {
            return [self _tableView:tableView heightForPaidRowAtIndexPath:indexPath];
            break ;
        }
        case HBOTCTradeInfoModelStatusDone:
            if (_model.allege_status == 0 || _model.allege_status == 1) {//胜诉 或 败诉
                return [self _tableView:tableView heightForAppealRowAtIndexPath:indexPath];
            }
            return [self _tableView:tableView heightForDoneRowAtIndexPath:indexPath];
            break;
            
        case HBOTCTradeInfoModelStatusCancel:
            if (_model.allege_status == 0 || _model.allege_status == 1) {//胜诉 或 败诉
                return [self _tableView:tableView heightForAppealRowAtIndexPath:indexPath];
            }
            return [self _tableView:tableView heightForCancelRowAtIndexPath:indexPath];
            break;
            
        case HBOTCTradeInfoModelStatusAppeal:
            return [self _tableView:tableView heightForAppealRowAtIndexPath:indexPath];
            break;
        default:
            return [self _tableView:tableView heightForCancelRowAtIndexPath:indexPath];
            break;
    }
    
}

- (CGFloat)_tableView:(UITableView *)tableView heightForNotPayRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case CellTypeFee:
        case CellTypeRealMoney:
        case CellTypeMoneyType:
            return 0;
            break;
            
        default:
            break;
    }
    
    if (self.model.isTypeOfBuy) {//我是买家
        switch (indexPath.row) {
            case CellTypeReciveName:
                if (!self.selectedBankModel.isYHK) {
                    return 0.;
                }
                break;
            case CellTypeTime:
            case CellTypeOrderNo:
            case CellTypePayMethod:
                return 0.;
                break;
            default:
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
                break;
        }
    } else {//我是卖家
        switch (indexPath.row) {
            case CellTypeSelectPayMethod:
            case CellTypeRemark:
            case CellTypeAccountNumber:
            case CellTypeReciveName:
            case CellTypeBankInfoOrQR:
                return 0.;
                break;
            default:
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
                break;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)_tableView:(UITableView *)tableView heightForPaidRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.model.isTypeOfBuy) {//我是买家
        switch (indexPath.row) {
            case CellTypeFee:
            case CellTypeRealMoney:
            case CellTypeMoneyType:
            case CellTypePayMethod:
            case CellTypeAlertMessage:
            case CellTypeSelectPayMethod:
            case CellTypeRemark:
            case CellTypeAccountNumber:
            case CellTypeReciveName:
            case CellTypeBankInfoOrQR:
                return 0.;
                break;
            default:
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
                break;
        }
    } else {//我是卖家
        switch (indexPath.row) {
            case CellTypeFee:
            case CellTypeRealMoney:
            case CellTypeMoneyType:
            case CellTypeSelectPayMethod:
            case CellTypeRemark:
            case CellTypeAccountNumber:
            case CellTypeReciveName:
            case CellTypeBankInfoOrQR:
                return 0.;
                break;
            default:
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
                break;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)_tableView:(UITableView *)tableView heightForDoneRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CellTypeTips:
        case CellTypeButtons:
        case CellTypeBottomSeparateLine:
        case CellTypePayMethod:
        case CellTypeAlertMessage:
        case CellTypeSelectPayMethod:
        case CellTypeRemark:
        case CellTypeAccountNumber:
        case CellTypeReciveName:
        case CellTypeBankInfoOrQR:
            return 0.;
            break;
        default:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            break;
    }
}

- (CGFloat)_tableView:(UITableView *)tableView heightForCancelRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CellTypeFee:
        case CellTypeRealMoney:
        case CellTypeMoneyType:
        case CellTypeTips:
        case CellTypeButtons:
        case CellTypeBottomSeparateLine:
        case CellTypePayMethod:
        case CellTypeAlertMessage:
        case CellTypeSelectPayMethod:
        case CellTypeRemark:
        case CellTypeAccountNumber:
        case CellTypeReciveName:
        case CellTypeBankInfoOrQR:
            return 0.;
            break;
        default:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            break;
    }
}

- (CGFloat)_tableView:(UITableView *)tableView heightForAppealRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CellTypePayMethod:
            if (self.model.isTypeOfBuy) {
                return 0.;
            } else {
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            }
            break;
        case CellTypeFee:
        case CellTypeRealMoney:
        case CellTypeMoneyType:
        case CellTypeButtons:
        case CellTypeBottomSeparateLine:
        case CellTypeAlertMessage:
        case CellTypeSelectPayMethod:
        case CellTypeRemark:
        case CellTypeAccountNumber:
        case CellTypeReciveName:
        case CellTypeBankInfoOrQR:
            return 0.;
            break;
        default:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            break;
    }
}

#pragma mark - Setter & Getters

- (void)setModel:(HBOTCTradeInfoModel *)model {
    _model = model;
    if (!self.selectedBankModel) {
         self.selectedBankModel = model.bank_list.firstObject;
    }
   
    [self _updateUI];
    [self.tableView reloadData];
}

- (void)setSelectedBankModel:(HBOTCTradeBankModel *)selectedBankModel {
    _selectedBankModel = selectedBankModel;
    
    self.bankIconImageView.image = [UIImage imageNamed:_selectedBankModel.bankIconString];
    self.bankTypeLabel.text = _selectedBankModel.bankTypeString ?: @"--";
    self.accountNoLabel.text = _selectedBankModel.cardnum ?: @"--";
    self.bankInfoLabel.text = _selectedBankModel.bname ?: @"--";
    self.receiveNameLabel.text = _selectedBankModel.truename ?: @"--";
    self.bankInfoLabel.hidden = !_selectedBankModel.isYHK;
    self.qrImageView.hidden = _selectedBankModel.isYHK;
    self.bankOrAccountNoNameLabel.text =  _selectedBankModel.isYHK ? kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.Bank_card_No") : kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.Pay_account_No");
    self.qrOrBankInfoNameLabel.text = _selectedBankModel.isYHK ? kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.Bank_Info") : kLocat(@"OTC.HBOTCTradeInfoDetailTableViewController.Receip_QR_code");
    [self.tableView reloadData];
}

- (void)setCountDownSecond:(NSInteger)countDownSecond {
    _countDownSecond = countDownSecond;
    if (_countDownSecond > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.timerStackView.hidden = NO;
        }];
        
        self.timerLabel.text = [Utilities returnTimeWithSecond:_countDownSecond formatter:@"mm:ss"];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.timerStackView.hidden = YES;
        }];
        [self.countDownTimer invalidate];
        [self.tableView.mj_header beginRefreshing];
    }
    
}

- (HBOTCOrderDetailAlertView *)tipsAlertView {
    if (!_tipsAlertView) {
        _tipsAlertView = [HBOTCOrderDetailAlertView loadNibView];
        _tipsAlertView.delegate = self;
    }
    
    return _tipsAlertView;
}

#pragma mark - HBOTCOrderDetailAlertViewDelegate, ZJPayPopupViewDelegate

- (void)didSelectSureWithOrderDetailAlertView:(HBOTCOrderDetailAlertView *)view {
    self.payPopupView = [ZJPayPopupView new];
    self.payPopupView.delegate = self;
}

- (void)didPasswordInputFinished:(NSString *)password {
    [self.payPopupView hidePayPopView];
    if (password.length > 0) {
        [self permitActionWithPwd:password];
    }
}

#pragma mark - 放行
-(void)permitActionWithPwd:(NSString *)pwd
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = self.tradeID;
    param[@"pwd"] = pwd;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/TradeOtc/fangxing"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            // 刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidPermitTheOrderKey" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

#pragma mark - Other




#pragma mark - 请付款界面，取消操作
-(void)checkCancelTime
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/day_cancel_count"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSInteger count = [[responseObj ksObjectForKey:kData][@"flag"]integerValue];
            if (count > 1) {
                [self showCancelTipsViewWith:count];
                
            }else if (count == 1){
                [self showCancelTipsViewWith:count];
            }else{
                [self showTips:kLocat(@"OTC_buyDetail_reachmaxcount")];
            }
        }
    }];
}



-(void)showCancelTipsViewWith:(NSInteger)count
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 211 *kScreenHeightRatio, kScreenW - 56, 210)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 67) text:kLocat(@"OTC_buyDetail_canceldeal") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, midView.height - 45, midView.width/2, 45) title:kLocat(@"net_alert_load_message_cancel") titleColor:kColorFromStr(@"#31AAD7") font:PFRegularFont(16) titleAlignment:YES];
    __weak typeof(self)weakSelf = self;
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*   sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, midView.height - 45, midView.width/2, 45) title:kLocat(@"net_alert_load_message_sure") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");
    
    [confirmlButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [weakSelf cancelOrderAction:sender flag:NO];
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom, midView.width - 56, 40) text:kLocat(@"OTC_buyDetail_maxcounttips") font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    
    UIButton *midButton = [[UIButton alloc] initWithFrame:kRectMake(20, 125, 170, 16) title:nil titleColor:kColorFromStr(@"#707589") font:PFRegularFont(14) titleAlignment:YES];
    [midView addSubview:midButton];
    [midButton setImage:kImageFromStr(@"fu_icon_xno") forState:UIControlStateNormal];
    [midButton setImage:kImageFromStr(@"fu_icon_xpre") forState:UIControlStateSelected];
//    [midButton alignHorizontal];
    [midButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        sender.selected = !sender.selected;
    }];
    [midButton sizeToFit];
    _confirmCancelButton = midButton;
    
    NSString *alertMessage = self.model.status == HBOTCTradeInfoModelStatusNotPay ? kLocat(@"OTC_buyDetail_notyetpay") : kLocat(@"OTC_buyDetail_notyetpay2");
    CGRect alertMessageLabelFrame = CGRectMake(midButton.right + 4, midButton.y, midView.right - midButton.right - 20 - 20, 0);
    UILabel *alertMessageLabel = [[UILabel alloc] initWithFrame:alertMessageLabelFrame text:alertMessage font:PFRegularFont(14)  textColor:kColorFromStr(@"#707589") textAlignment:0 adjustsFont:YES];
    alertMessageLabel.numberOfLines = 4;
    [alertMessageLabel sizeToFit];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        midButton.selected = !midButton.selected;
    }];
    alertMessageLabel.userInteractionEnabled = YES;
    [alertMessageLabel addGestureRecognizer:tapGR];
    [midView addSubview:alertMessageLabel];
    if (count > 1) {
        tipsLabel.hidden = YES;
        midButton.y = 80;
        alertMessageLabel.y = midButton.y;
    }
}

-(void)cancelOrderAction:(UIButton *)button flag:(BOOL)toDelete
{
    if (toDelete == NO && _confirmCancelButton.selected == NO) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"trade_id"] = self.tradeID;
    kShowHud;
    NSString *apiString = self.model.status == HBOTCTradeInfoModelStatusNotPay ? @"/TradeOtc/cancel" : @"TradeOtc/cancel_payment";
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:apiString] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:kLocat(@"OTC_buyDetail_orderhasbeencancel")];
            if (button) {
                [button.superview.superview removeFromSuperview];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
#pragma mark - 发通知刷新界面
            });
        }else{
            [self showInfoWithMessage:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}






@end
