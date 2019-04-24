//
//  JPSalertView.h
//  PopViewOne
//
//  Created by 姜朋升 on 2017/5/22.
//  Copyright © 2017年 闪牛网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@class alertTableViewCell;

@protocol JPSalertViewdelegate <NSObject>

-(void)requestEventAction:(UIButton *)button;

@end

@interface JPSalertView : UIView
@property(nonatomic,strong)alertTableViewCell *alert;
@property(nonatomic,weak)id <JPSalertViewdelegate> delegate;

-(void)showView;
-(void)closeView;

@end
