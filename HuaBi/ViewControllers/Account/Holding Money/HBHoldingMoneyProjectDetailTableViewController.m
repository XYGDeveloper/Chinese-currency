//
//  HBHoldingMoneyProjectDetailTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHoldingMoneyProjectDetailTableViewController.h"
#import "NSString+ZZ.h"

@interface HBHoldingMoneyProjectDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HBHoldingMoneyProjectDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocat(@"Product introduction");
    NSMutableString *tmp = @"".mutableCopy;
    [self.advantage enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [tmp appendFormat:@"%@\n\n", obj];
        }
    }];
    
    self.contentLabel.attributedText = [tmp.copy attributedStringWithParagraphSize:8];
}




@end
