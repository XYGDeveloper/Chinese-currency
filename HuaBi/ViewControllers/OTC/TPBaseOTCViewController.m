//
//  TPBaseOTCViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPBaseOTCViewController.h"
#import "TPOTCBuyOrSellBaseController.h"
#import "TPOTCSellBaseController.h"
#import "TPOTCPayWayListController.h"
#import "TPOTCOrderBaseController.h"
#import "TPOTCBaseADController.h"
#import "TPOTCBasePostController.h"
#import "NSObject+SVProgressHUD.h"

@interface TPBaseOTCViewController ()

@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIButton *buyButton;
@property(nonatomic,strong)UIButton *sellButton;
@property(nonatomic,assign)BOOL isBuy;

@property(nonatomic,strong)TPOTCBuyOrSellBaseController *buyVC;
@property(nonatomic,strong)TPOTCBuyOrSellBaseController *sellVC;

@property(nonatomic,strong)UIViewController *currentVC;

@property(nonatomic,strong)NSArray *currencyArr;

@property(nonatomic,assign)BOOL loadSuccess;

@property(nonatomic,assign)BOOL firstLoad;


@end

@implementation TPBaseOTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetAllAvailableCurrency:) name:@"kDidGetAllAvailableCurrencyKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOTCBaseVCTopView) name:@"kHideBaseOTCTopViewKey" object:nil];


    [self setupNavi];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if (_loadSuccess == NO) {
        [self loadData];
    }
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)loadData
{

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/currencys"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
//        _firstLoad = NO;
        if (success) {
            _loadSuccess = YES;
            NSArray *datas = [responseObj ksObjectForKey:kData];
            NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:datas.count];
            for (NSDictionary *dic in datas) {
                [Marr addObject:[TPCurrencyModel modelWithJSON:dic]];
            }
            _currencyArr = Marr.mutableCopy;
            [NSKeyedArchiver archiveRootObject:Marr.copy toFile:[@"kDidGetAllAvailableCurrencyKey" appendDocument]];
            
            [self setupUI];
        }else{
            __weak typeof(self)weakSelf = self;
            _loadSuccess = NO;

            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                
                [weakSelf loadData];
                
            }];
        }
    }];
}


-(void)setupUI
{
//    self.navigationController.navigationBar.translucent = NO;

    
    self.view.backgroundColor  = kColorFromStr(@"#0B132A");
    [self addChildViewController:self.buyVC];
    [self addChildViewController:self.sellVC];
    [self.view addSubview:self.buyVC.view];
    self.currentVC = self.buyVC;
}

