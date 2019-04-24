//
//  HBHoldingMoneyContainerViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHoldingMoneyContainerViewController.h"
#import "YBPopupMenu.h"
#import "HBMoneyInterestWarpperModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "HBHoldingMoneyContaineeTableViewController.h"
#import "HBHoldingMoneyTransferMenuViewController.h"
#import "HBMoneyInterestRecordsViewController.h"

@interface HBHoldingMoneyContainerViewController () <YBPopupMenuDelegate>

@property (nonatomic, strong) NSArray<NSString *> *items;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectTypeBarButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;

@property (nonatomic, weak) HBHoldingMoneyContaineeTableViewController *containeeVC;
@property (nonatomic, strong) HBHoldingMoneyTransferMenuViewController *menuVC;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation HBHoldingMoneyContainerViewController

#pragma mark - Lifecycle

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"HoldingMoney" bundle:nil] instantiateViewControllerWithIdentifier:@"HBHoldingMoneyContainerViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.items = @[kLocat(@"Money Interest Deposit title"), kLocat(@"Money Interest Records title"), kLocat(@"Money Interest Dividend title"), ];
    self.title = kLocat(@"Money Interest title");
    [self.transferButton setTitle:kLocat(@"Money Interest Transfer button title") forState:UIControlStateNormal];
    [self _requestMoneyInterestModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showInterestRecordsVC"]) {
        HBMoneyInterestRecordsViewController *vc = (HBMoneyInterestRecordsViewController *)segue.destinationViewController;
        vc.recordsType = self.selectedIndex;
    }
}

#pragma mark - Private

- (void)_requestMoneyInterestModel {
    [self showLoadingView];
    
    [HBMoneyInterestWarpperModel requestMoneyInterestWithSuccess:^(HBMoneyInterestWarpperModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        [self hideLoadingView];
        self.containeeVC.warpperModel = model;
    } failure:^(NSError * _Nonnull error) {
        [self showInfoWithMessage:error.localizedDescription];
        [self hideLoadingView];
    }];

}

#pragma mark - Action

- (IBAction)transferAction:(id)sender {
    self.menuVC.model = self.containeeVC.selectedSettingModel;
    [self.menuVC showInViewController:self];
//    [self presentViewController:self.menuVC animated:YES completion:nil];
}

- (IBAction)selectTypeAction:(UIBarButtonItem *)sender {
    [self menuPop];
}

-(void)menuPop {
    
    CGPoint point = [self.navigationController.navigationBar convertPoint:CGPointMake(self.navigationController.navigationBar.right, self.navigationController.navigationBar.bottom - 30) toView:nil];
    [YBPopupMenu showAtPoint:point titles:self.items icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 14;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = kColorFromStr(@"#37415C");
        popupMenu.itemHeight = 44;
        popupMenu.borderWidth = 0;
    }];
    
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    self.selectedIndex = index;
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"showDepositRecordsVC" sender:nil];
            break;
        case 1:
        case 2:
            [self performSegueWithIdentifier:@"showInterestRecordsVC" sender:nil];
        default:
            break;
    }
    
}

#pragma mark - Getters

- (HBHoldingMoneyContaineeTableViewController *)containeeVC {
    if (!_containeeVC) {
        _containeeVC = (HBHoldingMoneyContaineeTableViewController *)self.childViewControllers.firstObject;
    }
    return _containeeVC;
}

- (HBHoldingMoneyTransferMenuViewController *)menuVC {
    if (!_menuVC) {
        _menuVC = [HBHoldingMoneyTransferMenuViewController fromStoryboard];
        __weak typeof(self) weakSelf = self;
        _menuVC.operatedDoneBlock = ^{
            [weakSelf ybPopupMenuDidSelectedAtIndex:0 ybPopupMenu:nil];
            [weakSelf _requestMoneyInterestModel];
        };
    }
    
    return _menuVC;
}

@end
