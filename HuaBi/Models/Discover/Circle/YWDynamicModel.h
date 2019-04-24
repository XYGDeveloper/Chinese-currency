//
//  YWDynamicModel.h
//  ywshop
//
//  Created by 周勇 on 2017/10/26.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWDynamicModel : NSObject

/**  日志id  */
@property(nonatomic,copy)NSString *district_id;
/**  用户id  */
@property(nonatomic,copy)NSString *member_id;
/**  动态内容  */
@property(nonatomic,copy)NSString *content;
/**  发布时间  */
@property(nonatomic,copy)NSString *add_time;
/**  精度  */
@property(nonatomic,copy)NSString *longitude;
/**  纬度  */
@property(nonatomic,copy)NSString *latitude;
/**  点赞数量 */
@property(nonatomic,copy)NSString *likes;
/**  用户名  */
@property(nonatomic,copy)NSString *username;
/**  评论数量  */
@property(nonatomic,copy)NSString *comment_count;
/**  头像  */
@property(nonatomic,copy)NSString *userhead;
/**  是否赞过  0否 1是  */
@property(nonatomic,copy)NSString *is_like;
/**  是否已关注用户 0否 1是*/
@property(nonatomic,copy)NSString *is_follow;
/**  评论列表  */
@property(nonatomic,copy)NSArray *comment;
/**  附件  */
@property(nonatomic,copy)NSArray *attachments;
/**  地址  */
@property(nonatomic,copy)NSString *location;
/**  附件格式  */
@property(nonatomic,copy)NSString * attachments_type;
/**  缩略图  */
@property(nonatomic,copy)NSString * attachments_thumbnail;

//@property(nonatomic,assign)BOOL hasGoods;

@property(nonatomic,copy)NSString * goods_id;
@property(nonatomic,copy)NSString * goods_image_url;
@property(nonatomic,copy)NSString * goods_name;
@property(nonatomic,copy)NSString * goods_price;
@property(nonatomic,copy)NSString * goods_url;



@end
