//
//  BindMailViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BindMailViewController.h"

@interface BindMailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stepleft;
@property (weak, nonatomic) IBOutlet UILabel *stepright;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *vacode;
@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end

@implementation BindMailViewController



- (IBAction)commitAction:(id)sender {
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_BindsetViewController_title");

    self.stepleft.layer.cornerRadius = 15/2;
    self.stepleft.layer.masksToBounds = YES;
    self.stepright.layer.cornerRadius = 15/2;
    self.stepright.layer.masksToBounds = YES;
    self.email.placeholder = kLocat(@"k_BindsetViewController_t1");
    self.vacode.placeholder = kLocat(@"k_BindsetViewController_t2");
    self.leftLabel.text = kLocat(@"k_BindsetViewController_t3");
    self.rightLabel.text = kLocat(@"k_BindsetViewController_t4");
    self.comBtn.layer.cornerRadius = 8;
    self.comBtn.layer.masksToBounds = YES;
    
    [self.comBtn setTitle:kLocat(@"k_BindsetViewController_b1") forState:UIControlStateNormal];
    
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
