//
//  TPOTCPostCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostCell.h"
#import "NSObject+SVProgressHUD.h"

@interface TPOTCPostCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *midView;

@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sumTopMargin;


@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *dealSum;
@property (weak, nonatomic) IBOutlet UILabel *postVolume;
@property (weak, nonatomic) IBOutlet UILabel *limtPrice;


@property (weak, nonatomic) IBOutlet UIView *divideView;





@end

@implementation TPOTCPostCell


-(void)setType:(NSInteger)type
{
    _type = type;
    /**  0 买  1 卖  */

    if (_type == 0) {
        _sliderView.hidden = YES;
        _sumTopMargin.constant = 50 + 30;
        self.divideView.hidden = YES;
        self.allButton.hidden = YES;
    }else{
        _sliderView.hidden = NO;
        _sumTopMargin.constant = 135 + 30;
        self.divideView.hidden = NO;
        self.allButton.hidden = NO;
    }
    NSString *typeString = _type == 0 ? kLocat(@"OTC_main_buy") : kLocat(@"OTC_main_sell");
    NSString *postVolumeText = [NSString stringWithFormat:@"%@%@", typeString, kLocat(@"OTC_post_volume")];
    _postVolume.text = postVolumeText;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor =  kColorFromStr(@"#0B132A");
    
    _priceTF.placeholder = @"0.0000";
    _priceTF.superview.backgroundColor = kClearColor;
    _priceTF.textColor = kLightGrayColor;
    _priceTF.font = PFRegularFont(14);
    kTextFieldPlaceHoldColor(_priceTF, kDarkGrayColor);
    
    _volumeTF.placeholder = @"0.000000";
    _volumeTF.textColor = kLightGrayColor;
    _volumeTF.font = PFRegularFont(14);
    kTextFieldPlaceHoldColor(_volumeTF, kDarkGrayColor);
    
    
    _limitMarkLabel1.textColor = kLightGrayColor;
    _limitMarkLabel1.font = PFRegularFont(14);
    _limitMarkLabel2.textColor = kLightGrayColor;
    _limitMarkLabel2.font = PFRegularFont(14);
    
    _sumMarkLabel.font = PFRegularFont(12);
    _sumMarkLabel.textColor = kLightGrayColor;
    
    _ownVolumeLabel.textColor = kLightGrayColor;
    _ownVolumeLabel.font = PFRegularFont(12);
    
    _limiteInfoLabel.font = PFRegularFont(12);
    _limiteInfoLabel.adjustsFontSizeToFitWidth = YES;
    _limiteInfoLabel.minimumScaleFactor = 0.8;
    
    
    _limiteLowButton.titleLabel.font = PFRegularFont(12);
    [_limiteLowButton setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [_limiteLowButton setImage:kImageFromStr(@"kuang_icon") forState:UIControlStateNormal];
    [_limiteLowButton setImage:kImageFromStr(@"kuang_icon_gou") forState:UIControlStateSelected];

    
    _limiteHighButton.titleLabel.font = PFRegularFont(12);
    [_limiteHighButton setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [_limiteHighButton setImage:kImageFromStr(@"kuang_icon") forState:UIControlStateNormal];
    [_limiteHighButton setImage:kImageFromStr(@"kuang_icon_gou") forState:UIControlStateSelected];

    _limiteLowButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    _limiteLowButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    _limiteHighButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    _limiteHighButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    

    _remarkTV.placeholder = kLocat(@"OTC_view_necessary");
    _remarkTV.backgroundColor = kClearColor;
    _remarkTV.font = PFRegularFont(14);
    _remarkTV.textColor = kLightGrayColor;
    _remarkTV.delegate = self;
    
    _lowLimitTF.textColor = kLightGrayColor;
    _lowLimitTF.font = PFRegularFont(14);
    
    _highLimitTF.textColor = kLightGrayColor;
    _highLimitTF.font = PFRegularFont(14);
    
//    _sumTF.superview.backgroundColor = kClearColor;
    _sumTF.textColor = kLightGrayColor;
    _sumTF.font = PFRegularFont(14);
    _sumTF.placeholder = @"0.00";
    kTextFieldPlaceHoldColor(_sumTF, kDarkGrayColor);
    
    
    kViewBorderRadius(_lowLimitTF.superview, 0, 0.5, kColorFromStr(@"#37415C"));
    kViewBorderRadius(_highLimitTF.superview, 0, 0.5, kColorFromStr(@"#37415C"));
//    kViewBorderRadius(_sumTF.superview, 0, 0.5, kColorFromStr(@"#707589"));
    
    kViewBorderRadius(_topView, 0, 0.5, kColorFromStr(@"#37415C"));
    kViewBorderRadius(_midView, 0, 0.5, kColorFromStr(@"#37415C"));
    kViewBorderRadius(_remarkTV.superview, 0, 0.5, kColorFromStr(@"#37415C"));
    kViewBorderRadius(_topView, 0, 0.5, kColorFromStr(@"#37415C"));
    kViewBorderRadius(_topView, 0, 0.5, kColorFromStr(@"#37415C"));
    

//    [_limiteLowButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        weakSelf.limiteLowButton.selected = !weakSelf.limiteLowButton.isSelected;
//
//        weakSelf.lowLimitTF.userInteractionEnabled = weakSelf.limiteLowButton.isSelected;
//
//    }];
//
//    [_limiteHighButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        weakSelf.limiteHighButton.selected = !weakSelf.limiteHighButton.isSelected;
//        weakSelf.highLimitTF.userInteractionEnabled = weakSelf.limiteHighButton.isSelected;
//
//    }];
    
    _dealSum.text = kLocat(@"k_MyassetViewController_tableview_list_cell_right_jye");
   
    _limtPrice.text = kLocat(@"OTC_sinleprice");
    _remark.text = kLocat(@"OTC_view_moneyremark");

    [_limiteLowButton setTitle:kLocat(@"OTC_view_limitelowsum") forState:UIControlStateNormal];
    [_limiteHighButton setTitle:kLocat(@"OTC_view_limitehighsum") forState:UIControlStateNormal];
    
    _lowLimitTF.userInteractionEnabled = NO;
    _highLimitTF.userInteractionEnabled = NO;
    [self.allButton setTitle:kLocat(@"OTC_order_all") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 100) {
        textView.text = [textView.text substringToIndex:100];
        [self showInfoWithMessage:kLocat(@"OTC_Within 100 words")];
    }
}

@end
