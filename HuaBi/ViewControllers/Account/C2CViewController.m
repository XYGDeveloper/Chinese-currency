//
//  C2CViewController.m
//  YJOTC
//
//  Created by l on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "C2CViewController.h"
#import "DVSwitch.h"
#import "C2CHeaderTableViewCell.h"
#import "BCBitemTableViewCell.h"
#import "UILabel+HeightLabel.h"
#import "YBPopupMenu.h"
#import "C2CPaymodeViewController.h"
#import "AddPayViewController.h"
#import "C2cModel.h"
#import "TOActionSheet.h"
#import "PayModel.h"
#import "Masonry.h"
#import "HClActionSheet.h"
#import "HBOperationDesViewController.h"
#import "HBTradeJLViewController.h"
#import "AddCardViewController.h"
#import "AddWechatViewController.h"
#import "AddAliViewController.h"
#import "TPOTCPayWayListController.h"
#import "TPOTCPayWayBankController.h"
#import "TPOTCPayWayNoBankAddController.h"
#import "TPOTCPayWayNoBankAddController.h"
#import "UIView+WZB.h"
#import "HBC2COrderModel.h"
#import "LDYSelectivityTableViewCell.h"
#import "LDYSelectivityTypeTableViewCell.h"
#import "EmptyManager.h"
#import "PaymentMethodView.h"
#import "HMSegmentedControl+HB.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define WZBHeight [UIScreen mainScreen].bounds.size.height
#define WZBWidth [UIScreen mainScreen].bounds.size.width
@interface C2CViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,PaymentMethodViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) UITableView *selectTableView;//选择列表
@property (strong, nonatomic) DVSwitch *switcher;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *TypeLabel;
@property (strong, nonatomic) UITextField *sellInpriceField;
@property (strong, nonatomic) UITextField *sellIncountField;
@property (strong, nonatomic) UIView *caculateView;
@property (strong, nonatomic) UILabel *caculatedes;
@property (strong, nonatomic) UILabel *caculateCountLabel;
@property (strong, nonatomic) UIView *caculateButtonView;
@property (strong, nonatomic) UIButton *caculateButton;
@property (strong, nonatomic) C2CHeaderTableViewCell *head;
@property (strong, nonatomic) UILabel *footer;
@property (strong, nonatomic) UILabel *leftLabelView;
@property (strong, nonatomic) UILabel *leftCountLabelView;
@property (strong, nonatomic) NSArray *buyModels;
@property (strong, nonatomic) NSArray *sellModels;
@property (strong, nonatomic) C2cModel *model;
@property (nonatomic,assign)NSUInteger indexs;
@property (nonatomic)UILabel *payWayLabel;
@property (nonatomic, strong) HClActionSheet *selectbank;
@property (nonatomic, strong) HClActionSheet *addSelect;

@property (nonatomic, strong) NSString *payment;
@property (nonatomic, strong) NSString *pay_type;
@property(nonatomic,strong)UIView *addView;

@property(nonatomic,strong)UIView *popPayModeView;
@property(nonatomic,strong)UIView *popPayModeView2;
@property(nonatomic,strong)UIView *popPayModeView3;
@property(nonatomic,strong)UIView *selectPayModeView;

@property(nonatomic,strong)AlipayModel *amodel;
@property(nonatomic,strong)WechatModel *wmodel;
@property(nonatomic,strong)bankModel *bmodel;
@property(nonatomic,strong)HBC2COrderModel *orderModel;
@property(nonatomic,strong)UIImageView *qrcode;
@property(nonatomic,strong)UILabel *tipsLabel;
@property(nonatomic,strong)UILabel *warmLabel;
@property (nonatomic, strong) UILabel *cnyLabel;
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
@property (nonatomic, strong) PaymentMethodView *qrView;
@property (nonatomic, strong) PaymentMethodView *qrView1;

@property (nonatomic,strong)NSArray<c2c_configModel *> *c2cConfigModels;
@property (nonatomic, strong) c2c_configModel *selectedConfigModel;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, assign) BOOL isjump;

@end

@implementation C2CViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSMutableAttributedString *)getFormatteStringWithPathy:(NSString *)para{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:para];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [para length])];
    return attributedString;
}

