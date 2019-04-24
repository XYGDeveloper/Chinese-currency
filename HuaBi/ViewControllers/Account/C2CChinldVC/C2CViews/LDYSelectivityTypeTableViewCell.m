//
//  LDYSelectivityTypeTableViewCell.m
//  HuaBi
//
//  Created by l on 2018/10/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "LDYSelectivityTypeTableViewCell.h"
#import "PayModel.h"

@implementation LDYSelectivityTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp1];
    }
    return self;
}


-(void)setUp1{
    self.contentView.backgroundColor = kColorFromStr(@"#F4F4F4");
    self.selectIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 16, 16)];
    [self.selectIV setImage:[UIImage imageNamed:@"noselect"]];
    [self.contentView addSubview:self.selectIV];
    self.paymodeIMG = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectIV.frame)+5, 11, 22, 22)];
    [self.contentView addSubview:self.paymodeIMG];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.paymodeIMG.frame)+5,11, 120, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.nameLabel.textColor = [UIColor blackColor];
    //    self.titleLabel.font = [UIFont ldy_fontFor2xPixels:22];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    self.nankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame),11, 100, 20)];
    self.nankNameLabel.textColor = [UIColor blackColor];
    self.nankNameLabel.font = [UIFont systemFontOfSize:12.0f];
    //    self.titleLabel.font = [UIFont ldy_fontFor2xPixels:22];
    self.nankNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nankNameLabel];
    self.qrIMG = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 40 - 22, 11, 22, 22)];
    [self.contentView addSubview:self.paymodeIMG];
    [self.contentView addSubview:self.qrIMG];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshWithModel:(id)model{
    if ([model isKindOfClass:[bankModel class]]) {
        bankModel *bankmodel = (bankModel *)model;
        self.nameLabel.text = bankmodel.truename;
        self.nankNameLabel.text = bankmodel.bname;
        self.nankNumberLabel.text =bankmodel.cardnum;
    }else if ([model isKindOfClass:[AlipayModel class]]){
        AlipayModel *alipaymodel = (AlipayModel *)model;
        self.nameLabel.text = alipaymodel.cardnum;
        self.paymodeIMG.image = [UIImage imageNamed:@"gmxq_icon_zfb"];
        self.qrIMG.contentMode = UIViewContentModeScaleAspectFit;
        [self.qrIMG setImageWithURL:[NSURL URLWithString:alipaymodel.img] placeholder:[UIImage imageNamed:@"shou_icon_ewm"]];
        self.nankNameLabel.text = alipaymodel.cardnum;
    }else{
        WechatModel *wechatmodel = (WechatModel *)model;
        self.nameLabel.text = wechatmodel.cardnum;
        self.paymodeIMG.image = [UIImage imageNamed:@"gmxq_icon_wx"];
        self.qrIMG.contentMode = UIViewContentModeScaleAspectFit;
        [self.qrIMG setImageWithURL:[NSURL URLWithString:wechatmodel.img] placeholder:[UIImage imageNamed:@"shou_icon_ewm"]];
        self.nankNameLabel.text = wechatmodel.cardnum;
    }
    
}

@end
