//
//  HBBaseTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"
#import "HBLoginTableViewController.h"
#import "NSObject+SVProgressHUD.h"

@interface HBBaseTableViewController ()

@end

@implementation HBBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initBackButton];

    self.tableView.backgroundColor = kColorFromStr(@"#0B132A");
}
-(void)initBackButton
{
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.hidesBackButton = YES;
    }else{
        [self addLeftBarButtonWithImage:kImageFromStr(@"back_white") action:@selector(backAction)];
    }
}

-(void)showTips:(NSString *)msg
{
    
    if (msg == nil || msg.length == 0) {
        return;
    }
    
    //mbprogress
    [self showInfoWithMessage:msg];
    
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

-(void)gotoLoginVC
{
    UIViewController *vc = [HBLoginTableViewController fromStoryboard];
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
