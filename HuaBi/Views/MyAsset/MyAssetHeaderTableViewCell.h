//
//  MyAssetHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^hidden)(BOOL ishidden);
@interface MyAssetHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;              //黄色背景
@property (weak, nonatomic) IBOutlet UIButton *selButton;         //选择button
@property (weak, nonatomic) IBOutlet UILabel *tradeType;          //交易类型
@property (weak, nonatomic) IBOutlet UILabel *tradeDetail;        //交易详情
@property (weak, nonatomic) IBOutlet UILabel *tradeCount;         //交易数额
@property (weak, nonatomic) IBOutlet UILabel *tradeConutDetail;   //交易数额详情
@property (nonatomic,strong)hidden hid;

@end

