//
//  LDYSelectivityTableViewCell.m
//  LDYSelectivityAlertView
//
//  Created by 李东阳 on 2018/8/15.
//

#import "LDYSelectivityTableViewCell.h"
//#import "UIFont+LDY.h"
#import "PayModel.h"
@interface LDYSelectivityTableViewCell()

@end

@implementation LDYSelectivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    self.contentView.backgroundColor = kColorFromStr(@"#F4F4F4");
    self.selectIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 16, 16)];
    [self.selectIV setImage:[UIImage imageNamed:@"noselect"]];
    [self.contentView addSubview:self.selectIV];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectIV.frame)+5,11, 60, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.nameLabel.textColor = [UIColor blackColor];
    //    self.titleLabel.font = [UIFont ldy_fontFor2xPixels:22];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.nankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame),11, 80, 20)];
    self.nankNameLabel.textColor = [UIColor blackColor];
    self.nankNameLabel.font = [UIFont systemFontOfSize:12.0f];
    //    self.titleLabel.font = [UIFont ldy_fontFor2xPixels:22];
    self.nankNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nankNameLabel];
    
    self.nankNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nankNameLabel.frame),11, kScreenW -40 - 25-20-60-80, 20)];
    self.nankNumberLabel.textColor = [UIColor blackColor];
    self.nankNumberLabel.font = [UIFont systemFontOfSize:12.0f];
    //    self.titleLabel.font = [UIFont ldy_fontFor2xPixels:22];
    self.nankNumberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.nankNumberLabel];
    
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
        [self.qrIMG setImageURL:[NSURL URLWithString:alipaymodel.img]];
        self.nankNameLabel.text = alipaymodel.cardnum;
    }else{
        WechatModel *wechatmodel = (WechatModel *)model;
        self.nameLabel.text = wechatmodel.cardnum;
        self.paymodeIMG.image = [UIImage imageNamed:@"gmxq_icon_wx"];
        self.qrIMG.contentMode = UIViewContentModeScaleAspectFit;
        [self.qrIMG setImageURL:[NSURL URLWithString:wechatmodel.img]];
        self.nankNameLabel.text = wechatmodel.cardnum;
    }
}
@end
