//
//  TPOTCPostDetailListCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOTCPostDetailListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *lineView;

/**  0 正常颜色   1  透明色  */
@property(nonatomic,assign)NSInteger type;

@end
