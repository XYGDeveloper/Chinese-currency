//
//  HBOperationDesViewController.m
//  HuaBi
//
//  Created by l on 2018/10/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBOperationDesViewController.h"

@interface HBOperationDesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HBOperationDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_popview_4");
    self.view.backgroundColor = kColorFromStr(@"#0B132A");
    self.contentLabel.attributedText = [self getFormatteStringWithPathy:kLocat(@"k_in_c2c_operation_dis_doc")];
}

- (NSMutableAttributedString *)getFormatteStringWithPathy:(NSString *)para{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:para];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [para length])];
    return attributedString;
}

@end
