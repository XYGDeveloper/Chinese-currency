//
//  BindTeleViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BindTeleViewController.h"

@interface BindTeleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stepleft;
@property (weak, nonatomic) IBOutlet UILabel *stepright;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightlabel;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *valcode;
@property (weak, nonatomic) IBOutlet UIButton *valbtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation BindTeleViewController

- (IBAction)commitAction:(id)sender {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = kLocat(@"k_BindphonesetViewController_title");
    self.stepleft.layer.cornerRadius = 15/2;
    self.stepleft.layer.masksToBounds = YES;
    self.stepright.layer.cornerRadius = 15/2;
    self.stepright.layer.masksToBounds = YES;

    self.phone.placeholder = kLocat(@"k_BindphonesetViewController_t1");
    self.valcode.placeholder = kLocat(@"k_BindphoneViewController_t2");
    self.leftLabel.text = kLocat(@"k_BindphoneViewController_t3");
    self.rightlabel.text = kLocat(@"k_BindphoneViewController_t4");
    self.commitBtn.layer.cornerRadius = 8;
    self.commitBtn.layer.masksToBounds = YES;
    [self.commitBtn setTitle:kLocat(@"k_ModifysetViewController_b1") forState:UIControlStateNormal];
    [self.valbtn setTitle:kLocat(@"k_BindphoneViewController_b0") forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