-(void)setupNavi
{
    
    UIColor *tintColor = kColorFromStr(@"#4173C8");
    UIColor *unselectColor = [UIColor clearColor];
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 200, kNavigationBarHeight)];
    topView.backgroundColor = unselectColor;
    
    UIView *midView = [[UIView alloc]initWithFrame:kRectMake(0, 0, 170, 30)];
    [topView addSubview:midView];
    midView.backgroundColor = topView.backgroundColor;
    kViewBorderRadius(midView, 0, 1, tintColor);
    [midView alignHorizontal];
    midView.bottom = topView.height - 5;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, midView.width/2, midView.height) title:kLocat(@"OTC_main_buy") titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:leftButton];
    [leftButton setBackgroundImage:[UIImage imageWithColor:tintColor] forState:UIControlStateSelected];
 
    [leftButton setBackgroundImage:[UIImage imageWithColor:unselectColor] forState:UIControlStateNormal];
    leftButton.selected = YES;
    leftButton.tag = 0;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:kRectMake(leftButton.right, 0, leftButton.width, leftButton.height) title:kLocat(@"OTC_main_sell") titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:rightButton];
    [rightButton setBackgroundImage:[UIImage imageWithColor:tintColor] forState:UIControlStateSelected];
    [rightButton setBackgroundImage:[UIImage imageWithColor:unselectColor] forState:UIControlStateNormal];
    rightButton.tag = 1;
    
    
    self.navigationItem.titleView = midView;
    
    self.navigationItem.title = kLocat(@"OTC_main_buy");
    _buyButton = leftButton;
    _sellButton = rightButton;
    _isBuy = YES;
    leftButton.SG_eventTimeInterval = 0.3;
    rightButton.SG_eventTimeInterval = 0.3;
    
    [rightButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:kImageFromStr(@"poc_icon_navno") forState:UIControlStateNormal];
    [firstButton setImage:kImageFromStr(@"poc_icon_navpre") forState:UIControlStateSelected];
    [firstButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
    _rightButton = firstButton;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

#pragma mark - 点击事件

-(void)topNaviButtonAction:(UIButton *)button
{

    if (button.isSelected) {
        return;
    }else{
        if (button.tag == 0) {
            _buyButton.selected = YES;
            _sellButton.selected = NO;
        }else{
            _buyButton.selected = NO;
            _sellButton.selected = YES;
        }
    }
    _isBuy = _buyButton.isSelected;
//    [self loadDateWithKeyWord:@""];
    
    if (_isBuy) {
        [self replaceController:self.currentVC newController:self.buyVC];
    }else{
        [self replaceController:self.currentVC newController:self.sellVC];

    }
    [self.view bringSubviewToFront:self.topView];

}






-(void)rightButtonAction:(UIButton *)button
{
    [self.view bringSubviewToFront:self.topView];
    button.selected = !button.selected;
    if (button.isSelected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.x = 0;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.x = kScreenW;
        }];
    }
}
-(void)topButtonAction:(UIButton *)button
{
    [self hideOTCBaseVCTopView];
    
    if (_currencyArr == nil) {
        
        _currencyArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"kDidGetAllAvailableCurrencyKey" appendDocument]];
        if (_currencyArr == nil) {
            [self loadData];
            return;
        }
    }
    
    if ([Utilities isExpired] && button.tag < 4) {
        [self gotoLoginVC];
        return;
    }
    if(kUserInfo.verify_state.intValue != 1){
        [self showTips:kLocat(@"k_in_c2c_tips")];
        return;
    }
    
    
    
    switch (button.tag) {
        case 0:
        {
            if (kUserInfo.nick.length == 0) {
                [self _alertNicknameTextField];
                return;
            }
            TPOTCBasePostController *vc = [TPOTCBasePostController new];
            vc.currencyArr = _currencyArr;
            kNavPush(vc);
        }
            break;
        case 1:
        {
            TPOTCBaseADController *vc = [TPOTCBaseADController new];
            vc.currencyArr = _currencyArr;
            kNavPush(vc);
        }
            break;
        case 2:
        {
            TPOTCOrderBaseController *vc = [TPOTCOrderBaseController new];
            kNavPush(vc);
        }
            break;
        case 3:
        {
            TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
            kNavPush(vc);
        }
            break;
        case 4:
        {
            _rightButton.selected = YES;
            [self rightButtonAction:_rightButton];
            
        }
            break;
        default:
            break;
    }
}
-(UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:kRectMake(kScreenW, 0, kScreenW, 60)];
        [self.view addSubview:_topView];
        _topView.backgroundColor = kColorFromStr(@"#37415C");
        
        CGFloat w = 60;

        CGFloat h = _topView.height;
        
//        NSArray *titles = @[@"發佈廣告",@"我的廣告",@"交易訂單",@"收款方式",@"隐藏"];
        NSArray *titles = @[kLocat(@"OTC_main_postad"),kLocat(@"OTC_main_myad"),kLocat(@"OTC_main_order"),kLocat(@"OTC_main_payway"),kLocat(@"OTC_main_hide")];

        
        NSArray *icons = @[@"OTC_icon1",@"C2C_icon2",@"C2C_icon3",@"C2C_icon4",@"poc_icon_yinc"];
        
        for (NSInteger i = 0; i < titles.count; i++) {
            CGFloat x = (kScreenW / titles.count - w)/2 + i * kScreenW / titles.count;
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(x, 0, w, h)];
            [_topView addSubview:button];
            [button alignVertical];
            [self configureButton:button With:titles[i] image:icons[i]];
            button.tag = i;
            [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    return _topView;
}
-(void)configureButton:(YLButton *)button With:(NSString *)title image:(NSString *)image
{
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.font = PFRegularFont(12);
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [button setImage:kImageFromStr(image) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.imageRect = kRectMake(19, 12, 22, 22);
    button.titleRect = kRectMake(0, 38, button.width, 12);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;//设置文字位置，现设为居左，默认的是居中
    button.titleLabel.textAlignment = 1;
    
}

-(void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            
            [newController  didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        }else{
            self.currentVC = oldController;
        }
    }];
}

-(void)didGetAllAvailableCurrency:(NSNotification *)noti
{
    _currencyArr = noti.object;
    
}

-(void)hideOTCBaseVCTopView
{
    _rightButton.selected = YES;
    [self rightButtonAction:_rightButton];
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
            YJUserInfo *userInfo = kUserInfo;
            userInfo.nick = nick;
            [userInfo saveUserInfo];
            [self showSuccessWithMessage:model.message];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

#pragma mark - Getter

- (TPOTCBuyOrSellBaseController *)buyVC {
    if (!_buyVC) {
        _buyVC = [[TPOTCBuyOrSellBaseController alloc] init];
        _buyVC.isTypeOfBuy = YES;
        _buyVC.view.frame = kScreenBounds;
    }
    return _buyVC;
}

- (TPOTCBuyOrSellBaseController *)sellVC {
    if (!_sellVC) {
        _sellVC = [[TPOTCBuyOrSellBaseController alloc] init];
        _sellVC.isTypeOfBuy = NO;
        _sellVC.view.frame = kScreenBounds;
    }
    
    return _sellVC;
}

@end
