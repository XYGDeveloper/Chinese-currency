
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QRcodeManager : NSObject
+(instancetype)sharedInstance;
/**
 *  保存网络图片到相册
 *  @param ImageStr 图片的NSString网址
 */
-(void)saveImageToPhotosWithUrlStr:(NSString*)ImageStr Block:(void(^)(BOOL success,NSError *error))block;

/**
 *  切割图片，但是这种方式只能是切割以[UIimage imagename：]这种方式获取的
 *  @param image UIImage *image = [UIImage imageNamed:@""];
 *  @param frame 要截取的部位
 *  @return
 */
-(void)saveImageToPhotosWithImage:(UIImage*)image Frame:(CGRect)frame Block:(void(^)(BOOL success,NSError *error))block;

/**
 *   保存可选是否透明的图片
 *  @param view   要保存的view
 *  @param scale  缩放比例
 */
-(void)saveImageToPhotosWithView:(UIView*) view Scale:(CGFloat)scale Block:(void(^)(BOOL success,NSError *error))block;
/**
 *  保存view，可以设定要保存的区域
 *
 *  @param view  要保存的view
 *  @param frame
 *  @param scale 
 *  @param block 回调
 */
-(void)saveImageToPhotosWithView:(UIView*) view Frame:(CGRect)frame Scale:(CGFloat)scale Block:(void(^)(BOOL success,NSError *error))block;
/**
 *  保存可选是否透明的图片
 *  @param view   要保存的view
 *  @param opaque 是否透明
 *  @param scale  缩放比例
 */
-(void)saveImageToPhotosWithView:(UIView*) view Opaque:(BOOL)opaque Scale:(CGFloat)scale Block:(void(^)(BOOL success,NSError *error))block;

-(UIImage*)subImage:(UIImage*)image Frame:(CGRect)frame;

@end
