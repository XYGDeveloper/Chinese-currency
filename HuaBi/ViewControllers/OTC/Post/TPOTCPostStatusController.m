

//
//  TPOTCPostStatusController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostStatusController.h"
#import "TPOTCBaseADController.h"
#import "TPBaseOTCViewController.h"

@interface TPOTCPostStatusController ()

@end

@implementation TPOTCPostStatusController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self initBackButton];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)setupUI
{
    
    self.enablePanGesture = NO;
    
    self.title = kLocat(@"OTC_post_waitresult");
    self.view.backgroundColor = kColorFromStr(@"#171F34");
    
    NSString *image;
    NSString *t;
    NSString *tt;
    if (_type == TPOTCPostStatusControllerTypeSuccess) {
        image = @"fabu_icon_succ";
//        t = @"發佈成功";
//        tt = @"我們會在有點擊您的客戶第一時間向您反饋";
        t = kLocat(@"OTC_post_postsuccess");
        tt = kLocat(@"OTC_post_tips1");
    }else{
        image = @"fabu_icon_engdai";
//        t = @"等待處理";
//        tt = @"已提交申請，等待平台處理";
        t = kLocat(@"OTC_post_wait");
        tt = kLocat(@"OTC_post_tips2");
    }
    UIImageView *img = [[UIImageView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight + 108 *kScreenHeightRatio, 60, 60)];
    img.image = kImageFromStr(image);
    [self.view addSubview:img];
    [img alignHorizontal];
    
    UILabel *midLabel = [[UILabel alloc] initWithFrame:kRectMake(0, img.bottom + 9, kScreenW, 16) text:t font:PFRegularFont(16) textColor:kColorFromStr(@"#DEE5FF") textAlignment:1 adjustsFont:YES];
    [self.view addSubview:midLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:kRectMake(0, img.bottom + 48, kScreenW, 12) text:tt font:PFRegularFont(12) textColor:kColorFromStr(@"#7582A4") textAlignment:1 adjustsFont:YES];
    [self.view addSubview:bottomLabel];
    
    
    if (_type == TPOTCPostStatusControllerTypeSuccess) {
        
        UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
        [rightbBarButton setTitle:kLocat(@"Dis_Done") forState:(UIControlStateNormal)];
        [rightbBarButton setTitleColor:kColorFromStr(@"#4173C8") forState:(UIControlStateNormal)];
        rightbBarButton.titleLabel.font = PFRegularFont(15);
        [rightbBarButton addTarget:self action:@selector(rightbuttonAction) forControlEvents:(UIControlEventTouchUpInside)];
        rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
        
    }
    
}

-(void)rightbuttonAction
{
    TPOTCBaseADController *vc = [TPOTCBaseADController new];
    kNavPush(vc);
}
-(void)backAction
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[TPBaseOTCViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}


@end
