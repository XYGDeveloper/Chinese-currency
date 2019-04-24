//
//  TXLiabrayOptionManager.m
//  appDoctor
//
//  Created by senwang on 14/11/14.
//  Copyright (c) 2014年 senwang. All rights reserved.
//

#import "WSCameraAndAlbum.h"
#import "WSActionSheetBlock.h"
@implementation WSCameraAndAlbum

+ (void)showSelectPicsWithController:(UIViewController *)fromViewController multipleChoice:(BOOL)multiple selectDidDo:(ImagePickerSelected)selectDidDo cancleDidDo:(ImagePickerCancled)cancleDidDo
{
    static WSActionSheetBlock *actionSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet = [[WSActionSheetBlock alloc]initWithTitle:nil delegate:nil cancelButtonTitle:kLocat(@"net_alert_load_message_cancel") destructiveButtonTitle:nil otherButtonTitles:kLocat(@"photo_lib_photoLib"),kLocat(@"photo_lib_camara"),nil];
    }else
    {
        actionSheet = [[WSActionSheetBlock alloc]initWithTitle:nil delegate:nil cancelButtonTitle:kLocat(@"net_alert_load_message_cancel") destructiveButtonTitle:nil otherButtonTitles:kLocat(@"photo_lib_photoLib"),nil];
    }
    actionSheet.fromViewController = fromViewController;
    [actionSheet showInView:fromViewController.view multipleChoice:(BOOL)multiple selectDidDo:selectDidDo cancleDidDo:cancleDidDo];
    
}

@end
