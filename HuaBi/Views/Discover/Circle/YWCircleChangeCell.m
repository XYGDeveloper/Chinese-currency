//
//  YWCircleChangeCell.m
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleChangeCell.h"


@interface YWCircleChangeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabe;

@end



@implementation YWCircleChangeCell

-(void)setModel:(YWCircleGroupModel *)model
{
    _model = model;
    [_picView setImageURL:_model.group_logo.ks_URL];
    _nameLabel.text = model.group_name;
    
    _infoLabe.text = [NSString stringWithFormat:@"%@ %@  %@ %@",kLocat(@"R_Message"),model.note_count,kLocat(@"R_Popularity"),model.popularity_count];
    
    
    [_changeButton setTitle:kLocat(@"R_SWitch") forState:UIControlStateNormal];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _nameLabel.font = PFRegularFont(16);
    _infoLabe.font = PFRegularFont(12);
    _changeButton.titleLabel.font = PFRegularFont(14);
    kViewBorderRadius(_changeButton, 15, 1, kColorFromStr(@"1eaafa"));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
