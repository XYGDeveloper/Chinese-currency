

//
//  TPOTCBasePostController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBasePostController.h"
#import "TPOTCBuyPostBaseController.h"
#import "TPOTCSellPostBaseController.h"
#import "NSObject+SVProgressHUD.h"


@interface TPOTCBasePostController ()

@property(nonatomic,strong)UIButton *buyButton;
@property(nonatomic,strong)UIButton *sellButton;
@property(nonatomic,assign)BOOL isBuy;

@property(nonatomic,strong)TPOTCBuyPostBaseController *buyVC;
@property(nonatomic,strong)TPOTCSellPostBaseController *sellVC;
@property(nonatomic,strong)UIViewController *currentVC;

@end

@implementation TPOTCBasePostController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_currencyArr) {
        [self setupUI];
    }else{
        [self loadData];
    }
    
    [self setupNavi];
    self.enablePanGesture = NO;

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)loadData
{
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/currencys"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:datas.count];
            for (NSDictionary *dic in datas) {
                [arr addObject:[TPCurrencyModel modelWithJSON:dic]];
            }
//            [kUserDefaults setObject:arr forKey:kAllAvailableCurrencyArrayKey];

            self.currencyArr = arr.mutableCopy;
            [self setupUI];
        }
    }];
}
-(void)setupUI
{
    self.view.backgroundColor  = kWhiteColor;
    
    self.buyVC = [[TPOTCBuyPostBaseController alloc] init];
    self.buyVC.currencyArr = _currencyArr;
    self.buyVC.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    self.buyVC.view.frame = kScreenBounds;
    [self addChildViewController:self.buyVC];
    
    self.sellVC = [[TPOTCSellPostBaseController alloc] init];
    self.sellVC.currencyArr = _currencyArr;
    self.sellVC.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    self.sellVC.view.frame = kScreenBounds;

    [self addChildViewController:self.sellVC];
    
    [self.view addSubview:self.buyVC.view];
    self.currentVC = self.buyVC;
}

-(void)setupNavi
{
    
    UIColor *tintColor = kColorFromStr(@"#4173C8");
    UIColor *unselectColor = [UIColor clearColor];
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 200, kNavigationBarHeight)];
//    topView.backgroundColor = unselectColor;
    
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
    
    

    _buyButton = leftButton;
    _sellButton = rightButton;
    _isBuy = YES;
    leftButton.SG_eventTimeInterval = 0.3;
    rightButton.SG_eventTimeInterval = 0.3;
    
    [rightButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = midView;
    self.title = kLocat(@"OTC_main_sell");
    [self topNaviButtonAction:_sellButton];

}

#pragma mark - 点击事件

-(void)topNaviButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
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
    
}

-(void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            [newController  didMoveToParentViewController:self];
            
            self.currentVC = newController;
        }else{
            self.currentVC = oldController;
        }
    }];
}


@end
