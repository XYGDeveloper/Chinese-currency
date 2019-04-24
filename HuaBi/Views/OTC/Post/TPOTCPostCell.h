//
//  TPOTCPostCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFTextView.h"
#import <IQTextView.h>
#import "ZYForbiddenTextField.h"
#import "XNCustomTextfield.h"



@interface TPOTCPostCell : UITableViewCell

/**  0 买  1 卖  */
@property(nonatomic,assign)NSInteger type;


@property (weak, nonatomic) IBOutlet UILabel *limiteInfoLabel;

@property (weak, nonatomic) IBOutlet XNCustomTextfield *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet ZYForbiddenTextField *volumeTF;


@property (weak, nonatomic) IBOutlet UILabel *ownVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UISlider *sslide;
@property (weak, nonatomic) IBOutlet ZYForbiddenTextField *sumTF;

@property (weak, nonatomic) IBOutlet IQTextView *remarkTV;
@property (weak, nonatomic) IBOutlet ZYForbiddenTextField *lowLimitTF;
@property (weak, nonatomic) IBOutlet ZYForbiddenTextField *highLimitTF;


@property (weak, nonatomic) IBOutlet UIButton *limiteHighButton;
@property (weak, nonatomic) IBOutlet UIButton *limiteLowButton;

@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumMarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *limitMarkLabel1;
@property (weak, nonatomic) IBOutlet UILabel *limitMarkLabel2;

@property (weak, nonatomic) IBOutlet UIButton *allButton;//全部
@property (weak, nonatomic) IBOutlet UILabel *currencyMarkLabel;//币种
@property (weak, nonatomic) IBOutlet UILabel *minAndMaxNumberRangeLabel;

@end
