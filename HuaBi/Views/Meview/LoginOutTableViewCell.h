//
//  LoginOutTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^logiout)(void);
@interface LoginOutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,strong)logiout lout;

@end
