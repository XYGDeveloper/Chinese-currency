//
//  HBAddressListTableViewCell.h
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^setDefault)(UIButton *sender);
typedef void (^edit)(UIButton *sender);
typedef void (^del)(UIButton *sender);

@class HBAddressModel;
@interface HBAddressListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *pName;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *normalAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic,strong)setDefault defau;
@property (nonatomic,strong)edit editor;
@property (nonatomic,strong)del delet;

- (void)refreshWithModel:(HBAddressModel *)model;

@end

NS_ASSUME_NONNULL_END
