//
//  AuthViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_AuthViewController_title");
    self.nameLabel.text = kLocat(@"k_AuthViewController_name");
    self.nameTextField.placeholder = kLocat(@"k_AuthViewController_placehoder");
    self.firstLabel.text = kLocat(@"k_AuthViewController_pc1");
    self.secondLabel.text = kLocat(@"k_AuthViewController_pc2");
    self.thirdLabel.text = kLocat(@"k_AuthViewController_pc3");
    [self.commitBtn setTitle:kLocat(@"k_AuthViewController_comit") forState:UIControlStateNormal];
    [self.pc1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        //
    }]];
    
    [self.pc2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        //
    }]];
    
    [self.pc3 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        //
    }]];
    
}

@end
