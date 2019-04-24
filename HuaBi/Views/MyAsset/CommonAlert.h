//
//  CommonAlert.h
//  HuaBi
//
//  Created by l on 2019/2/26.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^sureEvent)(void);
typedef void (^cancelEvent)(void);

@interface CommonAlert : UIView
@property (nonatomic,strong)sureEvent sure;
@property (nonatomic,strong)cancelEvent cancel;
+(void)AlertWith:(NSString *)title
          detail:(NSString *)detail
 buttonTextLabel:(NSString *)buttonTextLabel
      controller:(UIViewController *)controller
      sureAction:(sureEvent)sure
     cancelEvent:(cancelEvent)cancel;

@end

NS_ASSUME_NONNULL_END
