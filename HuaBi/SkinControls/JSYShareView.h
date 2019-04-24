//
//  JSYShareView.h
//  jys
//
//  Created by 周勇 on 2017/7/31.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    JSYShareViewTypeCircle = 0,//商圈分享
    JSYShareViewTypeNews, //资讯分享
    JSYShareViewTypeApp //app分享
} JSYShareViewType;

@interface JSYShareView : UIView

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,strong)NSString *shareTitle;

-(instancetype)initWithFrame:(CGRect)frame model:(YWDynamicModel *)model type:(JSYShareViewType)type;





@end
