//
//  TPOTCBuyOrderDetailView.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 下单 页面
 */
@interface TPOTCBuyOrderDetailView : UIView

@property (weak, nonatomic) IBOutlet UITextField *moneyOrNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyAllButton;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property(nonatomic,strong)TPOTCOrderModel *model;

@property (nonatomic, assign) NSInteger segmentedSelectIndex;

- (void)show;

- (void)hide;

- (NSString *)getNumber;

- (NSString *)getTotalMoney;

- (BOOL)isTypeOfNumber;

@end