- (void)loaddata{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = kUserInfo.user_id;
    param[@"key"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    
    [self showLoadingView];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/Ctrade"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [self hideLoadingView];
        if (error) {
            [self showErrorWithMessage:error.localizedDescription];
            return ;
        }
        if (success) {
            self.model = [C2cModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            self.c2cConfigModels = self.model.c2c_config_all;
            self.payFlag = @"0";
            [self.tableview reloadData];
        }else{
            [self showInfoWithMessage:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaddata];
    self.indexs = 0;
    self.title = kLocat(@"k_meViewcontroler_s2_2");
    [self _setupRigthBarItemButton];
    [self layOutsubs];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

//    [self.Tableview registerNib:[UINib nibWithNibName:@"MyAsetTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyAsetTableViewCell class])];
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"BCBitemTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BCBitemTableViewCell class])];
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
    footview.backgroundColor = kRGBA(24, 30, 50, 1);
    self.tableview.tableFooterView = footview;
    self.tipsLabel =  [[UILabel alloc]init];
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.font = [UIFont systemFontOfSize:13.0f];
    self.tipsLabel.textColor = kColorFromStr(@"#7582A4");
    [footview addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.sellIncountField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.sellInpriceField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.sellIncountField removeObserver:self forKeyPath:@"text"];
    [self.sellInpriceField removeObserver:self forKeyPath:@"text"];
}

- (void)_setupRigthBarItemButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gd"] style:UIBarButtonItemStylePlain target:self action:@selector(menuPop)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)menuPop{
    
    CGPoint point = [self.navigationController.navigationBar convertPoint:CGPointMake(self.navigationController.navigationBar.right, self.navigationController.navigationBar.bottom - 30) toView:nil];
    
    [YBPopupMenu showAtPoint:point titles:[NSMutableArray arrayWithObjects:kLocat(@"k_popview_1"),kLocat(@"k_popview_2"),kLocat(@"k_popview_3"),kLocat(@"k_popview_4"), nil] icons:[NSMutableArray arrayWithObjects:@"accounter_paymode.png",@"accounter_addpaymode.png",@"accounter_card.png",@"accounter_desc.png", nil] menuWidth:185 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 14;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = [kColorFromStr(@"#37415C") colorWithAlphaComponent:0.8];
//        popupMenu.tag = button.tag;
        popupMenu.itemHeight = 42;
        popupMenu.borderWidth = 0;
    }];
    
}




-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (index == 0) {
        kNavPush([TPOTCPayWayListController new]);
    }else if (index == 1){
        NSLog(@"------------------%@",kUserInfo.user_name);
        [self addAction];
    }else if (index == 2){
        kNavPush([HBTradeJLViewController new]);
    }else{
        kNavPush([HBOperationDesViewController new]);
    }
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
         dataArr = @[kLocat(@"k_popview_input_name"),self.orderModel.pay_info.truename,
                     kLocat(@"k_popview_input_bank"), self.orderModel.pay_info.name,
                     kLocat(@"k_popview_input_branchbank"),self.orderModel.pay_info.bankadd,
                     kLocat(@"k_popview_select_paywechat_rece_accoun"),[NSString stringWithFormat:@"%@   %@",self.orderModel.pay_info.bankcard,kLocat(@"OTC_copySuccess_copy")],
                     kLocat(@"k_popview_input_branchbank_confirm_order"),self.orderModel.pay_info.money,
                     kLocat(@"k_popview_input_branchbank_confirm_ordernote"),self.orderModel.pay_info.order_sn,
                     kLocat(@"k_popview_input_branchbank_confirm_orderstatus"),kLocat(@"k_popview_input_branchbank_confirm_wailttopay")];
         [addView wzb_drawListWithRect:CGRectMake(10, CGRectGetMaxY(titleLabel0.frame)+20, kScreenW - 20, 185) line:2 columns:7 datas:dataArr colorInfo:@{@"13" : [UIColor redColor],@"11" : [UIColor redColor],@"11" : [UIFont systemFontOfSize:16]}];
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel0.frame)+20+200, kScreenW - 24, 16) text:kLocat(@"k_popview_input_branchbank_confirm_Tips02") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        [addView addSubview:titleLabel1];
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel1.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips03") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        [addView addSubview:titleLabel2];

        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel2.frame), kScreenW - 24, 40) text:kLocat(@"k_popview_input_branchbank_confirm_Tips04") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        titleLabel3.numberOfLines = 0;
        [addView addSubview:titleLabel3];
        
        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel3.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips05") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
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
    if (_popPayModeView2 == nil) {
     
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
        UITapGestureRecognizer*tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveImg:)];

        UIButton *rightImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightImg setBackgroundImage:[UIImage imageNamed:@"shou_icon_ewm"] forState:UIControlStateNormal];
        [contentView addSubview:rightImg];
        [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.width.height.mas_equalTo(30);
        }];
        [rightImg addTarget:self action:@selector(toSee) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(contentView.frame)+5, kScreenW - 24, 20)];
        noteLabel.textAlignment = NSTextAlignmentLeft;
        noteLabel.textColor = kColorFromStr(@"#666666");
        noteLabel.font = [UIFont systemFontOfSize:14.0f];
        NSString *tempstr = [NSString stringWithFormat:@"%@%@%@",kLocat(@"k_in_c2c_tips_beizhu01"),self.orderModel.pay_info.order_sn,kLocat(@"k_in_c2c_tips_beizhu02")];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempstr];
        [str addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#BD2D36") range:NSMakeRange(7,6)];
        noteLabel.attributedText = str;
        [addView addSubview:noteLabel];
//        self.qrcode = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(noteLabel.frame)+5, kScreenW - 80, kScreenW - 80-40)];
//        self.qrcode.userInteractionEnabled = YES;
//        self.qrcode.backgroundColor = [UIColor whiteColor];
//        [self.qrcode setImageWithURL:[NSURL URLWithString:self.orderModel.pay_info.qrcode] placeholder:[UIImage imageNamed:@""]];
//        [addView addSubview:self.qrcode];
//        [self.qrcode addGestureRecognizer:tap];
        
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(noteLabel.frame)+5, kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips02") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        [addView addSubview:titleLabel1];
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel1.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips03") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        [addView addSubview:titleLabel2];
        
        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel2.frame), kScreenW - 24, 40) text:kLocat(@"k_popview_input_branchbank_confirm_Tips04") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
        titleLabel3.numberOfLines = 0;
        [addView addSubview:titleLabel3];
        
        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel3.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips05") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
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
    }
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
//    "k_in_c2c_tips_beizhu02" = "（Please fill in)";
//    "k_in_c2c_tips_beizhu01" = "Please note:";
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(contentView.frame)+5, kScreenW-24, 20)];
        noteLabel.textAlignment = NSTextAlignmentLeft;
        noteLabel.textColor = kColorFromStr(@"#666666");
        noteLabel.font = [UIFont systemFontOfSize:14.0f];
        NSString *tempstr = [NSString stringWithFormat:@"%@%@%@",kLocat(@"k_in_c2c_tips_beizhu01"),self.orderModel.pay_info.order_sn,kLocat(@"k_in_c2c_tips_beizhu02")];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempstr];
        [str addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#BD2D36") range:NSMakeRange(7,6)];
        noteLabel.attributedText = str;
       [addView addSubview:noteLabel];
//        self.qrcode = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(noteLabel.frame)+5, kScreenW - 80, kScreenW - 80-40)];
//        self.qrcode.userInteractionEnabled = YES;
//        self.qrcode.backgroundColor = [UIColor whiteColor];
//        [self.qrcode setImageWithURL:[NSURL URLWithString:self.orderModel.pay_info.qrcode] placeholder:[UIImage imageNamed:@""]];
//        [addView addSubview:self.qrcode];
//        [self.qrcode addGestureRecognizer:tap];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(noteLabel.frame)+5, 200, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips02") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
    [addView addSubview:titleLabel1];
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel1.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips03") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
    [addView addSubview:titleLabel2];
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel2.frame), kScreenW - 24, 40) text:kLocat(@"k_popview_input_branchbank_confirm_Tips04") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
    titleLabel3.numberOfLines = 0;
    [addView addSubview:titleLabel3];
    
    UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:kRectMake(12, CGRectGetMaxY(titleLabel3.frame), kScreenW - 24, 20) text:kLocat(@"k_popview_input_branchbank_confirm_Tips05") font:PFRegularFont(14) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:NO];
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

