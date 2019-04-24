//
//  RecommendHeaderViewTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "RecommendHeaderViewTableViewCell.h"

@implementation RecommendHeaderViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.m1Label.layer.cornerRadius = 8;
    self.m1Label.layer.masksToBounds = YES;
    self.m2label.layer.cornerRadius = 8;
    self.m2label.layer.masksToBounds = YES;
    self.m3label.layer.cornerRadius = 8;
    self.m3label.layer.masksToBounds = YES;
    self.m4label.layer.cornerRadius = 8;
    self.m4label.layer.masksToBounds = YES;
    self.m5label.layer.cornerRadius = 8;
    self.m5label.layer.masksToBounds = YES;
    self.m6label.layer.cornerRadius = 8;
    self.m6label.layer.masksToBounds = YES;
    // Initialization code
}

- (IBAction)defauAvcvtion:(id)sender {
    if (self.defau) {
        self.defau(sender);
    }
    [self select:nil normalArray:@[self.m1Label,self.m2label,self.m3label,self.m4label,self.m5label,self.m6label]];
}


- (IBAction)m1Action:(UIButton *)sender {
    if (self.sel) {
        self.sel(sender);
    }
    [self select:sender normalArray:@[self.m2label,self.m3label,self.m4label,self.m5label,self.m6label]];
}

- (IBAction)m2Action:(UIButton *)sender {
    if (self.sel) {
        self.sel(sender);
    }
    [self select:sender normalArray:@[self.m1Label,self.m3label,self.m4label,self.m5label,self.m6label]];
}

- (IBAction)m3Action:(UIButton *)sender {
    if (self.sel) {
        self.sel(sender);
    }
    [self select:sender normalArray:@[self.m1Label,self.m2label,self.m4label,self.m5label,self.m6label]];
}


- (IBAction)m4Action:(UIButton *)sender {
    if (self.sel) {
        self.sel(sender);
    }
    [self select:sender normalArray:@[self.m1Label,self.m2label,self.m3label,self.m5label,self.m6label]];
}

- (IBAction)m5Action:(UIButton *)sender {
    if (self.sel) {
        self.sel(sender);
    }
    [self select:sender normalArray:@[self.m1Label,self.m2label,self.m3label,self.m4label,self.m6label]];
}

- (IBAction)m6Action:(UIButton *)sender {
    if (self.sel) {
        self.sel(sender);
    }
    [self select:sender normalArray:@[self.m1Label,self.m2label,self.m3label,self.m4label,self.m5label]];
}

- (void)select:(UIButton *)sender  normalArray:(NSArray *)senders{
    sender.backgroundColor = kColorFromStr(@"#896FED");
    for (UIButton *btn in senders) {
        btn.backgroundColor = kColorFromStr(@"#37415C");
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
