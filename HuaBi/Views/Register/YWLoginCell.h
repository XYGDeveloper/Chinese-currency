//
//  YWLoginCell.h
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWLoginCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfRightMargin;

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;

@end
