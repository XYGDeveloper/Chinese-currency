//
//  ImagePickerManager.m
//  AFD_Customer
//
//  Created by leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "ImagePickerManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
//#import "UIInfomationView.h"

@interface ImagePickerManager()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController    *_imgPicker;
    
}

@end


@implementation ImagePickerManager


-(id)init
{
    self = [super init];
    if (self) {
        _imgPicker = [[UIImagePickerController alloc] init];
        _imgPicker.delegate = self;
    }
    return self;
}

-(void)requestImagePickerWithCamera:(BOOL)isCamera controller:(UIViewController*)controller;
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            //无权限
            NSLog(@"无权限");
            // 下面用自定义显示界面提示
           // [[KSAlertView sharedAlertView]showAlertViewWithTitle:nil messsage:@"请前往设置允许佳能量访问您的相机或照片!"];
            
            return;
        } else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
            [self startImagePickerController: isCamera controller: controller];
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType: mediaType completionHandler:^(BOOL granted) {
                if(granted){//点击允许访问时调用
                    //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                    [self startImagePickerController: isCamera controller: controller];
                } else {
                    NSLog(@"not granted");
//                    [Utilities showMessageDialog: @"没有授权"];
                }
            }];
        }
    } else {
        [self startImagePickerController: isCamera controller: controller];
    }
}

-(void)startImagePickerController:(BOOL)isCamera controller:(UIViewController*)controller
{
    //调iphone的相机功能
    BOOL isHasCamera = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    
    if(isHasCamera && isCamera){
        _imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imgPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    } else {
        _imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    _imgPicker.mediaTypes = @[(NSString *)kUTTypeImage];
//    _imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: _imgPicker.sourceType];
    _imgPicker.videoQuality = UIImagePickerControllerQualityTypeLow;
//    _imgPicker.allowsEditing = YES;
    
    [self performSelector: @selector(changeStatusBarColor) withObject: nil afterDelay: 0.5];
    [controller presentViewController: _imgPicker animated:YES completion:nil];
}

-(void)changeStatusBarColor
{
    [self changeToBlackTextStatusBar];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    if (self.imagePickerMgrDelegate && [self.imagePickerMgrDelegate respondsToSelector: @selector(cancelImagePicker)]) {
        [self.imagePickerMgrDelegate cancelImagePicker];
    }
    [self changeToWhiteTextStatusBar];

    [picker dismissViewControllerAnimated: true completion: ^{
    }];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    UIImage *newCompressImage = [self compressImage: info[UIImagePickerControllerOriginalImage] maxDataSize: 2];
    CGFloat w = (kScreenH - 2 * kMargin - 2 * 17) / 3;
    UIImage *newCompressImage = [self originImage:info[UIImagePickerControllerOriginalImage] scaleToSize:CGSizeMake(w, w)];
    
    if (newCompressImage == nil) {
        //        [Utilities showMessageDialog: @"Err image"];
    } else {
        if (self.imagePickerMgrDelegate && [self.imagePickerMgrDelegate respondsToSelector: @selector(pickerImage:)]) {
            [self.imagePickerMgrDelegate pickerImage: newCompressImage];
        }
    }
    
    [picker dismissViewControllerAnimated: true completion: nil];
}

-(void)changeToWhiteTextStatusBar;
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

-(void)changeToBlackTextStatusBar;
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
}

-(UIImage*)compressImage:(UIImage*)oldImage maxDataSize:(int)maxDataSize;
{
    UIImage *compressImage = [oldImage copy];
    
    NSData *imageData = UIImagePNGRepresentation(compressImage);
    if (imageData == nil)
        imageData = UIImageJPEGRepresentation(compressImage, 1.0);
    
    float length = [imageData length]/1024;
    
    
    CGSize sz = compressImage.size;
    
    
    while (length > maxDataSize * 1024) {
        float ratio = maxDataSize * 1024 / length;
        
        compressImage = [self originImage: compressImage scaleToSize: CGSizeMake((int)(sz.width * ratio), (int)(sz.height * ratio))];
        imageData = UIImagePNGRepresentation(compressImage);
        if (imageData == nil)
            imageData = UIImageJPEGRepresentation(compressImage, 1.0);
        
        length = [imageData length]/1024;
        sz = compressImage.size;
    }
    return compressImage;
}

-(UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect: CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