- (void)toSee{
    NSLog(@"1111111");
    __weak C2CViewController *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.qrView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)toSee1{
    NSLog(@"1111111");
    __weak C2CViewController *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.qrView1.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        
    }];
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
      
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmBtn.backgroundColor = kColorFromStr(@"#4173C8");
        [self.confirmBtn setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateNormal];
        self.confirmBtn.frame = CGRectMake(20, CGRectGetMaxY(self.selectTableView.frame)+10, 150, 45);
        self.confirmBtn.layer.cornerRadius = 8;
        self.confirmBtn.layer.masksToBounds = YES;
        [addView addSubview:self.confirmBtn];
        NSLog(@"%ld     %ld    %ld",self.paymodel.yinhang.count,self.paymodel.alipay.count,self.paymodel.wechat.count);
        if (self.paymodel.yinhang.count <= 0 && self.paymodel.alipay.count <= 0 && self.paymodel.wechat.count <= 0) {
             [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_emptyData") forState:UIControlStateNormal];
        }else{
             [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_confirmOrder") forState:UIControlStateNormal];
        }
        [self.confirmBtn addTarget:self action:@selector(confirmOrder:) forControlEvents:UIControlEventTouchUpInside];
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
    if (self.paymodel.yinhang.count <= 0) {
        self.isjump  = YES;
        [[EmptyManager sharedManager]showEmptyOnView:self.selectTableView withImage:nil explain:kLocat(@"k_popview_input_branchbank_confirm_noadd") operationText:nil operationBlock:nil];
        [self.selectTableView reloadData];
        [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_emptyData") forState:UIControlStateNormal];
    }else{
        self.isjump  = NO;
        [[EmptyManager sharedManager] removeEmptyFromView:self.selectTableView];
        [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_confirmOrder") forState:UIControlStateNormal];
    }
    [self.selectTableView reloadData];
}

- (void)alipayListAction:(UIButton *)sender{
    self.payFlag = @"1";
    self.selectIndexPath = nil;
    [sender setTitleColor:kColorFromStr(@"#E96E44") forState:UIControlStateNormal];
    [self.bankBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    if (self.paymodel.alipay.count <= 0) {
        self.isjump  = YES;
        [[EmptyManager sharedManager]showEmptyOnView:self.selectTableView withImage:nil explain:kLocat(@"k_popview_input_branchbank_confirm_noadd") operationText:nil operationBlock:nil];
        [self.selectTableView reloadData];
        [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_emptyData") forState:UIControlStateNormal];
    }else{
        self.isjump  = NO;
        [[EmptyManager sharedManager] removeEmptyFromView:self.selectTableView];
        [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_confirmOrder") forState:UIControlStateNormal];
    }
    [self.selectTableView reloadData];
}

- (void)wechatListAction:(UIButton *)sender{
    self.payFlag = @"2";
    self.selectIndexPath = nil;
    [sender setTitleColor:kColorFromStr(@"#E96E44") forState:UIControlStateNormal];
    [self.bankBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    [self.alipayBtn setTitleColor:kColorFromStr(@"#434C63") forState:UIControlStateNormal];
    if (self.paymodel.wechat.count <= 0) {
        self.isjump  = YES;
        [[EmptyManager sharedManager]showEmptyOnView:self.selectTableView withImage:nil explain:kLocat(@"k_popview_input_branchbank_confirm_noadd") operationText:nil operationBlock:nil];
        [self.selectTableView reloadData];
        [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_emptyData") forState:UIControlStateNormal];
    }else{
        self.isjump  = NO;
        [[EmptyManager sharedManager] removeEmptyFromView:self.selectTableView];
        [self.confirmBtn setTitle:kLocat(@"k_popview_list_counter_confirmOrder") forState:UIControlStateNormal];
    }
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
        if (self.isjump == YES) {
            [self addAction];
        }else{
            [self.selectTableView showWarning:kLocat(@"k_popview_select_paymode")];
            //         showTips:kLocat(@"k_popview_select_paymode")];
            return;
        }
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

//手势事件
- (void)clickTableView:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.selectTableView];
    NSIndexPath *indexPath = [self.selectTableView indexPathForRowAtPoint:point];
    if (indexPath == nil) {
        return;
    }
    
    if ([self.selectArray containsObject:@(indexPath.row)]) {
        [self.selectArray removeObject:@(indexPath.row)];
    }else {
        [self.selectArray addObject:@(indexPath.row)];
    }
    
    //按照数据源下标顺序排列
    [self.selectArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    [self.selectTableView reloadData];
}


#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.selectTableView) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.selectTableView) {
        if ([self.payFlag isEqualToString:@"0"]) {
            return self.paymodel.yinhang.count;
        }else if ([self.payFlag isEqualToString:@"1"]){
            return self.paymodel.alipay.count;
        }else{
            return self.paymodel.wechat.count;
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.selectTableView) {
        return 44;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.selectTableView) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }

}


//点击确定
//- (void)confirmAction{
//    if (self.ifSupportMultiple == NO) {
//        NSString *data = self.datas[self.selectIndexPath.row];
//        if (_delegate && [_delegate respondsToSelector:@selector(singleChoiceBlockData:)])
//        {
//            [_delegate singleChoiceBlockData:data];
//        }
//    }else{
//        NSMutableArray *dataAr = [NSMutableArray array];
//        [self.selectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSNumber *data = obj;
//            int row = [data intValue];
//            [dataAr addObject:self.datas[row]];
//        }];
//
//        NSArray *datas = [NSArray arrayWithArray:dataAr];
//        if (_delegate && [_delegate respondsToSelector:@selector(multipleChoiceBlockDatas:)])
//        {
//            [_delegate multipleChoiceBlockDatas:datas];
//        }
//    }
//    [self cancelAction];
//}




- (void)toSelectPayModeView{
    [UIView animateWithDuration:0.25 animations:^{
        self.selectPayModeView.y = 227;
        self.enablePanGesture = NO;
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


-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [self showTips:@"保存成功"];
    }
}

- (void)tosure:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.y = kScreenH;
        self.enablePanGesture = YES;
    }];
    kNavPush([HBTradeJLViewController new]);
}

- (void)tosure1:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        sender.superview.y = kScreenH;
        self.enablePanGesture = YES;
    }];
    kNavPush([HBTradeJLViewController new]);
}

-(void)addAction
{
    [UIView animateWithDuration:0.25 animations:^{
        self.addView.y = kStatusBarHeight;
        self.enablePanGesture = NO;
    }];
    
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


- (void)layOutsubs{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45. + 1. + 197+91+35)];
    self.contentView.backgroundColor = kColorFromStr(@"0B132A");
    self.tableview.tableHeaderView = self.contentView;
    
    [self.contentView addSubview:self.segmentedControl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46., kScreenW, 1.)];
    lineView.backgroundColor = kThemeBGColor;
    [self.contentView addSubview:lineView];
    
    self.switcher = [[DVSwitch alloc] initWithStringsArray:@[kLocat(@"k_bcbViewController_sellin"), kLocat(@"k_bcbViewController_sellout")]];
    self.switcher.backgroundColor = kColorFromStr(@"#171F34");
    self.switcher.sliderColor = kColorFromStr(@"#03C086");
    self.switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    self.switcher.labelTextColorOutsideSlider = kColorFromStr(@"#7582A4");
    self.switcher.layer.cornerRadius = 30/2;
    self.switcher.layer.masksToBounds = YES;
    self.switcher.layer.borderWidth = 1;
    self.switcher.layer.borderColor = kRGBA(24, 30, 50, 1).CGColor;
    self.switcher.frame = CGRectMake(100, lineView.bottom + 11.,kScreenW - 100*2, 30);
    [self.contentView addSubview:self.switcher];
    [self.switcher selectIndex:0 animated:YES];
    __weak typeof(self)weakSelf = self;
    [self.switcher setPressedHandler:^(NSUInteger index) {
        NSLog(@"--------%lu",(unsigned long)index);

        [weakSelf _hideSelectPayModeView];
        
        [weakSelf _updateWarmLabelWithIsBuy:index == 0];
        if (index == 0) {
            weakSelf.indexs = index;
            weakSelf.sellInpriceField.text = weakSelf.selectedConfigModel.buy_price;
            [weakSelf.caculateButton setTitle:kLocat(@"k_c2c_now_startbuy") forState:UIControlStateNormal];
            weakSelf.leftLabelView.text = kLocat(@"k_c2c_buyp");
            weakSelf.leftCountLabelView.text = [NSString stringWithFormat:@"%@(%@)", kLocat(@"k_c2c_buycount"), weakSelf.selectedConfigModel.currency_mark];
            weakSelf.sellIncountField.text = @"";
            [weakSelf _updateCaculateCountLabelWithColor:kColorFromStr(@"#03C086")];
            weakSelf.caculatedes.text = kLocat(@"k_c2c_needt");
        }else{
            weakSelf.caculatedes.text = kLocat(@"k_c2c_acquire");
            weakSelf.indexs = index;
            weakSelf.sellInpriceField.text = weakSelf.selectedConfigModel.sell_price;
            [weakSelf.caculateButton setTitle:kLocat(@"k_c2c_now_startsell") forState:UIControlStateNormal];
            weakSelf.leftLabelView.text = kLocat(@"k_c2c_sellp");
            weakSelf.leftCountLabelView.text  = kLocat(@"k_c2c_sellcount");
            weakSelf.leftCountLabelView.text = [NSString stringWithFormat:@"%@(%@)", kLocat(@"k_c2c_sellcount"), weakSelf.selectedConfigModel.currency_mark];
            weakSelf.sellIncountField.text = @"";
            [weakSelf _updateCaculateCountLabelWithColor:kColorFromStr(@"#E86F44")];
        }
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
    }];
    
    self.TypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.switcher.frame)+15, kScreenW, 40) text:nil font:[UIFont systemFontOfSize:16.0F] textColor:kColorFromStr(@"#FFD401") textAlignment:NSTextAlignmentCenter adjustsFont:YES];
    self.TypeLabel.backgroundColor = kColorFromStr(@"#0B132A");
    [self.contentView addSubview:self.TypeLabel];
    
    self.sellInpriceField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.TypeLabel.frame)+5, kScreenW-40, 45)];
    self.sellInpriceField.backgroundColor = kColorFromStr(@"#171F34");
    self.sellInpriceField.font = [UIFont systemFontOfSize:14.0f];
    self.sellInpriceField.textAlignment = NSTextAlignmentRight;
    self.sellInpriceField.userInteractionEnabled = NO;
    self.sellInpriceField.textColor  =kColorFromStr(@"#7582A4");
    self.sellInpriceField.leftViewMode=UITextFieldViewModeAlways;
    [self.contentView addSubview:self.sellInpriceField];
    self.leftLabelView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 45)];
    self.leftLabelView .text  =kLocat(@"k_c2c_buyp");
    self.leftLabelView.font = [UIFont systemFontOfSize:14.0f];
    self.leftLabelView.textColor = kColorFromStr(@"#7582A4");
    [self.sellInpriceField addSubview:self.leftLabelView];
    self.sellIncountField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.sellInpriceField.frame)+5, kScreenW-40, 45)];
    self.sellIncountField.backgroundColor = kColorFromStr(@"#171F34");
    self.sellIncountField.placeholder = kLocat(@"k_c2c_sell_buycount_placehoder");
    self.sellIncountField.font = [UIFont systemFontOfSize:14.0f];
    self.sellIncountField.keyboardType = UIKeyboardTypeNumberPad;

    [self.sellIncountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.sellIncountField.textColor  =kColorFromStr(@"#7582A4");
    [self.sellIncountField setValue:kColorFromStr(@"#37415C") forKeyPath:@"_placeholderLabel.textColor"];
    self.sellIncountField.leftViewMode=UITextFieldViewModeAlways;
    self.leftCountLabelView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 45)];
    self.leftCountLabelView.text  =kLocat(@"k_c2c_buycount");
    self.leftCountLabelView.font = [UIFont systemFontOfSize:14.0f];
    self.leftCountLabelView.textColor = kColorFromStr(@"#7582A4");
    self.leftCountLabelView.textAlignment = NSTextAlignmentLeft;
    [self.sellIncountField addSubview: self.leftCountLabelView];
    self.sellIncountField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.sellIncountField];
    
    self.caculateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sellIncountField.frame)+5, kScreenW, 45)];
    self.caculateView.backgroundColor = kColorFromStr(@"#0B132A");
    [self.contentView addSubview:self.caculateView];
    
    self.caculatedes = [[UILabel alloc]initWithFrame:CGRectMake(30, 0,0, 45) text:kLocat(@"k_c2c_needt") font:[UIFont systemFontOfSize:12.0f] textColor:kColorFromStr(@"#7582A4") textAlignment:NSTextAlignmentLeft adjustsFont:YES];
    [self.caculateView addSubview:self.caculatedes];
    [self.caculatedes sizeToFit];
    self.caculatedes.height = 45;
    NSString *levelStr = [NSString stringWithFormat:@"%@CNY",self.caculateCountLabel.text?self.caculateCountLabel.text:@""];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:levelStr];
    [str addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#7582A4") range:NSMakeRange(levelStr.length-3,3)];
    self.caculateCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.caculatedes.right + 4, 0, (kScreenW-40)/2, 45) Atttext:str font:[UIFont systemFontOfSize:14.0f] textColor:kColorFromStr(@"#03C086") textAlignment:NSTextAlignmentLeft adjustsFont:YES];
    [self _updateCaculateCountLabelWithColor:kColorFromStr(@"#03C086")];
    self.warmLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.caculateCountLabel.frame), 0, kScreenW -(80+kScreenW/2), 45) text:nil font:[UIFont systemFontOfSize:14.0f] textColor:kColorFromStr(@"#7582A4") textAlignment:NSTextAlignmentRight adjustsFont:YES];
    [self.caculateView addSubview:self.warmLabel];
    [self.caculateView addSubview:self.caculateCountLabel];
    
    self.caculateButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.caculateView.frame)+15, kScreenW, 60)];
    self.caculateButtonView.backgroundColor = kColorFromStr(@"#0B132A");
    [self.contentView addSubview:self.caculateButtonView];
    self.caculateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.caculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.indexs == 0) {
        [self.caculateButton setTitle:kLocat(@"k_c2c_now_startbuy") forState:UIControlStateNormal];
    }else{
        [self.caculateButton setTitle:kLocat(@"k_c2c_now_startsell") forState:UIControlStateNormal];
    }
    
    [self.caculateButton addTarget:self action:@selector(tobuy) forControlEvents:UIControlEventTouchUpInside];
    [self.caculateButtonView addSubview:self.caculateButton];
    self.caculateButton.frame = CGRectMake(20, 0, kScreenW-40, 45);
    self.caculateButton.backgroundColor = kColorFromStr(@"#4173C8");
    self.caculateButton.layer.cornerRadius = 45/2;
    self.caculateButton.layer.masksToBounds = YES;
