//
//  RecommendHeaderViewTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^toselect)(UIButton *sender);
typedef void (^toDefault)(UIButton *sender);

@interface RecommendHeaderViewTableViewCell : UITableViewCell

/*
 我的推荐标签
 */
@property (weak, nonatomic) IBOutlet UILabel *myrecommendLabel;
/*
 我的推荐数
 */
@property (weak, nonatomic) IBOutlet UIButton *recommendCountLabel;

/*
 等级推荐(M1-M6)
 */
@property (weak, nonatomic) IBOutlet UIButton *m1Label;
@property (weak, nonatomic) IBOutlet UIButton *m2label;
@property (weak, nonatomic) IBOutlet UIButton *m3label;
@property (weak, nonatomic) IBOutlet UIButton *m4label;
@property (weak, nonatomic) IBOutlet UIButton *m5label;
@property (weak, nonatomic) IBOutlet UIButton *m6label;

@property (nonatomic,strong)toselect sel;
@property (nonatomic,strong)toDefault defau;

/*
 列表表头
 */
@property (weak, nonatomic) IBOutlet UILabel *label12;

@property (weak, nonatomic) IBOutlet UILabel *label13;
@property (weak, nonatomic) IBOutlet UILabel *label14;

@end

NS_ASSUME_NONNULL_END
