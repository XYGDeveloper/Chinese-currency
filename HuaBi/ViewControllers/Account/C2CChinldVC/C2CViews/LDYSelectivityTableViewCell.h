//
//  LDYSelectivityTableViewCell.h
//  LDYSelectivityAlertView
//
//  Created by 李东阳 on 2018/8/15.
//

#import <UIKit/UIKit.h>

@interface LDYSelectivityTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nankNameLabel;
@property (nonatomic, strong) UILabel *nankNumberLabel;
@property (nonatomic, strong) UIImageView *selectIV;
@property (nonatomic, strong) UIImageView *paymodeIMG;
@property (nonatomic, strong) UIImageView *qrIMG;

- (void)refreshWithModel:(id)model;


@end
