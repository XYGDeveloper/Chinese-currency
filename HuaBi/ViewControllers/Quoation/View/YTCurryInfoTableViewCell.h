//
//  YTCurryInfoTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTCurryInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *profile;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label1Content;
@property (weak, nonatomic) IBOutlet UILabel *label2Content;
@property (weak, nonatomic) IBOutlet UILabel *label3Content;
@property (weak, nonatomic) IBOutlet UILabel *label4Content;
@property (weak, nonatomic) IBOutlet UILabel *label5content;

- (void)refresh:(NSDictionary *)dic name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
