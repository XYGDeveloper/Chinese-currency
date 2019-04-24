//
//  HBMineDesAlertView.h
//  HuaBi
//
//  Created by l on 2018/11/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^sureEvent)(void);
@interface HBMineDesAlertView : UIView
@property (nonatomic,strong)sureEvent sure;

+(void)AlertWith:(NSString *)title
          detail:(NSString *)detail
 buttonTextLabel:(NSString *)buttonTextLabel
      controller:(UIViewController *)controller
      sureAction:(sureEvent)sure;
@end

NS_ASSUME_NONNULL_END
