//
//  ImagePickerManager.h
//  AFD_Customer
//
//  Created by leo on 16/8/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImagePickerManagerDelegate <NSObject>

@optional

-(void)pickerImage:(UIImage*)image;
-(void)failedPickerImage;
-(void)cancelImagePicker;

@end

@interface ImagePickerManager: NSObject
{

}

@property (assign)id<ImagePickerManagerDelegate>imagePickerMgrDelegate;

-(void)requestImagePickerWithCamera:(BOOL)isCamera controller:(UIViewController*)controller;

@end
