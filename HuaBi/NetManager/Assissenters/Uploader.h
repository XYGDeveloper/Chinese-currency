

#import "BaseApi.h"

@interface Uploader : NSObject

+ (instancetype)sharedUploader;

/**
 *  上传图片
 *
 *  @param image           图片
 *  @param completionBlock 回调方法
 */
- (void)uploadImage:(UIImage *)image withCompletionBlock:(void(^)(ApiCommand *cmd, BOOL success, NSString *imageUrl))completionBlock;
- (void)upLoadImage:(UIImage *)image parameter:(NSDictionary *)dic withCompletionBlock:(void(^)(ApiCommand *cmd, BOOL success, NSString *imageUrl))completionBlock;
//上传多张图片
- (void)upLoadImageArr:(NSMutableArray *)imageArr parameter:(NSDictionary *)dic withCompletionBlock:(void(^)(ApiCommand *cmd, BOOL success, NSString *imageUrl))completionBlock;

@end




@interface ImageUploadApi : BaseApi

- (void)uploadImage:(UIImage *)image;

- (void)uploadImage:(UIImage *)image parameter:(NSDictionary *)dic;

- (void)uploadMutileImage:(NSMutableArray *)imageArr parameter:(NSDictionary *)dic;

@end
