
#import "Uploader.h"
#import "AFURLRequestSerialization.h"

@interface Uploader ()<ApiRequestDelegate>

@property (nonatomic, strong) ImageUploadApi *imgUploadApi;

@property (nonatomic, copy) void(^completionBlock)(ApiCommand *cmd, BOOL success, NSString *imageUrl);

@end

@implementation Uploader

+ (instancetype)sharedUploader {
    static Uploader *__loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __loader = [[Uploader alloc] init];
    });
    return __loader;
}

- (void)uploadImage:(UIImage *)image withCompletionBlock:(void(^)(ApiCommand *cmd, BOOL success, NSString *imageUrl))completionBlock {
    self.completionBlock = completionBlock;
    [self.imgUploadApi uploadImage:image];
}

- (void)upLoadImage:(UIImage *)image parameter:(NSDictionary *)dic withCompletionBlock:(void(^)(ApiCommand *cmd, BOOL success, NSString *imageUrl))completionBlock
{

    self.completionBlock = completionBlock;
    [self.imgUploadApi uploadImage:image parameter:dic];
    
}

- (void)upLoadImageArr:(NSMutableArray *)imageArr parameter:(NSDictionary *)dic withCompletionBlock:(void (^)(ApiCommand *, BOOL, NSString *))completionBlock{
    self.completionBlock = completionBlock;
    [self.imgUploadApi uploadMutileImage:imageArr parameter:dic];
}


#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    if (self.completionBlock) {
        self.completionBlock(command, YES, responsObject);
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    if (self.completionBlock) {
        self.completionBlock(command, NO, nil);
    }
}


#pragma mark - Properties
- (ImageUploadApi *)imgUploadApi {
    if (!_imgUploadApi) {
        _imgUploadApi = [[ImageUploadApi alloc] init];
        _imgUploadApi.delegate = self;
    }
    return _imgUploadApi;
}

@end






@implementation ImageUploadApi




- (void)uploadImage:(UIImage *)image {
   
    [self startRequestWithParams:nil multipart:^(id<AFMultipartFormData> multipartBlock) {
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [NSString stringWithFormat:@"%@/%f.jpg", path, [[NSDate date] timeIntervalSince1970]];
            [imageData writeToFile:filePath atomically:YES];
            
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            [multipartBlock appendPartWithFileURL:fileUrl name:@"file" error:nil];
        }
    }];
}

- (void)uploadImage:(UIImage *)image parameter:(NSDictionary *)dic {
    
    [self startRequestWithParams:dic multipart:^(id<AFMultipartFormData> multipartBlock) {
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [NSString stringWithFormat:@"%@/%f.jpg", path, [[NSDate date] timeIntervalSince1970]];
            [imageData writeToFile:filePath atomically:YES];
            
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            [multipartBlock appendPartWithFileURL:fileUrl name:@"file" error:nil];
        }
    }];
}

// 上传多张图片

- (void)uploadMutileImage:(NSMutableArray *)imageArr parameter:(NSDictionary *)dic {
    
    for (int i = 0; i < imageArr.count; i++) {
        
        [self startRequestWithParams:dic multipart:^(id<AFMultipartFormData> multipartBlock) {
            if (imageArr) {
                NSData *imageData = UIImageJPEGRepresentation(imageArr[i], 0.3);
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filePath = [NSString stringWithFormat:@"%@/%f.jpg", path, [[NSDate date] timeIntervalSince1970]];
                [imageData writeToFile:filePath atomically:YES];
                NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
                [multipartBlock appendPartWithFileURL:fileUrl name:@"file" error:nil];
            }
        }];

    }
    
   }

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/user-main/upload");
    return command;
}

- (id)reformData:(id)responseObject {
    return responseObject[@"file_url"];
}

@end
