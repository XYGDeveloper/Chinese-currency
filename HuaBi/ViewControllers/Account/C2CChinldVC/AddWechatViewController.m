//
//  AddWechatViewController.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AddWechatViewController.h"
#import "WSCameraAndAlbum.h"
#import "UIImage+ZXCompress.h"
@interface AddWechatViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countName;
@property (weak, nonatomic) IBOutlet UITextField *countContent;
@property (weak, nonatomic) IBOutlet UILabel *qrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tapImgview;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,strong)NSString *basestring;

@end

@implementation AddWechatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.countName.text = kLocat(@"k_popview_list_countname");
//    self.countContent.placeholder = kLocat(@"k_popview_list_placehoder");
//    self.qrLabel.text = kLocat(@"k_popview_list_qr");
//    [self.addButton setTitle:kLocat(@"k_popview_list_sureto_add") forState:UIControlStateNormal];
//    self.addButton.layer.cornerRadius = 8;
//    self.addButton.layer.masksToBounds = YES;
//
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc1)];
//    [self.tapImgview addGestureRecognizer:tap1];
    
    // Do any additional setup after loading the view from its nib.
}
//
//- (void)topc1{
//    
//    [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
//        {
//            if(selectedImageDatas.count > 0){
//                AddWechatViewController *vc = (AddWechatViewController *)fromViewController;
//                UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
//                vc.tapImgview.image = image;
//                vc.basestring = [vc UIImageToBase64Str:image];
//            }
//        }
//    } cancleDidDo:^(UIViewController *fromViewController) {
//        NSLog(@"没有选择图片");
//        AddWechatViewController *vc = (AddWechatViewController *)fromViewController;
//        vc.tapImgview.image = [UIImage imageNamed:@"addmode_plc"];
//        
//    }];
//    
//}
//
//-(NSString *)UIImageToBase64Str:(UIImage *)image{
//    
//    UIImage *tempimage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
//    //    UIImage *image = _avatar.image;
//    CGSize size = [UIImage zx_scaleImage:tempimage length:100.];
//    tempimage = [tempimage zx_imageWithNewSize:size];
//    NSString *str = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:tempimage]];
//    return str;
//}
//
//
//- (IBAction)toadd:(id)sender {
////    "k_popview_list_sureto_tips" = "Please input your account name.";
////    "k_popview_list_sureto_commit" = "Please upload the WeChat payment code.";
//    if (self.countContent.text.length <= 0) {
//        [self showTips:kLocat(@"k_popview_list_sureto_tips")];
//        return;
//    }
//    if (self.basestring.length <= 0) {
//        [self showTips:kLocat(@"k_popview_list_sureto_commit")];
//        return;
//    }
//    
//    kShowHud;
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"token_id"] = @(kUserInfo.uid);
//    param[@"key"] = kUserInfo.token;
//    param[@"type"] = @"3";
//    param[@"wechat"] = self.countContent.text;
//    param[@"wechat_pic"] = self.basestring;
//    param[@"uuid"] = [Utilities randomUUID];
//    __weak typeof(self)weakSelf = self;
//    
//    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:name_addpaymode] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//        if (success) {
//            kHideHud;
//            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
//        }else{
//            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
//        }
//    }];
//    
//}

@end
