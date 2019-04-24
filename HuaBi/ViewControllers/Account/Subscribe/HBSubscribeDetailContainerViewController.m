//
//  HBSubscribeDetailContainerViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeDetailContainerViewController.h"
#import "HBSubscribeMenuViewController.h"
#import "HBSubscribeDetailTableViewController.h"
#import "HBSubscribeModel+Request.h"
#import "NSObject+SVProgressHUD.h"

@interface HBSubscribeDetailContainerViewController ()

@property (nonatomic, strong) HBSubscribeMenuViewController *menuVC;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;

@end

@implementation HBSubscribeDetailContainerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = kLocat(@"Subscription detail");
    [self setupDetailVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Private

- (void)_requestSubscribeDetail {
    [self startNetworkActivityIndicator];
    [HBSubscribeModel requestSubscribeByID:self.model.ID success:^(HBSubscribeModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        [self stopNetworkActivityIndicator];
        _model = model;
        [self setupDetailVC];
    } failure:^(NSError * _Nonnull error) {
        [self stopNetworkActivityIndicator];
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

- (void)setupDetailVC {
    HBSubscribeDetailTableViewController *detailVC = self.childViewControllers.firstObject;
    detailVC.model = self.model;
//    self.subscribeButton
    [self.subscribeButton setTitle:self.model.statusString forState:UIControlStateNormal];
    self.subscribeButton.backgroundColor = self.model.statusColor;
}

#pragma mark - Actions

- (IBAction)showMenuAction:(id)sender {
    if (self.model.status != HBSubscribeModelStatusCrowdfunding ) {
        return;
    }
    self.menuVC.model = self.model; 
    [self.menuVC showInViewController:self];
}


#pragma mark - Getters

- (HBSubscribeMenuViewController *)menuVC {
    if (!_menuVC) {
        _menuVC = [HBSubscribeMenuViewController fromStoryboard];
        __weak typeof(self) weakSelf = self;
        _menuVC.operatedDoneBlock = ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf performSegueWithIdentifier:@"showSubscribeRecordsVC" sender:nil];
                [weakSelf _requestSubscribeDetail];
            });
        };
    }
    
    return _menuVC;
}

- (void)setModel:(HBSubscribeModel *)model {
    _model = model;
    [self setupDetailVC];
    [self _requestSubscribeDetail];
}

@end
