//
//  UIView+HUD.m
//  TRProject
//
//  Created by tarena on 16/7/13.
//  Copyright © 2016年 yingxin. All rights reserved.
//

#import "UIView+HUD.h"
static NSArray *animateImages = nil;
@implementation UIView (HUD)

- (NSArray<UIImage *> *)animateImages {
    NSMutableArray *imageNames = [NSMutableArray array];
    for (int i = 1; i < 46; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"loading%d",i];
        [imageNames addObject:[UIImage imageNamed:imageName]];
    }
    return imageNames;
}

/**
 显示
 */
- (void)showHUD{
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];

    [SVProgressHUD show];
    
//    return;
//    [self hideHUD];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//    [hud hideAnimated:YES afterDelay:30];
//    hud.bezelView.color = [UIColor clearColor];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
//    return;
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//    iv.contentMode = UIViewContentModeScaleAspectFit;
//    hud.customView = iv;
//    hud.customView.frame = kScreenBounds;
    //图片数组只初始化一次 因为图片png解码为bmp位图效果CPU，最好不要反复进行
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        animateImages = [self animateImages];
//    });
//    UILabel *label = [[UILabel alloc] init];
//    [iv addSubview:label];
//    label.textColor = kGaryColor;
//    label.font = PFRegularFont(15);
////    label.text = @"数据加载中...";
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(iv.mas_bottom).equalTo(0);
//        make.centerX.equalTo(0);
//    }];
    // 设置动画
//    iv.animationImages = animateImages;
//    iv.animationDuration = 2;
//    [iv startAnimating];
    
//    hud.customView.backgroundColor = [UIColor clearColor];
//    [view addSubview:iv];
    
//    hud.customView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
}
/**
 隐藏
 */
- (void)hideHUD
{
    
    [SVProgressHUD dismiss];
//    return;
//    [MBProgressHUD hideHUDForView:self animated:YES];
}

/**
 显示警告
 */
- (void)showWarning:(NSString *)msg{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = msg;
    hud.label.font = PFRegularFont(16);
    [hud hideAnimated:YES afterDelay:1.7];
}
@end



