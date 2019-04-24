//
//  OnViewController.m
//  YJOTC
//
//  Created by l on 2018/9/21.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "OnViewController.h"

@interface OnViewController ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;


@end

@implementation OnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_onusViewController_title");
    self.dLabel.text = kLocat(@"k_onusViewController_title_detail_des");
    _topMargin.constant = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