//    self.head =  [[[NSBundle mainBundle] loadNibNamed:@"C2CHeaderTableViewCell" owner:nil options:nil] lastObject];
//    self.head.backgroundColor = kColorFromStr(@"#0B132A");
//    self.head.frame = CGRectMake(0, CGRectGetMaxY(self.caculateButtonView.frame)+10, kScreenW, 35);
//    [self.contentView addSubview:self.head];
    
}

- (void)_hideSelectPayModeView {
    [UIView animateWithDuration:0.25 animations:^{
        self.selectPayModeView.y = kScreenH;
    }];
}

- (void)tobuy{
    if (self.sellIncountField.text.length <= 0) {
        [self showTips:@"请输入买入或卖出量"];
        return;
    }
    if ([self.sellIncountField.text doubleValue] < [self.selectedConfigModel.min_volume doubleValue] || [self.sellIncountField.text doubleValue] > [self.selectedConfigModel.max_volume doubleValue]) {
        [self showTips:[NSString stringWithFormat:@"%@%@~%@",kLocat(@"k_in_c2c_tips_range"),self.selectedConfigModel.min_volume,self.selectedConfigModel.max_volume]];
        return;
    }
    [self.sellIncountField resignFirstResponder];
    [self addpaymode];
}

- (void)addpaymode{
    
    NSString *path;
    if (self.indexs == 0) {
        path = @"Api/Entrust/getPaymentList";
    }else{
        path = @"Api/Bank/index";
    }
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
            if (self.paymodel.yinhang.count <= 0) {
                self.isjump = YES;
                [[EmptyManager sharedManager]showEmptyOnView:self.selectTableView withImage:nil explain:kLocat(@"k_popview_input_branchbank_confirm_noadd") operationText:nil operationBlock:nil];
                                [self.selectTableView reloadData];
            }else{
                self.isjump = NO;
                [[EmptyManager sharedManager] removeEmptyFromView:self.selectTableView];
            }
            if (self.paymodel.yinhang.count <= 0 && self.paymodel.alipay.count <= 0 && self.paymodel.wechat.count <= 0) {

                [self toSelectPayModeView];
            }else{
                [self.selectTableView reloadData];
                [self toSelectPayModeView];
            }
           
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)toPay{
    if (self.indexs == 0) {
        kShowHud;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token_id"] = kUserInfo.user_id;
        param[@"key"] = kUserInfo.token;
        param[@"uuid"] = [Utilities randomUUID];
        param[@"buyUnitPrice"] = self.selectedConfigModel.buy_price;
        param[@"buyNumber"] = self.sellIncountField.text;
        param[@"cuid"] = self.selectedConfigModel.currency_id;
        param[@"payment"] = self.payment;
        param[@"pay_type"] = self.payment;
        if ([self.payFlag isEqualToString:@"0"]) {
            param[@"pay_type"] = @"1";
        }else if([self.payFlag isEqualToString:@"1"]){
            param[@"pay_type"] = @"2";
        }else{
            param[@"pay_type"] = @"3";
        }
        __weak typeof(self)weakSelf = self;
        NSLog(@"%@",param);
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Api/Entrust/addOrderBuy"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            NSLog(@"%@",responseObj);
            kHideHud;
            if (success) {
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
                [self getOrderId:[responseObj ksObjectForKey:kData][@"order_id"]];
            }else{
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else{
        kShowHud;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token_id"] = kUserInfo.user_id;
        param[@"key"] = kUserInfo.token;
        param[@"uuid"] = [Utilities randomUUID];
        param[@"sellUnitPrice"] = self.selectedConfigModel.buy_price;
        param[@"sellNumber"] = self.sellIncountField.text;
        param[@"cuid"] = self.selectedConfigModel.currency_id;
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
            }else if([self.orderModel.pay_info.pay_type isEqualToString:@"2"]){
                [self addPayModeAction2];
            }else{
                [self addPayModeAction3];
            }
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.sellIncountField] || [object isEqual:self.sellInpriceField]) {
        [self _calculatePrice];
    }
}

