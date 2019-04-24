//
//  HBTokenWithdrawTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBTokenWithdrawViewController.h"
#import "HBTokenWithdrawContaineeTableViewController.h"
#import "HBTakeTokenRecordViewController.h"
@interface HBTokenWithdrawViewController ()
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic, strong) HBTokenWithdrawContaineeTableViewController *containeeVC;

@end

@implementation HBTokenWithdrawViewController

+ (instancetype)fromStoryboard {
    
    return [[UIStoryboard storyboardWithName:@"TopupAndWithdraw" bundle:nil] instantiateViewControllerWithIdentifier:@"HBTokenWithdrawTableViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = kLocat(@"k_ExchangeRecordViewController_topbar_2");
    self.containeeVC.currencyNameString = self.currency;
    self.containeeVC.currency_id = self.currency_id;
    [self.commitButton setTitle:kLocat(@"HBHomeViewController_address_saveimg_submit") forState:UIControlStateNormal];
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"reco"] action:@selector(recorder)];
}


- (void)recorder{
    HBTakeTokenRecordViewController *recorder = [HBTakeTokenRecordViewController new];
    recorder.currency_id = self.currency_id;
    recorder.type = @"1";
    kNavPush(recorder);
}

- (IBAction)submitAction:(id)sender {
    [self.containeeVC submitAction];
}

#pragma mark - Getters

- (HBTokenWithdrawContaineeTableViewController *)containeeVC {
    if (!_containeeVC) {
        _containeeVC = (HBTokenWithdrawContaineeTableViewController *)self.childViewControllers.firstObject;
    }
    return _containeeVC;
}

@end
