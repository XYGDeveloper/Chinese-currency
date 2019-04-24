//
//  HBIdentifyFailureTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBIdentifyFailureTableViewController.h"

@interface HBIdentifyFailureTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *failureLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@end

@implementation HBIdentifyFailureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kThemeColor;
    self.failureLabel.text = kLocat(@"Identify Verify failure");
    self.tipsLabel.text = kLocat(@"Identify Verify tips");
    [self.tryAgainButton setTitle:kLocat(@"Identify Verify try again") forState:UIControlStateNormal];
}

+ (instancetype)fromStoryboard {
    return  [[UIStoryboard storyboardWithName:@"Verify" bundle:nil] instantiateViewControllerWithIdentifier:@"HBIdentifyFailureTableViewController"];
}

- (IBAction)tryAgainAction:(id)sender {
    [self.view removeFromSuperview];
    [self didMoveToParentViewController:nil];
}

@end
