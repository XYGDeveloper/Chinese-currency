//
//  YJRegisterCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/1/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJRegisterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *midLine;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *TF;

@property (weak, nonatomic) IBOutlet YLButton *phoneButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIImageView *xiala;
@property (weak, nonatomic) IBOutlet UIView *randomView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
