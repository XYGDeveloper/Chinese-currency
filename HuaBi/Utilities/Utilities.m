//
//  Utilities.m
//  EnergySport
//
//  Created by 周勇 on 16/12/30.
//  Copyright © 2016年 Kaisa. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"
#import "HBLoginTableViewController.h"
@implementation Utilities

+ (int)getAuthStatus{
    if ([kUserInfo.verify_state isEqualToString:@"-1"]) {
        return -1;
    }else if ([kUserInfo.verify_state isEqualToString:@"0"]){
        return 0;
    }else if ([kUserInfo.verify_state isEqualToString:@"1"]){
        return 1;
    }else{
        return 2;
    }
}

+(BOOL)netWorkUnAvalible
{
    NetworkStatus networkStatus = [Utilities netWorkStatus];
    
    switch (networkStatus) {
        case NotReachable:
        {
            NSLog(@"请检查网络");
            return true;
        }
        default:
            break;
    }
    return false;
}

+(NetworkStatus)netWorkStatus
{
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return networkStatus;
}

+(float)stdScreenRatio
{
    // 320 4/4s,5/5s
    // 375 6/6s
    // 414 6p/6ps
    // 基于 6/6s 屏为标准
    float ratio = kScreenWidth / 375.0;
    //    NSLog(@"ratio: %f", ratio);
    return ratio;
}
/**  屏幕高度比例系数,以iphone6为基准  */
+(float)stdScreenHeightRatio
{
    float ratio = kScreenHeight / 667.0;
    return ratio;
}
// 传进来的是秒数，不用除以1000
+ (NSString *)returnTimeWithSecond:(NSInteger)second formatter:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterStr];
    second = second > 140000000000 ? second / 1000 : second;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:second];
    NSString *returnTimeStr = [formatter stringFromDate:confromTimesp];
    return returnTimeStr;
}


+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSLog(@"1296035591  = %@",confromTimesp);
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    return confromTimespStr;
    
}

// 计算label 高宽
+ (CGRect)calculateWidthAndHeightWithWidth:(CGFloat)width height:(CGFloat)height text:(NSString *)text font:(UIFont *)font
{
//    CGRect titleSize = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin            attributes:@{NSFontAttributeName: font} context:nil];
    CGRect titleSize = [text boundingRectWithSize:CGSizeMake(width, height) options:  NSStringDrawingUsesLineFragmentOrigin            attributes:@{NSFontAttributeName: font} context:nil];

    
    return titleSize;
}

+(void)showStatusBar;
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

//图片转base64字符串
+(NSString *)encodeToBase64StringWithImage:(UIImage *)image
{
    NSData *_data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString *_encodedImageStr = [_data base64EncodedString];
    
    return _encodedImageStr;
}


