//
//  JPSalertView.m
//  PopViewOne
//
//  Created by 姜朋升 on 2017/5/22.
//  Copyright © 2017年 闪牛网络. All rights reserved.
//

#import "JPSalertView.h"
#import "alertTableViewCell.h"

@interface JPSalertView()
@property(nonatomic,strong)UIView *bgView;

@end
@implementation JPSalertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    alertTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"alertTableViewCell" owner:nil options:nil] lastObject];
//    head.tradeType.text = kLocat(@"k_MyassetViewController_tableview_header_title");
//    head.tradeDetail.text = kLocat(@"k_MyassetViewController_tableview_header_subtitle");
//    [head.selButton setTitle:kLocat(@"k_MyassetViewController_tableview_header_hideButton") forState:UIControlStateNormal];
//    head.userInteractionEnabled = YES;
    self.alert = head;
    [self addSubview:head];
  
}

#pragma mark ====展示view
- (void)showView
{
    if (self.bgView) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.bgView addGestureRecognizer:tap];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.4;
    [window addSubview:self.bgView];
    [window addSubview:self];
    
}
-(void)tap:(UIGestureRecognizer *)tap
{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self removeFromSuperview];
}

- (void)closeView
{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self removeFromSuperview];
}
-(void)cancelAction:(UIButton *)sender
{
    [self closeView];
}

-(void)sendAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(requestEventAction:)]) {
        [self.delegate requestEventAction:sender];
    }
    
}
@end
