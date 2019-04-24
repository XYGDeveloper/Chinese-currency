//
//  YWCircleListCell.m
//  ywshop
//
//  Created by 周勇 on 2017/10/26.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleListCell.h"
#import "KNPhotoBrower.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface YWCircleListCell ()<KNPhotoBrowerDelegate>

@property (strong, nonatomic)  UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodPic;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIView *circleView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleButtonWidth;

//保存图片的数组和视图
@property(nonatomic,strong)NSMutableArray *itemsArray;



//圈子
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLetfMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarLeftMargin;

@property (weak, nonatomic) IBOutlet UILabel *line;

@property (weak, nonatomic) IBOutlet UIImageView *circle;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end

@implementation YWCircleListCell

-(void)setType:(NSInteger)type
{
    _type = type;
    if (_type == 1) {
        _line.hidden = YES;
        _circle.hidden = YES;
        _bgView.hidden = YES;
        _avatarLeftMargin.constant = 12;
        _contentLetfMargin.constant = 64;
        _bottomMargin.constant = 20;
        self.contentView.backgroundColor = kWhiteColor;
    }
}

-(void)setModel:(YWDynamicModel *)model
{
    _model = model;

    if (model.comment.count == 0) {
        [_commentButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [_commentButton setTitle:[NSString stringWithFormat:@"%zd",model.comment.count] forState:UIControlStateNormal];
    }
    
    CGFloat DistrictViewWith = kScreenW - 12 - 8 - 20;
    if (_type == 1) {
        DistrictViewWith = kScreenW - 64 - 20;
    }
    
    
    _itemsArray = [NSMutableArray array];

    _nameLabel.text = model.username;

    
//    _timeLabel.text = [NSString stringWithFormat:@"%@  %@",model.add_time,model.location];
    _timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.add_time.longLongValue] diff2now];
    
    NSString *header = model.userhead;
    if (![header hasPrefix:@"http"]) {
        header = [NSString stringWithFormat:@"%@%@",kBasePath,model.userhead];
    }
    [_avatar setImageWithURL:header.ks_URL placeholder:[UIImage imageNamed:@"a_img"]];
    
    _attentionButton.selected = model.is_follow.intValue;
    
    if (_attentionButton.isSelected) {
        kViewBorderRadius(_attentionButton, 12, 0.5, kColorFromStr(@"#8e8e8e"));
    }else{
        kViewBorderRadius(_attentionButton, 12, 0.5, kColorFromStr(@"#5d92d8"));
    }
    
    
    
    if (kUserInfo.uid == model.member_id.integerValue) {
        _attentionButton.hidden = YES;
    }else{
        _attentionButton.hidden = NO;
    }
    
    //文字
    [_topView removeAllSubviews];
    if (model.content == nil || [model.content isEqualToString:@""]) {
        _topViewHeight.constant = 0;
        _topViewTopMargin.constant = 0;
    }else{
        [_topView addSubview:_contentLabel];
        //计算带行间距的size
        CGSize labelSize = [Utilities getSpaceLabelHeight:model.content withFont:PFRegularFont(14) withWidth:DistrictViewWith lineSpace:UILABEL_LINE_SPACE];
        
        _contentLabel.text = model.content;

        [UILabel changeLineSpaceForLabel:_contentLabel WithSpace:UILABEL_LINE_SPACE];
        
        _contentLabel.frame = kRectMake(0, 0, labelSize.width, labelSize.height);
        _topViewHeight.constant = labelSize.height;
        _topViewTopMargin.constant = 10;
    }
    
    if ([model.attachments_type isEqualToString:@"video"]) {
        
        [_picView removeAllSubviews];
        _picViewHeight.constant = OnePicWidth;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:kRectMake(0, 0, OnePicWidth, OnePicWidth)];
        [img setImageWithURL:model.attachments_thumbnail.ks_URL placeholder:[UIImage imageNamed:@"zhanweitu"]];
        [_picView addSubview:img];
        img.userInteractionEnabled = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideoAction)]];
        UIImageView *playImg = [[UIImageView alloc]initWithFrame:kRectMake(0, 0, 40, 40)];
        [img addSubview:playImg];
        playImg.image = [UIImage imageNamed:@"zanting"];
        [playImg alignVertical];
        [playImg alignHorizontal];
        
    }else{
        //图片
        CGFloat margin = 5;
        CGFloat picW = (DistrictViewWith - margin * 2) / 3;
        if (model.attachments.count == 0) {
            _picViewHeight.constant = 0;
        }else if (model.attachments.count == 1){
            _picViewHeight.constant = OnePicWidth;
        }else if (model.attachments.count < 4){
            _picViewHeight.constant = picW;
        }else if(model.attachments.count < 7){
            _picViewHeight.constant = picW * 2 + margin;
        }else{
            _picViewHeight.constant = DistrictViewWith;
        }
        
        [_picView removeAllSubviews];
        for (NSInteger i = 0; i < model.attachments.count; i++) {
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            if (model.attachments.count == 4) {
                row = i / 2;
                col = i % 2;
            }
            if (model.attachments.count == 1) {
                picW = OnePicWidth;
            }
            CGFloat x = col * (picW + margin);
            CGFloat y = row * (picW + margin);
            UIImageView *img = [[UIImageView alloc]initWithFrame:kRectMake(x, y, picW, picW)];

            img.contentMode = UIViewContentModeScaleAspectFill;
            img.clipsToBounds = YES;

            [_picView addSubview:img];
            [img setImageWithURL:[NSURL URLWithString:model.attachments[i][@"image"]] placeholder:[UIImage imageNamed:@"zhanweitu"]];
            img.userInteractionEnabled = YES;
            img.tag = i;
            [img addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickImageView:)]];
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
//            items.url = model.attachments[i][@"image"];
            
            items.sourceImage = kImageFromStr(@"tu_1");
