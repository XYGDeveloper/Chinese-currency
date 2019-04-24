
//
//  YWCircleSpaceListCell.m
//  ywshop
//
//  Created by 周勇 on 2017/11/6.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleSpaceListCell.h"
#import "KNPhotoBrower.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIWindow+PazLabs.h"

@interface YWCircleSpaceListCell ()<KNPhotoBrowerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
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


@property (strong, nonatomic)  UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodPic;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;



@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


//保存图片的数组和视图
@property(nonatomic,strong)NSMutableArray *itemsArray;
@end

@implementation YWCircleSpaceListCell



-(void)setModel:(YWDynamicModel *)model
{
    _model = model;
    CGFloat DistrictViewWith = kScreenW - 91 - 22;
    
    if (model.comment.count == 0) {
        [_commentButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [_commentButton setTitle:[NSString stringWithFormat:@"%zd",model.comment.count] forState:UIControlStateNormal];
    }
    //删除按钮
    _deleteButton.hidden = kUserInfo.uid == model.member_id.integerValue?NO:YES;
    
//    NSArray *timeArr = [model.add_time componentsSeparatedByString:@" "];
    
    NSString *time = [[NSDate dateWithTimeIntervalSince1970:model.add_time.longLongValue] diff2now];
//    NSArray *timeArr = [time componentsSeparatedByString:@" "];

    if ([time containsString:@":"]) {
        NSArray *timeArr = [time componentsSeparatedByString:@" "];
        _timeLabel.text = timeArr.lastObject;
        _dataLabel.text = timeArr.firstObject;
    }else{
        _dataLabel.text = time;
        _timeLabel.text = @"";
    }
    
//    if (timeArr.count > 1) {
//        _timeLabel.text = timeArr.lastObject;
//        _dataLabel.text = [timeArr.firstObject substringFromIndex:5];
//    }else{
//        _dataLabel.text = model.add_time;
//        _timeLabel.text = @"";
//    }
    
    
    
    _itemsArray = [NSMutableArray array];
    //文字
    [_topView removeAllSubviews];
    if (model.content == nil || [model.content isEqualToString:@""]) {
        _topViewHeight.constant = 0;
        _topViewTopMargin.constant = 0;
    }else{
        [_topView addSubview:_contentLabel];
//        _contentLabel.backgroundColor = kRedColor;
        //计算带行间距的size
        CGSize labelSize = [Utilities getSpaceLabelHeight:model.content withFont:PFRegularFont(14) withWidth:DistrictViewWith lineSpace:UILABEL_LINE_SPACE];
        
        _contentLabel.text = model.content;
        
        [UILabel changeLineSpaceForLabel:_contentLabel WithSpace:UILABEL_LINE_SPACE];
        
        _contentLabel.frame = kRectMake(0, 0, labelSize.width, labelSize.height);
        _topViewHeight.constant = labelSize.height;
        _topViewTopMargin.constant = 12;
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
            img.contentMode = UIViewContentModeScaleAspectFit;
            [_picView addSubview:img];
            [img setImageWithURL:[NSURL URLWithString:model.attachments[i][@"image"]] placeholder:[UIImage imageNamed:@"zhanweitu"]];
            img.userInteractionEnabled = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.clipsToBounds = YES;
            img.tag = i;
            [img addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickImageView:)]];
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.url = model.attachments[i][@"image"];
            items.sourceView = img;
            [self.itemsArray addObject:items];
        }
    }
    if (model.attachments.count == 0) {//图片顶部的边距
        _picViewTopMargin.constant = 0;
    }else{
        _picViewTopMargin.constant = 19;
    }
    //商品链接
    if (model.goods_url .length < 4) {
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
    NSString *circleTitle = @"广东深圳圈";
    
    CGFloat buttonW = [Utilities calculateWidthAndHeightWithWidth:1000 height:1000 text:circleTitle font:PFRegularFont(12)].size.width;
    _circleButtonWidth.constant = buttonW + 3 + 11 + 7;
    [_circleButton setTitle:circleTitle forState:UIControlStateNormal];
    
    //点👍
    _likeButton.selected = model.is_like.intValue;
    model.likes.intValue == 0 ? [_likeButton setTitle:@"" forState:UIControlStateNormal]:[_likeButton setTitle:model.likes forState:UIControlStateNormal];
    //评论
    [_commentView removeAllSubviews];
    CGFloat y = 0;
    if (model.comment_count.intValue == 0) {
        _commentViewTopMargin.constant = 0;
        _commentViewHeight.constant = 0;
        
    }else{
        _commentViewTopMargin.constant = 9;
        
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
//            
//            if (replyName && [commentStr containsString:replyName]) {
//                [attributedStr addAttribute:NSForegroundColorAttributeName
//                                      value:kColorFromStr(@"#486ca8")
//                                      range:NSMakeRange(userName.length + 2, replyName.length)];
//            }
            
            
            commentLabel.attributedText = attributedStr;
        }
        
        if (model.comment.count > 3) {//多余三条
            UIButton *showMoreButton = [[UIButton alloc]initWithFrame:kRectMake(0, y+2, 105, 14)];
            [showMoreButton setTitle:kLocat(@"Dis_ViewAllComment") forState:UIControlStateNormal];
           showMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            showMoreButton.titleLabel.font = PFRegularFont(14);
            showMoreButton.userInteractionEnabled = NO;
            [showMoreButton setTitleColor:k323232Color forState:UIControlStateNormal];
            showMoreButton = showMoreButton;
            [_commentView addSubview:showMoreButton];
            //            [showMoreButton addTarget:self action:@selector(didClickShowMoreButton:) forControlEvents:UIControlEventTouchUpInside];
            y += 14 + 2;
        }
        
    }
    
    _commentViewHeight.constant = y;

}

-(void)didClickComment:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(comment:userDidClickYWCircleSpaceListCellCommentWithInfo:)]) {
        [self.delegate comment:tap.view userDidClickYWCircleSpaceListCellCommentWithInfo:_model.comment[tap.view.tag]];
    }
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

-(void)didClickGoodsView
{
    BaseWebViewController *webVC = [[BaseWebViewController alloc]initWithWebViewFrame:kScreenBounds title:@""];
    webVC.urlStr = _model.goods_url;
    
    UIViewController *vc = [kKeyWindow visibleViewController];
    [vc.navigationController pushViewController:webVC animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    _circleButton.backgroundColor = kColorFromStr(@"#dfdfdf");
    [_circleButton setTitleColor:kColorFromStr(@"bababa") forState:UIControlStateNormal];
    _circleButton.ba_padding = 3;
    _circleButton.titleLabel.font = PFRegularFont(12);
    kViewBorderRadius(_circleButton, 10, 0, kRedColor);
    
    
    _deleteButton.titleLabel.font = PFRegularFont(12);
    _timeLabel.font = PFRegularFont(8);
    _dataLabel.font = PFRegularFont(10);
    
    
    
    
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = kColorFromStr(@"8c8c8c");
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
    

    
    _dataLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    
    _goodsView.userInteractionEnabled = YES;
    [_goodsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickGoodsView)]];
    
    [_deleteButton setTitle:kLocat(@"Dis_Delete") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
