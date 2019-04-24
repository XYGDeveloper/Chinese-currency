//
//  JSYCommonAlertView.h
//  jys
//
//  Created by 周勇 on 2017/5/8.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JSYCommonAlertViewDelegate <NSObject>
@optional

-(void)didClickConfirmButton;

@end

@interface JSYCommonAlertView : UIView

+(instancetype)sharedAlertView;

/**  提示框  */
-(void)showAlertViewWithTitle:(NSString *)title messsage:(NSString *)messsage;

-(void)showAlertViewWithCancelButtonTitle:(NSString *)title messsage:(NSString *)messsage;

@property(nonatomic,weak)id<JSYCommonAlertViewDelegate> delegate;


@end
