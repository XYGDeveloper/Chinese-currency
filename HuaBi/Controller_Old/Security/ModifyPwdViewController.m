//
//  ModifyPwdViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ModifyPwdViewController.h"

@interface ModifyPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwd;

@property (weak, nonatomic) IBOutlet UITextField *cuPwd;

@property (weak, nonatomic) IBOutlet UITextField *conPwd;

@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@end

@implementation ModifyPwdViewController


- (IBAction)commitAction:(id)sender {
    //提交
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_ModifysetViewController_title");
    self.comBtn.layer.cornerRadius = 8;
    self.comBtn.layer.masksToBounds = YES;
    self.oldPwd.placeholder = kLocat(@"k_ModifysetViewController_t1");
    self.cuPwd.placeholder = kLocat(@"k_ModifysetViewController_t2");
    self.conPwd.placeholder = kLocat(@"k_ModifysetViewController_t3");
    [self.comBtn setTitle:kLocat(@"k_ModifysetViewController_b1") forState:UIControlStateNormal];
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
