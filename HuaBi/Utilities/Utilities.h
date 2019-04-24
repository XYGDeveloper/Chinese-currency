//
//  Utilities.h
//  EnergySport
//
//  Created by 周勇 on 16/12/30.
//  Copyright © 2016年 Kaisa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 收入和支出
 - IncomeAndExpenditureTypeIncome: <#IncomeAndExpenditureTypeIncome description#>
 - IncomeAndExpenditureTypeExpenditure: <#IncomeAndExpenditureTypeIncome description#>
 */
typedef NS_ENUM(NSInteger,IncomeAndExpenditureType){
    IncomeAndExpenditureTypeIncome  =1,              //收入
    IncomeAndExpenditureTypeExpenditure  =2,         //支出
};


/**
 挖矿类型
 - MiningTypeTradeMine: 交易挖矿
 - MiningTypeInvitationMineAward: 邀请挖矿
 - MiningTypeTeamReward: 团队奖励
 */
typedef NS_ENUM(NSInteger,MiningType){
    MiningTypeTradeMine  =62,
    MiningTypeInvitationMineAward  =63,
    MiningTypeTeamReward = 64
};

@interface Utilities : NSObject

+ (int)getAuthStatus;
/**  网络是否可用  */
+ (BOOL)netWorkUnAvalible;

/**  屏幕宽度比例系数,以iphone6为基准  */
+ (float)stdScreenRatio;

/**  屏幕高度比例系数,以iphone6为基准  */
+ (float)stdScreenHeightRatio;

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

// 传进来的是秒数，不用除以1000  时间戳10位不用除以1000.   13位就除以1000
+ (NSString *)returnTimeWithSecond:(NSInteger)second formatter:(NSString *)formatterStr;
/**  获取当前iOS版本  */
+ (float)getIOSVersion;


/**  计算Label 高宽  */
+ (CGRect)calculateWidthAndHeightWithWidth:(CGFloat)width height:(CGFloat)height text:(NSString *)text font:(UIFont *)font;

+(NSString *)dataChangeUTC;

+ (void)showStatusBar;

//图片转base64字符串
+ (NSString *)encodeToBase64StringWithImage:(UIImage *)image;

+(BOOL)isVer_status;
/**  生成二维码  */
+ (UIImage *)getQRImageWithContent:(NSString *)msg;
/**  生成条形码  */
+ (UIImage *)getBarCodeImageWithContent:(NSString *)msg;
/**  返回条形码的格式字符串1212 2121 3232 321323  */
+ (NSString *)formatCode:(NSString *)code;



+ (BOOL)isExpired;
/**  字典/数组转字符串  */
+ (NSString*)convertToJSONData:(id)infoDict;
/**  字符串转字典  */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**  是否包含特殊字符  */
+ (BOOL)isIncludeSpecialCharact: (NSString *)str;


/**  权限验证  */
+ (NSString *)handleParamsWithDic:(NSDictionary *)param;
/**  获取UUID  */
+ (NSString *)randomUUID;
/**  URL解码  */
+ (NSString *)URLDecodedString:(NSString *)str;
/**  URL编码  */
+ (NSString *)URLEncodedString:(NSString *)str;
/**  设置View部分圆角  */
+ (void)setLayerAndBezierPathCutCircularWithView:(UIView *)view;

/**  计算有行间距的label高宽  */
+ (CGSize)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace;

/**  根据URL获取image  */
+ (UIImage *) getImageFromURL:(NSString *)fileURL;

/**  接口格式处理  */
+ (NSString *) handleAPIWith:(NSString *)url;

@end
