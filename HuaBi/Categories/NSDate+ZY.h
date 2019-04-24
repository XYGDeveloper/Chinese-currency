//
//  NSDate+ZY.h
//  TimeTest
//
//  Created by fengwoo on 16/12/22.
//  Copyright © 2016年 fengwoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZY)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  是否为今年
 */
- (BOOL)isThisMonth;


/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  返回一个只有年月的时间
 */
- (NSDate *)dateWithYM;



/**
 *  返回一个只有年月日的字符串
 */
- (NSString *)dateStringWithYMD;

-(NSString *)dateStringWithMD;

/**
 *  返回一个只有年月的字符串
 */
- (NSString *)dateStringWithYM;

/**
 *  返回一个只有年的字符串
 */
- (NSString *)dateStringWithY;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

// 生成时间间隔字符串
- (NSString *)diff2now;
- (NSDateComponents *)components;

/**  ios时间戳是10位,如果是13位,要除以1000   */

/**
 *  用于收藏内的时间展示,//刚刚.几分钟前.几天前.日期...
 */
- (NSString *)diff2nowOfCollectoin;

/**
 *  根据传进来的秒数，返回对应的时间字符串,不用除以1000
 */
+ (NSString *)returnTimeWithSecond:(NSInteger)second formatter:(NSString *)formatterStr;


/// 时间戳
- (NSTimeInterval)timestamp;

/**  根据日期返回星期  */
+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate;


+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;


- (NSDate *)dateWithFormatter:(NSString *)formatter;

@end
