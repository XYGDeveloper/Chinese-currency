//
//  TPOTCBaseADController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBaseADController.h"
#import "TPOTCCurrentADBaseController.h"
#import "TPOTCHistoryADBaseController.h"
#import "TPBaseOTCViewController.h"

@interface TPOTCBaseADController ()

@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIButton *buyButton;
@property(nonatomic,strong)UIButton *sellButton;
@property(nonatomic,assign)BOOL isBuy;
@property(nonatomic,assign)BOOL isCurrent;


@property(nonatomic,strong)TPOTCCurrentADBaseController *currentADVC;
@property(nonatomic,strong)TPOTCHistoryADBaseController *historyVC;

@property(nonatomic,strong)UIViewController *currentVC;


@end

@implementation TPOTCBaseADController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_currencyArr == nil) {
        _currencyArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"kDidGetAllAvailableCurrencyKey" appendDocument]];
    }
    
    
    [self setupUI];
    [self setupNavi];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)setupUI
{
    self.view.backgroundColor  = kWhiteColor;
    
    self.currentADVC = [[TPOTCCurrentADBaseController alloc] init];
    self.currentADVC.currencyArr = _currencyArr;
    self.currentADVC.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    self.currentADVC.view.frame = kScreenBounds;

    [self addChildViewController:self.currentADVC];
    
    
    
    self.historyVC = [[TPOTCHistoryADBaseController alloc] init];
    self.historyVC.currencyArr = _currencyArr;
    self.historyVC.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    self.historyVC.view.frame = kScreenBounds;

    
    [self addChildViewController:self.historyVC];
    
    
    [self.view addSubview:self.currentADVC.view];
    self.currentVC = self.currentADVC;
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
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, midView.width/2, midView.height) title:kLocat(@"OTC_ad_currentad") titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:leftButton];
    [leftButton setBackgroundImage:[UIImage imageWithColor:tintColor] forState:UIControlStateSelected];
    
    [leftButton setBackgroundImage:[UIImage imageWithColor:unselectColor] forState:UIControlStateNormal];
    leftButton.selected = YES;
    leftButton.tag = 0;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:kRectMake(leftButton.right, 0, leftButton.width, leftButton.height) title:kLocat(@"OTC_ad_history") titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:rightButton];
    [rightButton setBackgroundImage:[UIImage imageWithColor:tintColor] forState:UIControlStateSelected];
    [rightButton setBackgroundImage:[UIImage imageWithColor:unselectColor] forState:UIControlStateNormal];
    rightButton.tag = 1;
    
    
    self.navigationItem.titleView = midView;
    _buyButton = leftButton;
    _sellButton = rightButton;
    _isCurrent = YES;
    
    leftButton.SG_eventTimeInterval = 0.3;
    rightButton.SG_eventTimeInterval = 0.3;

    
    [rightButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initBackButton];
    
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
    _isCurrent = _buyButton.isSelected;
    //    [self loadDateWithKeyWord:@""];
    
    if (_isCurrent) {
        [self replaceController:self.currentVC newController:self.currentADVC];
    }else{
        [self replaceController:self.currentVC newController:self.historyVC];
        
    }
    
}




-(void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
//    UIViewAnimationOptionTransitionNone
//    UIViewAnimationOptionCurveEaseInOut
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




-(void)backAction
{
    UIViewController *targetVc = [UIViewController new];
    BOOL isContain = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[TPBaseOTCViewController class]]) {
            isContain = YES;
            targetVc = vc;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    if (isContain) {
        [self.navigationController popToViewController:targetVc animated:YES];
        
    }else{
        [super backAction];
    }

}








@end
