//
//  HBMyAssetDetailTopView.h
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBMyAssetDetailTopView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currencyName;
@property(nonatomic,strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