- (void)_calculatePrice {
    if ([self.sellIncountField.text isEqualToString:@""]) {
        self.caculateCountLabel.text = @"CNY";
    }else{
        self.caculateCountLabel.text = [NSString stringWithFormat:@"%fCNY",[self.sellInpriceField.text floatValue]*[self.sellIncountField.text floatValue]];
    }
    [self _updateCaculateCountLabelWithColor:nil];
}

-(void)textFieldDidChange:(UITextField *)theTextField{
    [self _calculatePrice];
}

- (void)_updateCaculateCountLabelWithColor:(UIColor *)color {
    NSString *text = self.caculateCountLabel.text;
    if (color) {
        self.caculateCountLabel.textColor = color;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#7582A4") range:NSMakeRange(text.length-3,3)];
    self.caculateCountLabel.attributedText = str.copy;
}


#pragma mark - Setters && Getters

- (void)setC2cConfigModels:(NSArray<c2c_configModel *> *)c2cConfigModels {
    _c2cConfigModels = c2cConfigModels;
    
    if (!self.selectedConfigModel) {
        self.selectedConfigModel = c2cConfigModels.firstObject;
    }
    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    [c2cConfigModels enumerateObjectsUsingBlock:^(c2c_configModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.currency_mark ?:@""];
    }];
    
    self.segmentedControl.sectionTitles = titles.copy;
    
}


