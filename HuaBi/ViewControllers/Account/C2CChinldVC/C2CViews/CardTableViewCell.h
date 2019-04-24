//
//  CardTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class bankModel;
typedef void (^todelete)(void);
typedef void (^todefault)(void);

@interface CardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgview;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UILabel *bankname;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;
@property (weak, nonatomic) IBOutlet UILabel *countlabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;

@property (nonatomic,strong)todelete del;
@property (nonatomic,strong)todefault defau;

@property (weak, nonatomic) IBOutlet UIButton *defaubutton;

- (void)refreshWithModel:(bankModel *)model;


@end

NS_ASSUME_NONNULL_END
