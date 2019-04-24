//
//  AlipayTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AlipayModel;
@class WechatModel;
typedef void (^todelete)(void);
typedef void (^todefault)(void);

@interface AlipayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)todelete del;

@property (nonatomic,strong)todefault defau;
@property (weak, nonatomic) IBOutlet UIButton *debutton;

- (void)refreshWithmodel:(AlipayModel *)model;

- (void)refreshWithWechatmodel:(WechatModel *)model;

@end

NS_ASSUME_NONNULL_END
