//
//  JSYShareView.m
//  jys
//
//  Created by 周勇 on 2017/7/31.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import "JSYShareView.h"
//#import "ShareSDK/ShareSDK.h"

@interface JSYShareView ()

@property(nonatomic,strong)UIView *coverView;

@property(nonatomic,strong)UIView *shareView;

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)YWDynamicModel *model;

@end

@implementation JSYShareView

-(instancetype)initWithFrame:(CGRect)frame model:(YWDynamicModel *)model type:(JSYShareViewType)type{
    if (self = [super initWithFrame:frame]) {
        
        _model = model;
        _type = type;
        [self setupUI];
    }
    return self;
    
}
-(void)setupUI
{
    
    self.coverView = [[UIView alloc]initWithFrame:kScreenBounds];
    /// 这一句代码.
//    [kKeyWindow addSubview:self.coverView];
    
    [self addSubview:self.coverView];
    self.coverView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    self.coverView.userInteractionEnabled = YES;
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareView)]];
    UIView *shareView = [[UIView alloc]initWithFrame:kRectMake(0, kScreenH, kScreenW, 130)];
    shareView.backgroundColor = kWhiteColor;
    [self.coverView addSubview:shareView];
    shareView.userInteractionEnabled = YES;
    
    
    NSArray *itemArr;
    NSArray *iconArr;
    if (_type != JSYShareViewTypeNews) {
        itemArr = @[@"微信好友",@"朋友圈",@"QQ",@"新浪微博"];
        iconArr = @[@"weixin-",@"youquan",@"tencent",@"sina"];
    }else{
        itemArr = @[@"微信好友",@"朋友圈",@"QQ",@"新浪微博",@"复制链接"];
        iconArr = @[@"weixin-",@"youquan",@"tencent",@"sina",@"Link_news"];
    }
    
    CGFloat w = kScreenW / itemArr.count;
    CGFloat h  = 80;
    
    for (NSInteger i = 0; i < itemArr.count; i++) {
        YLButton *button = [[YLButton alloc]initWithFrame:kRectMake(i * w, 0, w, h)];

        [shareView addSubview:button];
        [button setTitle:itemArr[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.textAlignment = 1;
        button.titleLabel.font = PFRegularFont(14);
        [button setTitleColor:kColorFromStr(@"#8c8c8c") forState:UIControlStateNormal];
        button.imageRect = kRectMake((w-25)/2, 25, 25, 25);
        button.titleRect = kRectMake(0, 50, w, 14);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
    }
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(0, 80, kScreenW, 50)];
    [shareView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kColorFromStr(@"#666666") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = PFRegularFont(18);
    
    
    UIView *line = [[UIView alloc]initWithFrame:kRectMake(0, cancelButton.top, shareView.width, 0.5)];
    [shareView addSubview:line];
    line.backgroundColor = kColorFromStr(@"#e3e3e3");
    
    
    [UIView animateWithDuration:0.25 animations:^{
       
        shareView.frame = kRectMake(0, kScreenH - 130, kScreenW, 130);
    }];
    
    _shareView = shareView;
    [self.coverView addSubview:_shareView];

}

-(void)hideShareView
{
    [UIView animateWithDuration:0.25 animations:^{
        _shareView.frame = kRectMake(0, kScreenH, kScreenW, 130);
        self.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)buttonAction:(UIButton*)button
{
    
    [self hideShareView];
    if (button.tag == 4) {
        [UIPasteboard generalPasteboard].string = _urlStr;
        [kKeyWindow showWarning:@"链接复制成功"];
        return;
    }
    if (_model == nil ) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (![_urlStr containsString:@"http"]) {
            
            _urlStr = [NSString stringWithFormat:@"http://%@",_urlStr];
        }
        if (_type == JSYShareViewTypeNews) {
            
            NSURL *url = [NSURL URLWithString:_urlStr];
//            [shareParams SSDKSetupShareParamsByText:self.shareTitle images:[UIImage imageNamed:@"logo.png"] url:url title:kAppName type:SSDKContentTypeWebPage];
        }else{
//            [shareParams SSDKSetupShareParamsByText:@"区块链技术及资产综合交流平台" images:[UIImage imageNamed:@"logo.png"] url:kBasePath.ks_URL title:kAppName type:SSDKContentTypeWebPage];
        }
        
        
//        SSDKPlatformType type;
//
//        switch (button.tag) {
//            case 0:
//                type = SSDKPlatformSubTypeWechatSession;
//                break;
//            case 1:
//                type = SSDKPlatformSubTypeWechatTimeline;
//                break;
//            case 2:
//                type = SSDKPlatformTypeQQ;
//                break;
//            case 3:
//                type = SSDKPlatformTypeSinaWeibo;
//                break;
//            default:
//                type = SSDKPlatformSubTypeWechatTimeline;
//                break;
//        }
//        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//            NSLog(@"%@", userData);
//            NSLog(@"%@", error);
//            if (error == nil && state == SSDKResponseStateSuccess) {
//            }
//        }];
        
    }else{
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //    NSLog(@"%@",self.title);
        //    if (![_urlStr containsString:@"http"]) {
        //
        //        _urlStr = [NSString stringWithFormat:@"http://%@",_urlStr];
        //    }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/district/shares?resourceid=%@",kBasePath,_model.district_id]];
        
        NSString *title;
        
        if (_model.content) {
            title = [NSString stringWithFormat:@"%@ - 西部网",_model.content];
        }else{
            title = @"商圈分享";
        }
        
//        [shareParams SSDKSetupShareParamsByText:title images:[UIImage imageNamed:@"logo.png"] url:url title:kAppName type:SSDKContentTypeWebPage];
//        SSDKPlatformType type;
//        if (button.tag == 0) {
//            NSLog(@"微信分享");
//            type = SSDKPlatformSubTypeWechatTimeline;
//        } else {
//            type = SSDKPlatformTypeQQ;
//            NSLog(@"qq分享");
//        }
//        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//            NSLog(@"%@", userData);
//            NSLog(@"%@", error);
//            if (error == nil && state == SSDKResponseStateSuccess) {
//            }
//        }];
    }
    
    
     
}


@end
