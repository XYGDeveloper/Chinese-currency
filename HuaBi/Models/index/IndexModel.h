//
//  IndexModel.h
//  YJOTC
//
//  Created by l on 2018/9/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface itemModel : NSObject
@property (nonatomic,copy)NSString *H_change24;
@property (nonatomic,copy)NSString *H_done_money24;
@property (nonatomic,copy)NSString *H_done_num24;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *currency_logo;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *currency_name;
@property (nonatomic,copy)NSString *max_price;
@property (nonatomic,copy)NSString *article_id;
@property (nonatomic,copy)NSString *min_price;
@property (nonatomic,copy)NSString *title_en;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *price_usd;
@property (nonatomic,copy)NSString *price_status;

@end


@interface articleModel : NSObject
@property (nonatomic,copy)NSString *article_id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *title_en;
@property (nonatomic,copy)NSString *title_tc;
@end

@interface configModel : NSObject
@property (nonatomic,copy)NSString *amount_income_allocated_today;
@property (nonatomic,copy)NSString *cumulative_income_million_today;
@end


@interface flashModel : NSObject
@property (nonatomic,copy)NSString *link;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *title;
@end


@interface IndexModel : NSObject
@property (nonatomic,strong)NSArray *currency;
@property (nonatomic,strong)NSArray *flash;
@property (nonatomic,strong)articleModel *article;
@property (nonatomic,strong)configModel *config;

@end
