//
//  MyBCBViewController.m
//  YJOTC
//
//  Created by l on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyBCBViewController.h"

@interface MyBCBViewController ()

@end

@implementation MyBCBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cButton.layer.cornerRadius = 4;
    self.cButton.layer.masksToBounds = YES;
    self.title = kLocat(@"k_ExchangeRecordViewController_topbar_1");
    [self.cButton setTitle:kLocat(@"k_mybcbViewController_cbutton") forState:UIControlStateNormal];
    [self.zbButton setTitle:kLocat(@"k_mybcbViewController_zbbutton") forState:UIControlStateNormal];
    self.zbDesLabel.text = kLocat(@"k_mybcbViewController_zbdesbutton");
    // Do any additional setup after loading the view from its nib.
}

//复制钱包地址
- (IBAction)getAddress:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard]; pasteboard.string = self.pAddress.text;
    [self showTips:kLocat(@"k_mybcbViewController_zcopy")];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
