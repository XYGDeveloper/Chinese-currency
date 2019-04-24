//
//  HBIdentifyVerifyingViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBIdentifyVerifyingViewController.h"

@interface HBIdentifyVerifyingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *verifyingLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation HBIdentifyVerifyingViewController

+ (instancetype)fromStoryboard {
    return  [[UIStoryboard storyboardWithName:@"Verify" bundle:nil] instantiateViewControllerWithIdentifier:@"HBIdentifyVerifyingViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kThemeColor;
    
    
    
    self.verifyingLabel.text = kLocat(@"Verifying");
    self.tipsLabel.text = kLocat(@"Verifying tips");
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
