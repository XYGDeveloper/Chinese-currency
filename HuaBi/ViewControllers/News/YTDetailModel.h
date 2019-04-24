//
//  YTDetailModel.h
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTDetailModel : NSObject
@property (nonatomic,copy)NSString *article_id;
@property (nonatomic,copy)NSString *position_id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *art_pic;

//"article_id":"549",
//"position_id":"1",
//"title":"港媒:中国推中泰高铁 拟年底前启动第一阶段工程",
//"content":" 资料图片：2017年9月19日，泰国教师来华学习交流高铁技",
//"add_time":"1511853398",
//"status":"0",
//"type":"",
//"sign":"1",
//"art_pic":"http://img1.utuku.china.com/550x0/news/20171128/9c574459-8089-443d-961b-ca3af7ded851.jpg"
@end

NS_ASSUME_NONNULL_END
