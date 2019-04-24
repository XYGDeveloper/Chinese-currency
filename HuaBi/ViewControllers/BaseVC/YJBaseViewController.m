//
//  YJBaseViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "HBLoginTableViewController.h"
#import "NSObject+SVProgressHUD.h"

@interface YJBaseViewController ()

@end

@implementation YJBaseViewController
- (id)init{
    self = [super init];
    if (self) {
        self.enablePanGesture = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kThemeBGColor;
//    [self initBackButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.enablePanGesture = YES;
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self hideKeyBoard];
}

-(void)initBackButton
{
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.hidesBackButton = YES;
    }else{
        
        
        [self addLeftBarButtonWithImage:kImageFromStr(@"back_white") action:@selector(backAction)];
//        return;
//        self.navigationItem.hidesBackButton = NO;
//        UIButton *btn = [[UIButton alloc]initWithFrame:kRectMake(0, 0, 12, 20)];
//        [btn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
//
//        UIBarButtonItem *negetiveSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negetiveSpace.width = -1;
//        self.navigationItem.leftBarButtonItems = @[negetiveSpace,back];
        
    }
}
//返回事件
-(void)backAction
{
    if (self.navigationController.viewControllers.count == 1) {
        kDismiss;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setTitleWithNoNavgationBar:(NSString *)titleWithNoNavgationBar
{
    [self addbackButtonAndTitleWith:titleWithNoNavgationBar];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBoard];
}
-(void)addbackButtonAndTitleWith:(NSString *)title
{
    UIButton *enlageButton = [[UIButton alloc]initWithFrame:kRectMake(0, 0, kNavigationBarHeight, kNavigationBarHeight)];
    [self.view addSubview:enlageButton];
    [enlageButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    CGFloat y = IS_IPHONE_X?(35 + 22):35;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:kRectMake(20, y, 12, 20)];
    [enlageButton addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    //    backBtn.userInteractionEnabled = NO;
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    _backBtn = backBtn;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:kRectMake(50, 0, kScreenW - 100, 20) text:title font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [self.view addSubview:titleLabel];
    titleLabel.centerY = 35 + 13/2.0;

    _titleLabel = titleLabel;
    
}



-(void)userDidLogin
{
    
}
-(void)userDidlogout
{
}
-(void)userClickBackButton
{
    
}


-(void)changeStatusBarColorWithWhite:(BOOL)isWhite
{
    if (isWhite) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}
-(void)gotoLoginVC
{
    UIViewController *vc = [HBLoginTableViewController fromStoryboard];
//    ICNLoginViewController*vc = [[[ICNLoginViewController alloc]init];]
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)gotoRegisterVC
{
    ICNRegisterViewController *vc = [[ICNRegisterViewController alloc]init];
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

-(void)showTips:(NSString *)msg
{
    
    if (msg == nil || msg.length == 0) {
        return;
    }
    
    //mbprogress
//    [self.view showWarning:msg];
    [self showInfoWithMessage:msg];
    
}
-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
