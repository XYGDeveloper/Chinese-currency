//
//  AddAliViewController.m
//  YJOTC
//
//  Created by XI YANGUI on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AddAliViewController.h"
#import "WSCameraAndAlbum.h"
#import "UIImage+ZXCompress.h"
@interface AddAliViewController ()

@property (nonatomic,strong)NSString *basestring;

@end

@implementation AddAliViewController
//
//- (IBAction)commitAction:(id)sender {
//
//        if (self.textfieldcontent.text.length <= 0) {
//            [self showTips:kLocat(@"k_popview_list_sureto_tips")];
//            return;
//        }
//        if (self.basestring.length <= 0) {
//            [self showTips:kLocat(@"k_popview_list_sureto_commit")];
//            return;
//        }
//        kShowHud;
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
//        param[@"token_id"] = @(kUserInfo.uid);
//        param[@"key"] = kUserInfo.token;
//        param[@"type"] = @"2";
//        param[@"alipay"] = self.textfieldcontent.text;
//        param[@"alipay_pic"] = self.basestring;
//        param[@"uuid"] = [Utilities randomUUID];
//        __weak typeof(self)weakSelf = self;
//        NSLog(@"%@",param);
//        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:name_addpaymode] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//            kHideHud;
//            NSLog(@"%@",responseObj);
//
//            if (success) {
//                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
//            }else{
//                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
//            }
//        }];
//
//
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
////    "k_popview_list_countname" = "姓名";
////    "k_popview_list_aliycounter" = "支付寶賬戶";
////    "k_popview_list_counter" = "交易密碼";
//    self.countname.text = kLocat(@"k_popview_list_uploadDes");
//    self.nameLabel.text = kLocat(@"k_popview_list_countname");
//    self.accounterLabel.text = kLocat(@"k_popview_list_aliycounter");
//    self.tradeLabel.text = kLocat(@"k_popview_list_counter");
//    self.accounterTextfield.placeholder = kLocat(@"k_popview_list_counter_placehoder");
//    self.tradeTextfield.placeholder = kLocat(@"k_popview_list_counter_pwd_placehoder");
////    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc1)];
////    [self.tapImg addGestureRecognizer:tap1];
//    // Do any additional setup after loading the view from its nib.
//
//
//}
//
//- (void)topc1{
//
//    [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
//        {
//            if(selectedImageDatas.count > 0){
//                AddAliViewController *vc = (AddAliViewController *)fromViewController;
//                UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
//                vc.tapImg.image = image;
//                vc.basestring = [vc UIImageToBase64Str:image];
//            }
//        }
//    } cancleDidDo:^(UIViewController *fromViewController) {
//        NSLog(@"没有选择图片");
//        AddAliViewController *vc = (AddAliViewController *)fromViewController;
//        vc.tapImg.image = [UIImage imageNamed:@"addmode_plc"];
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


@end
