//
//  HBIdentifyVerifyViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBIdentifyVerifyViewController.h"
#import "HBIdentifyVerifyContaineeTableViewController.h"
#import "HBCardModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "HBIdentifyVerifyingViewController.h"
#import "HBIdentifyFailureTableViewController.h"

@interface HBIdentifyVerifyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation HBIdentifyVerifyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocat(@"Identify Verify title");
    [self.submitButton setTitle:kLocat(@"Identify Verify submit") forState:UIControlStateNormal];
    [self _requestInfo];
}

#pragma mark - Public

- (void)showVerifyingVC {
    [self _showVerifyingView];
}

#pragma mark - Private

- (void)_requestInfo {
    [self showLoadingView];
    [HBCardModel requestVerifyInfoWithSuccess:^(HBCardModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        
        switch (model.verify_state) {
            case HBCardModelVerifyStateFailure:
                [self _showFailureVC];
                break;
                
            case HBCardModelVerifyStateUnverify:
                break;
                
            case HBCardModelVerifyStateVerified:
                [self _showVerifiedViewWithModel:model];
                break;
                
            case HBCardModelVerifyStateVerifying:
                [self _showVerifyingView];
                break;
                
                default:
                
                break;
        }
        [self hideLoadingView];
    } failure:^(NSError * _Nonnull error) {
        [self hideLoadingView];
//        [self showErrorWithMessage:error.localizedDescription];
    }];
}

- (void)_showVerifyingView {
    HBIdentifyVerifyingViewController *vc = [HBIdentifyVerifyingViewController fromStoryboard];
    [self _showVC:vc];
}

- (void)_showVerifiedViewWithModel:(HBCardModel *)model {
    HBIdentifyVerifyContaineeTableViewController * vc = [HBIdentifyVerifyContaineeTableViewController fromStoryboard];
    [vc showWithCardModel:model];
    [self _showVC:vc];
}

- (void)_showFailureVC {
    HBIdentifyFailureTableViewController *vc = [HBIdentifyFailureTableViewController fromStoryboard];
    [self _showVC:vc];
}

- (void)_showVC:(UIViewController *)vc {
    [self addChildViewController:vc];
    [vc willMoveToParentViewController:self];
    [self.view addSubview:vc.view];
    vc.view.frame = self.view.bounds;
}

#pragma mark - Actions

- (IBAction)submitAction:(id)sender {
    HBIdentifyVerifyContaineeTableViewController * vc = self.childViewControllers.firstObject;
    [vc submitAction];
}

@end