- (void)setSelectedConfigModel:(c2c_configModel *)selectedConfigModel {
    _selectedConfigModel = selectedConfigModel;
    [self.switcher selectIndex:0 animated:NO];
    self.sellInpriceField.text = self.selectedConfigModel.buy_price;
    self.tipsLabel.attributedText = [self getFormatteStringWithPathy:self.selectedConfigModel.c2c_introduc];
    [self.tipsLabel sizeToFit];
    
    self.tableview.tableFooterView.height = self.tipsLabel.height + 20;
    self.TypeLabel.text = [NSString stringWithFormat:@"%@%@",self.selectedConfigModel.currency_mark,kLocat(@"k_c2c_now_trade")];
    if (selectedConfigModel.currency_mark) {
        self.leftCountLabelView.text = [NSString stringWithFormat:@"%@(%@)", kLocat(@"k_c2c_buycount"), selectedConfigModel.currency_mark];
    }
    [self _updateWarmLabelWithIsBuy:YES];
}

- (void)_updateWarmLabelWithIsBuy:(BOOL)isBuy {
    
    NSString *prefixTips = isBuy ? kLocat(@"k_popview_input_branchbank_confirm_wailtips") : kLocat(@"k_popview_input_branchbank_confirm_wailtips_sell");
    self.warmLabel.text = [NSString stringWithFormat:@"%@(%@-%@)", prefixTips,self.selectedConfigModel.min_volume, self.selectedConfigModel.max_volume];
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [HMSegmentedControl createSegmentedControl];
        _segmentedControl.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            if (index < weakSelf.c2cConfigModels.count) {
                weakSelf.selectedConfigModel = weakSelf.c2cConfigModels[index];
            }
            [weakSelf _hideSelectPayModeView];
        };
    }
    
    return _segmentedControl;
}

@end