//            items.sourceImage = object;

            items.sourceView = img;
            [self.itemsArray addObject:items];
        }
    }
    if (model.attachments.count == 0) {//图片顶部的边距
        _picViewTopMargin.constant = 0;
    }else{
        _picViewTopMargin.constant = 16;
    }
    
    //商品链接
    if (model.goods_url.length < 3) {
        _goodsViewHeight.constant = 0;
        _goodsViewTopMargin.constant= 0;
    }else{
        _goodsViewHeight.constant = 60;
        _goodsViewTopMargin.constant = 10;
        //给商品赋值
        _goodNameLabel.text = model.goods_name;
        [_goodPic setImageWithURL:model.goods_image_url.ks_URL placeholder:kImageFromStr(kImagePlaceHolder)];
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    }
    //圈子
//    NSString *circleTitle = @"广东深圳圈";
//    
//    CGFloat buttonW = [Utilities calculateWidthAndHeightWithWidth:1000 height:1000 text:circleTitle font:PFRegularFont(12)].size.width;
//    _circleButtonWidth.constant = buttonW + 3 + 11 + 7;
//    [_circleButton setTitle:circleTitle forState:UIControlStateNormal];
    
    //点👍
    _likeButton.selected = model.is_like.intValue;
    model.likes.intValue == 0 ? [_likeButton setTitle:@"" forState:UIControlStateNormal]:[_likeButton setTitle:model.likes forState:UIControlStateNormal];
    //评论
    [_commentView removeAllSubviews];
    CGFloat y = 0;
    if (model.comment.count == 0) {
        _commentViewTopMargin.constant = 0;
        _commentViewHeight.constant = 0;
        y = 0;
    }else{
        _commentViewTopMargin.constant = 15;

        NSInteger commentCount = model.comment.count > 3 ? 3:model.comment.count;
        for (NSInteger i = 0; i < commentCount; i++) {
            NSString *commentStr ;
            NSString *userName = model.comment[i][@"username"];
            NSString *replyName = model.comment[i][@"reply_username"];
            if ([model.comment[i][@"parent_id"] integerValue] == 0) {//不是回复的评论
                commentStr = [NSString stringWithFormat:@"%@: %@",model.comment[i][@"username"],model.comment[i][@"content"]];
            }else{//评论回复.
                commentStr = [NSString stringWithFormat:@"%@%@%@: %@",model.comment[i][@"username"],kLocat(@"C_reply"),model.comment[i][@"reply_username"],model.comment[i][@"content"]];
            }
            
            CGSize size = [Utilities calculateWidthAndHeightWithWidth:DistrictViewWith height:CGFLOAT_MAX text:commentStr font:PFRegularFont(14)].size;
            
            UILabel *commentLabel = [[UILabel alloc]initWithFrame:kRectMake(0, y, size.width, size.height)];
            
            [_commentView addSubview:commentLabel];
            commentLabel.tag = i;
            commentLabel.font = PFRegularFont(14);
            //            commentLabel.textColor = kColorFromStr(@"#486ca8");
            commentLabel.textColor = kColorFromStr(@"adadad");
            //            commentLabel.text = commentStr;
            commentLabel.numberOfLines = 0;
            commentLabel.userInteractionEnabled = YES;
            y = y + size.height;
            [commentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickComment:)]];
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:commentStr];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:k323232Color
                                  range:NSMakeRange(0, commentStr.length)];
//            [attributedStr addAttribute:NSForegroundColorAttributeName
//                                  value:kColorFromStr(@"#486ca8")
//                                  range:NSMakeRange(0, userName.length)];
            
//            if (replyName && [commentStr containsString:replyName]) {
//                [attributedStr addAttribute:NSForegroundColorAttributeName
//                                      value:kColorFromStr(@"#486ca8")
//                                      range:NSMakeRange(userName.length + 2, replyName.length)];