+(UIImage *)getQRImageWithContent:(NSString *)msg
{
    /**
     * 获取所有可用的滤镜 (名字)
     kCICategoryBuiltIn 指是系统内建的滤镜
     */
//    NSArray <NSString *> *fileNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
//    NSLog(@"fileNames: %@", fileNames);
    
    /**
     * 必须要确保滤镜名字是正确, CIQRCodeGenerator
     */
    // 根据滤镜名创建对应的滤镜 (滤镜名必须正确, 而且是系统提供的)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 1. 通过文档来查找该滤镜 (图文效果)
    // 2. 通过代码方式来查找, 找到相应的Key与Value的描述
//    NSDictionary <NSString *, id> *attributes = filter.attributes;
//    NSLog(@"%@", attributes);
    
    // 直接生成一张字符串对应的二维码图片, 并不需要图片输入
    
    // -------- 配置输入参数 --------
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    // 会影响二维码能被遮挡的内容大小 (H接近30%)
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // -------- 获取 --------
    // 获取滤镜的输出图片
    CIImage *outputImage = filter.outputImage;
    
    //消除迷糊
    
    CGFloat scaleX = 200 / outputImage.extent.size.width; // extent 返回图片的frame
    
    CGFloat scaleY = 200 / outputImage.extent.size.height;
    
    CIImage *transformedImage = [outputImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
/**  生成条形码  */
+(UIImage *)getBarCodeImageWithContent:(NSString *)msg
{   //NSNonLossyASCIIStringEncoding   ==>这个key才可以
     // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [msg dataUsingEncoding:NSNonLossyASCIIStringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
//    CGFloat scaleX = 300 * kScreenWidthRatio / barcodeImage.extent.size.width; // extent 返回图片的frame
//    CGFloat scaleY = 200 * kScreenHeightRatio / barcodeImage.extent.size.height;
//    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:barcodeImage];
    
}
// 每隔4个字符空两格
+(NSString *)formatCode:(NSString *)code {
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3) {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++) {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];
    return temp;
}
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+(BOOL)isExpired
{
    NSString *token = kUserInfo.token;
    if (kUserInfo.token == nil || [kUserInfo.token isEqualToString:@""] || kUserInfo.token.length < 2) {
        return YES;
    }
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
//    kLOG(@"currentTime==%@",[Utilities returnTimeWithSecond:currentTime formatter:@"yyyy-MM-dd HH:mm"]);

    //一个月的有效期
//    NSTimeInterval expiredTime = kUserInfo.thisLoginTime.integerValue / 1000 + 60 * 60 * 24 * 30;
//7天有效期
//    NSDate *obj = [kUserDefaults objectForKey:@"kLastLoginTimeKey"];
//
//    if (obj == nil) {
//        return NO;
//    }
    
    
    NSTimeInterval expiredTime = [[kUserDefaults objectForKey:@"kLastLoginTimeKey"] timeIntervalSince1970] + 60 * 60 * 24 * 7;
//    kLOG(@"上次登录时间 %@",[Utilities returnTimeWithSecond:expiredTime formatter:@"yyyy-MM-dd HH:mm"]);
    
    
    if (currentTime > expiredTime) {
        return YES;
    }else{
        return NO;
    }
}


+(BOOL)isVer_status{
    if ([kUserInfo.verify_state isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}



+(NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
    options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"\"',<>.?/~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|$^:《》,$_€~`!"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}



+ (NSString *)handleParamsWithDic:(NSDictionary *)param
{
//    if ([[param allValues] count] == 0) {
//        return nil;
//    }
    
   NSArray *keys = [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       return [obj1 compare:obj2]; //升序
    }];
    
    NSMutableString *resultStr = [NSMutableString string];
    
    //键值对拼接
    for (NSInteger i = 0; i < keys.count; i++) {
        
        [resultStr appendString:[NSString stringWithFormat:@"%@=%@&",keys[i],param[keys[i]]]];
        
    }
    //加上keycode
    [resultStr appendString:[NSString stringWithFormat:@"key=%@",kKeyCode]];
    
    //先md5,再大写
    return  [[resultStr md5String] uppercaseString];
}
+ (NSString *)randomUUID {
    NSString *deviceUID_Str = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceUID"];
    if (deviceUID_Str&&deviceUID_Str.length>0) {
        return deviceUID_Str;
    }
    if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUUID UUID] UUIDString] forKey:@"deviceUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *) cfuuid) copy];
    CFRelease(cfuuid);
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"deviceUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return uuid;
}

+(NSString *)dataChangeUTC{
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)URLDecodedString:(NSString *)str;
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

+ (void)setLayerAndBezierPathCutCircularWithView:(UIView *)view
{
    // 创建BezierPath 并设置角 和 半径 这里只设置了 右上 和 右下
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(view.frame.size.height / 2, view.frame.size.height / 2)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = view.bounds;
    layer.path = path.CGPath;
    view.layer.mask = layer;
}

+ (CGSize)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
//    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}



+ (UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}


/**  接口格式  */
+ (NSString *)handleAPIWith:(NSString *)url
{
    if ([url containsString:@"Api"]) {
        return url;
    }else{
        
        return [@"/Api" stringByAppendingPathComponent:url];
        
//        return [NSString stringWithFormat:@"/Api/%@",url];
    }

   //@"mb_index/search"
//    /mobile/index.php?act=mb_login&op=register
    
    
//    NSArray *strArr = [url componentsSeparatedByString:@"/"];
//    return [NSString stringWithFormat:@"/mobile/index.php?act=%@&op=%@",strArr.firstObject,strArr.lastObject];
}
@end
