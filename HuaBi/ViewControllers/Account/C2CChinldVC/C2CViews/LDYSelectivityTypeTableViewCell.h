//
//  LDYSelectivityTypeTableViewCell.h
//  HuaBi
//
//  Created by l on 2018/10/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDYSelectivityTypeTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nankNameLabel;
@property (nonatomic, strong) UILabel *nankNumberLabel;
@property (nonatomic, strong) UIImageView *selectIV;
@property (nonatomic, strong) UIImageView *paymodeIMG;
@property (nonatomic, strong) UIImageView *qrIMG;

- (void)refreshWithModel:(id)model;


@end

NS_ASSUME_NONNULL_END
