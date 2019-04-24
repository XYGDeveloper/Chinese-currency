//
//  HBCardTableViewCell.h
//  HuaBi
//
//  Created by l on 2019/2/26.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^leftMenu)(void);
typedef void (^rightMenuTop)(void);
typedef void (^rightMenuBottom)(void);
@interface HBCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *mButton;
@property (weak, nonatomic) IBOutlet UIButton *kefuButton;
@property (nonatomic,strong)leftMenu leftMen;
@property (nonatomic,strong)rightMenuTop topMenu;
@property (nonatomic,strong)rightMenuBottom bottomMenu;

@end

NS_ASSUME_NONNULL_END