//            }
            
            
            commentLabel.attributedText = attributedStr;
        }
        
        if (model.comment.count > 3) {//多余三条
            UIButton *showMoreButton = [[UIButton alloc]initWithFrame:kRectMake(0, y+2, 150, 14)];
            [showMoreButton setTitle:kLocat(@"Dis_ViewAllComment") forState:UIControlStateNormal];
            showMoreButton.titleLabel.font = PFRegularFont(14);
            showMoreButton.userInteractionEnabled = NO;
            showMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [showMoreButton setTitleColor:k323232Color forState:UIControlStateNormal];
            _showMoreButton = showMoreButton;
            [_commentView addSubview:showMoreButton];
            //            [showMoreButton addTarget:self action:@selector(didClickShowMoreButton:) forControlEvents:UIControlEventTouchUpInside];
            y += 14 + 2;
        }
        
    }
    
    _commentViewHeight.constant = y;
    
    
}

-(void)didClickComment:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(commnetLabel:userDidClickJSYCircleListCellCommentWithInfo:)]) {
        [self.delegate commnetLabel:tap.view userDidClickJSYCircleListCellCommentWithInfo:_model.comment[tap.view.tag]];
    }
}
//视频
-(void)playVideoAction
{
    UIViewController *vc = [kKeyWindow visibleViewController];
    
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    // 创建AVPlayer实例, 绑定URL
    AVPlayer *player = [[AVPlayer alloc] initWithURL:[_model.attachments.firstObject[@"video"] ks_URL]];
    // 将AVPlayer实例(能播放视频)赋值给PlayerVC(容器)
    playerVC.player = player;
    
    [player play];
    
    [vc presentViewController:playerVC animated:YES completion:nil];
}

#pragma mark - 图片浏览
-(void)didClickImageView:(UITapGestureRecognizer *)tap
{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = self.itemsArray;
    photoBrower.currentIndex = tap.view.tag;
    photoBrower.isNeedRightTopBtn = NO;
    photoBrower.isNeedPageNumView = NO;
    photoBrower.isNeedPageControl = YES;
    photoBrower.delegate = self;
    [photoBrower present];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)photoBrowerWillDismiss
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index;
{
}

-(void)didClickGoodsView
{
//    YWBaseWebController *webVC = [[YWBaseWebController alloc]initWithWebViewFrame:kScreenBounds title:@""];
//    webVC.urlStr = _model.goods_url;
//
//    UIViewController *vc = [kKeyWindow visibleViewController];
//    [vc.navigationController pushViewController:webVC animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    self.contentView.backgroundColor = kColorFromStr(@"f5f5f5");
    self.selectionStyle = 0;
    _circleButton.backgroundColor = kColorFromStr(@"#f3f3f3");
    [_circleButton setTitleColor:kColorFromStr(@"bababa") forState:UIControlStateNormal];
    _circleButton.ba_padding = 3;
    _circleButton.titleLabel.font = PFRegularFont(12);
    kViewBorderRadius(_circleButton, 11, 0, kRedColor);
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = kColorFromStr(@"555555");
    _contentLabel.font = PFRegularFont(14);
    _contentLabel.numberOfLines = 0;
    
    kViewBorderRadius(_goodsView, 0, 0.5, kColorFromStr(@"bcbcbc"));
    _goodNameLabel.textColor = kColorFromStr(@"555555");
    _goodNameLabel.font = PFRegularFont(14);
    _priceLabel.font = PFRegularFont(16);
    _priceLabel.textColor = kColorFromStr(@"f4b80f");
    
    
    
    [_commentButton setTitleColor:kColorFromStr(@"#adadad") forState:UIControlStateNormal];
    _commentButton.titleLabel.font = PFRegularFont(14);
    
    _likeButton.titleLabel.font = PFRegularFont(14);
    [_likeButton setTitleColor:kColorFromStr(@"#adadad") forState:UIControlStateNormal];
    [_likeButton setTitleColor:kColorFromStr(@"#adadad") forState:UIControlStateSelected];
    
    

    self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.likeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    
    
    _nameLabel.textColor = k323232Color;
    _nameLabel.font = PFRegularFont(14);
    _timeLabel.textColor = kColorFromStr(@"8c8c8c");
    _timeLabel.font = PFRegularFont(10);

    
    _attentionButton.titleLabel.font = PFRegularFont(14);
    [_attentionButton setTitle:LocalizedString(@"Dis_AddAttention") forState:UIControlStateNormal];
    [_attentionButton setTitle:LocalizedString(@"Dis_AttentionEd") forState:UIControlStateSelected];
    [_attentionButton setTitleColor:kColorFromStr(@"#5d92d8") forState:UIControlStateNormal];
    [_attentionButton setTitleColor:kColorFromStr(@"#8e8e8e") forState:UIControlStateSelected];
    _attentionButton.SG_eventTimeInterval = 1.2;
    _attentionButton.backgroundColor = kWhiteColor;
    [_attentionButton setImage:nil forState:UIControlStateSelected];
    
    _attentionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    _likeButton.SG_eventTimeInterval = 1.2;
    
    _goodsView.userInteractionEnabled = YES;
    [_goodsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickGoodsView)]];
    
    _bottomLine.backgroundColor = kColorFromStr(@"f5f5f5");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
