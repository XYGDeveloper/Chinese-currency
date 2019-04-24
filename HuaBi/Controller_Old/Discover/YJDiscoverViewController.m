//
//  YJDiscoverViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/29.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJDiscoverViewController.h"
#import "YBPopupMenu.h"
#import "HYPageView.h"
#import "YWCircleIssueController.h"
#import "YWCircleSearchController.h"
#import "YJFollowingController.h"


@interface YJDiscoverViewController ()<YBPopupMenuDelegate>

@end

@implementation YJDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


-(void)setupUI
{
    self.title = LocalizedString(@"discover");
    
    HYPageView *pageView = [[HYPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kTabbarItemHeight) withTitles:@[LocalizedString(@"Dis_Circle"),kLocat(@"k_Attention"),LocalizedString(@"Dis_Chats"),LocalizedString(@"Dis_Friends"),LocalizedString(@"Dis_GroupChat")] withViewControllers:@[@"YWCircleViewController",@"YJFollowingController",@"YWChatListController",@"YWFriendListController",@"YWGroupListController"] withParameters:nil];
    pageView.pageViewStyle = HYPageViewStyleB;
    pageView.topTabBounces = YES;
    pageView.isAnimated = YES;
    pageView.selectedColor = kRedColor;
    pageView.unselectedColor = kColorFromStr(@"576268");
    pageView.topTabBottomLineColor = kColorFromStr(@"e8e8e8");;
    pageView.font = PFRegularFont(16);
    pageView.bodyPageBounces = NO;
    [self.view addSubview:pageView];
    [self setupNavi];
    
    
}

-(void)setupNavi
{
    [self addRightTwoBarButtonsWithFirstImage:kImageFromStr(@"more") firstAction:@selector(publishAction) secondImage:kImageFromStr(@"increase") secondAction:@selector(addAction)];

}



-(void)publishAction
{
    
    UIView * v;
    for (UIView *view in self.navigationItem.rightBarButtonItem.customView.subviews) {
        if (view.tag == 0) {
            v = view;
        }
    }
    
    
    [YBPopupMenu showRelyOnView:v titles:@[LocalizedString(@"Dis_PostVideo"),LocalizedString(@"Dis_Postpic"),LocalizedString(@"Dis_Search")] icons:@[@"release_0",@"release_1",@"release_2"] menuWidth:170 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 16;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = [kBlackColor colorWithAlphaComponent:0.7];
        popupMenu.tag = v.tag;
        popupMenu.itemHeight = 42;

    }];

}
-(void)addAction
{
    UIView * v;
    for (UIView *view in self.navigationItem.rightBarButtonItem.customView.subviews) {
        if (view.tag == 1) {
            v = view;
        }
    }
    [YBPopupMenu showRelyOnView:v titles:@[LocalizedString(@"Dis_AddGroupChat"),LocalizedString(@"Dis_AddFriend")] icons:@[@"qunliao_1",@"jiahaoyou"] menuWidth:190 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 16;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = [kBlackColor colorWithAlphaComponent:0.7];
        popupMenu.tag = v.tag;
        popupMenu.itemHeight = 42;
    }];

}
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (ybPopupMenu.tag == 0) {//发布
        if (index == 0) {
            if ([Utilities isExpired]) {
                [self gotoLoginVC];
            }else{
                YWCircleIssueController *vc = [[YWCircleIssueController alloc] init];
                vc.type = 0;
//                vc.groupModel = _saveModel;
                kNavPush(vc);
            }
        }else if(index == 1){
            if ([Utilities isExpired]) {
                [self gotoLoginVC];
            }else{
                YWCircleIssueController *vc = [YWCircleIssueController new];
                vc.type = 1;
//                vc.groupModel = _saveModel;
                kNavPush(vc);
            }
        }else{
            //搜索
            YWCircleSearchController *vc = [YWCircleSearchController new];
            kNavPush(vc);
        }

    }else{//添加好友
        if ([Utilities isExpired]) {
            [self gotoLoginVC];
        }else{
            
            if (index == 0) {
                
//                kNavPush([YWGroupMemberEditController new]);

            }else{

            }
        }

    }
}



@end
