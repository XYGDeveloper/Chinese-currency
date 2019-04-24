//
//  AuthViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AuthViewController.h"
#import "WSCameraAndAlbum.h"
#import "UIImage+ZXCompress.h"
#import "ZJImageMagnification.h"
@interface AuthViewController ()
@property (nonatomic,strong)NSString *picBase1;
@property (nonatomic,strong)NSString *picBase2;
@property (nonatomic,strong)NSString *picBase3;
@property (nonatomic,strong)NSString *authStatus;

@end

@implementation AuthViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getIsAuth];
}

- (void)getIsAuth{
    
    self.title = kLocat(@"k_AuthViewController_title");
    self.nameLabel.text = kLocat(@"k_AuthViewController_name");
    self.nameTextField.placeholder = kLocat(@"k_AuthViewController_placehoder");
    self.firstLabel.text = kLocat(@"k_AuthViewController_pc1");
    self.secondLabel.text = kLocat(@"k_AuthViewController_pc2");
    self.thirdLabel.text = kLocat(@"k_AuthViewController_pc3");
    [self.commitBtn setTitle:kLocat(@"k_AuthViewController_comit") forState:UIControlStateNormal];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    NSLog(@"-----%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/verify_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"------%@",responseObj);
        //        verify_state -1未认证 0未通过 1:已认证 2: 审核中
//        "HBMemberViewController_authstat0" = "未認證";
//        "HBMemberViewController_authstat1" = "未通過";
//        "HBMemberViewController_authstat2" = "已認證";
//        "HBMemberViewController_authstat3" = "審核中";
        if (success) {
          
            self.authStatus = [responseObj ksObjectForKey:kResult][@"verify_state"];
            if ([[responseObj ksObjectForKey:kResult][@"verify_state"] isEqualToString:@"0"] || [[responseObj ksObjectForKey:kResult][@"verify_state"] isEqualToString:@"-1"]) {
//                self.pc1.image = [UIImage imageNamed:@"auth_defa"];
//                self.pc2.image = [UIImage imageNamed:@"auth_defa"];
//                self.pc3.image = [UIImage imageNamed:@"auth_defa"];
//                self.pc1.contentMode = UIViewContentModeCenter;
//                self.pc2.contentMode = UIViewContentModeCenter;
//                self.pc3.contentMode = UIViewContentModeCenter;
                
            }else if ([[responseObj ksObjectForKey:kResult][@"verify_state"] isEqualToString:@"1"]){
                self.nameTextField.userInteractionEnabled = NO;
                NSString *pc1url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic1"]];
                NSString *pc2url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic2"]];
                NSString *pc3url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic3"]];
                [self.pc1 setImageURL:[NSURL URLWithString:pc1url]];
                [self.pc2 setImageURL:[NSURL URLWithString:pc2url]];
                [self.pc3 setImageURL:[NSURL URLWithString:pc3url]];
                self.nameTextField.text = [responseObj ksObjectForKey:kResult][@"name"];
                self.commitBtn.backgroundColor = kColorFromStr(@"#CCCCCC");
                [self.commitBtn setTitle:kLocat(@"HBMemberViewController_authstat2") forState:UIControlStateNormal];
                self.commitBtn.userInteractionEnabled = NO;
                self.pc1.contentMode = UIViewContentModeScaleAspectFit;
                self.pc2.contentMode = UIViewContentModeScaleAspectFit;
                self.pc3.contentMode = UIViewContentModeScaleAspectFit;
                YJUserInfo *model = kUserInfo;
                model.user_name = [responseObj ksObjectForKey:kResult][@"name"];
                model.verify_state = [responseObj ksObjectForKey:kResult][@"verify_state"];
                model.name = [responseObj ksObjectForKey:kResult][@"name"];
                [model saveUserInfo];
            }else{
                self.nameTextField.userInteractionEnabled = NO;
                NSString *pc1url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic1"]];
                 NSString *pc2url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic2"]];
                 NSString *pc3url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic3"]];
                [self.pc1 setImageURL:[NSURL URLWithString:pc1url]];
                [self.pc2 setImageURL:[NSURL URLWithString:pc2url]];
                [self.pc3 setImageURL:[NSURL URLWithString:pc3url]];
                self.nameTextField.text = [responseObj ksObjectForKey:kResult][@"name"];
                [self.commitBtn setTitle:kLocat(@"HBMemberViewController_authstat3") forState:UIControlStateNormal];
                self.commitBtn.userInteractionEnabled = NO;
                self.pc1.contentMode = UIViewContentModeScaleAspectFit;
                self.pc2.contentMode = UIViewContentModeScaleAspectFit;
                self.pc3.contentMode = UIViewContentModeScaleAspectFit;
            }
        }else{
//            [self showTips:[responseObj ksObjectForKey:kMessage]];
//            self.pc1.image = [UIImage imageNamed:@"auth_place"];
//            self.pc2.image = [UIImage imageNamed:@"auth_place"];
//            self.pc3.image = [UIImage imageNamed:@"auth_place"];
        }
    }];
}

- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (void)topc1{
    if ([self.authStatus isEqualToString:@"1"] || [self.authStatus isEqualToString:@"2"]) {
        [ZJImageMagnification scanBigImageWithImageView:self.pc1 alpha:1.0f];
    }else{
        [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
            {
                if(selectedImageDatas.count > 0){
                    AuthViewController *vc = (AuthViewController *)fromViewController;
                    UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
                    vc.picBase1 = [vc UIImageToBase64Str:image];
                    
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    NSMutableArray *pic1Arr = [NSMutableArray array];
                    [pic1Arr addObject:[vc UIImageToBase64Str:image]];
                    param[@"img"] = [[vc arrayToJSONString:pic1Arr] base64EncodedString];
                    param[@"key"] = kUserInfo.token;
                    param[@"token_id"] = kUserInfo.user_id;
                    NSLog(@"%@",param);
                    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Upload/upload_one"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                        NSLog(@"%@",responseObj);
                        if (success) {
                            [vc showTips:@"上传成功"];
                            vc.picBase1 = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"path"];
                            [vc.pc1 setImageURL:[NSURL URLWithString:vc.picBase1]];
                            vc.pc1.contentMode = UIViewContentModeScaleAspectFit;
                            
                        }else{
                            [vc showTips:[responseObj ksObjectForKey:kMessage]];
                            vc.pc1.image = [UIImage imageNamed:@"auth_defa"];
                            vc.pc1.contentMode = UIViewContentModeCenter;
                            
                        }
                    }];
                    
                }
            }
        } cancleDidDo:^(UIViewController *fromViewController) {
            NSLog(@"没有选择图片");
            AuthViewController *vc = (AuthViewController *)fromViewController;
            vc.pc1.image = [UIImage imageNamed:@"auth_defa"];
        }];
    }
    
    
}

- (void)topc2{
    if ([self.authStatus isEqualToString:@"1"] || [self.authStatus isEqualToString:@"2"]) {
        [ZJImageMagnification scanBigImageWithImageView:self.pc2 alpha:1.0f];
    }else{
        [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
            {
                if(selectedImageDatas.count > 0){
                    
                    
                    
                    AuthViewController *vc = (AuthViewController *)fromViewController;
                    UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
                    
                    
                    [kNetwork_Tool uploadImage:image success:^(YWNetworkResultModel *data, id responseObject) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
//                    vc.picBase2 = [vc UIImageToBase64Str:image];
//                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//                    NSMutableArray *pic1Arr = [NSMutableArray array];
//                    [pic1Arr addObject:[vc UIImageToBase64Str:image]];
//                    param[@"img"] = [[vc arrayToJSONString:pic1Arr] base64EncodedString];
//                    param[@"key"] = kUserInfo.token;
//                    param[@"token_id"] = kUserInfo.user_id;
//                    NSLog(@"%@",param);
//                    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Upload/upload_one"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//                        NSLog(@"%@",responseObj);
//                        if (success) {
//                            [vc showTips:@"上传成功"];
//                            vc.picBase2 = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"path"];
//                            [vc.pc2 setImageURL:[NSURL URLWithString:vc.picBase2]];
//                            vc.pc2.contentMode = UIViewContentModeScaleAspectFit;
//                            
//                        }else{
//                            [vc showTips:[responseObj ksObjectForKey:kMessage]];
//                            vc.pc2.image = [UIImage imageNamed:@"auth_defa"];
//                            vc.pc2.contentMode = UIViewContentModeCenter;
//                        }
//                    }];
                }
            }
        } cancleDidDo:^(UIViewController *fromViewController) {
            NSLog(@"没有选择图片");
            AuthViewController *vc = (AuthViewController *)fromViewController;
            vc.pc2.image = [UIImage imageNamed:@"auth_defa"];
            vc.pc2.contentMode = UIViewContentModeCenter;
        }];
    }
   
}

- (void)topc3{
    if ([self.authStatus isEqualToString:@"1"] || [self.authStatus isEqualToString:@"2"]) {
        [ZJImageMagnification scanBigImageWithImageView:self.pc3 alpha:1.0f];
    }else{
        [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
            {
                if(selectedImageDatas.count > 0){
                    AuthViewController *vc = (AuthViewController *)fromViewController;
                    UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
                    vc.picBase3 = [vc UIImageToBase64Str:image];
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    NSMutableArray *pic1Arr = [NSMutableArray array];
                    [pic1Arr addObject:[vc UIImageToBase64Str:image]];
                    param[@"img"] = [[vc arrayToJSONString:pic1Arr] base64EncodedString];
                    param[@"key"] = kUserInfo.token;
                    param[@"token_id"] = kUserInfo.user_id;
                    NSLog(@"%@",param);
                    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Upload/upload_one"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                        NSLog(@"%@",responseObj);
                        if (success) {
                            [vc showTips:@""];
                            vc.picBase3 = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"path"];
                            [vc.pc3 setImageURL:[NSURL URLWithString:vc.picBase3]];
                            vc.pc3.contentMode = UIViewContentModeScaleAspectFit;
                            
                        }else{
                            [vc showTips:[responseObj ksObjectForKey:kMessage]];
                            vc.pc3.image = [UIImage imageNamed:@"auth_defa"];
                            vc.pc3.contentMode = UIViewContentModeCenter;
                        }
                    }];
                }
            }
        } cancleDidDo:^(UIViewController *fromViewController) {
            NSLog(@"没有选择图片");
            AuthViewController *vc = (AuthViewController *)fromViewController;
            vc.pc3.image = [UIImage imageNamed:@"auth_defa"];
            vc.pc3.contentMode = UIViewContentModeCenter;
        }];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorFromStr(@"#171F34");
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc1)];
    [self.pc1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc2)];
    [self.pc2 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc3)];
    [self.pc3 addGestureRecognizer:tap3];
    self.commitBtn.layer.cornerRadius = 8;
    self.commitBtn.layer.masksToBounds = YES;
}

-(NSString *)UIImageToBase64Str:(UIImage *)image{
    UIImage *tempimage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0)];
    //    UIImage *image = _avatar.image;
    CGSize size = [UIImage zx_scaleImage:tempimage length:100.];
    tempimage = [tempimage zx_imageWithNewSize:size];
    NSString *str = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:tempimage]]; 
    return str;
}

- (IBAction)commitAuth:(id)sender {
    //提交
    if (self.nameTextField.text.length <= 0) {
        [self showTips:@"请输入姓名"];
        return;
    }
    if (self.picBase1.length <= 0) {
        [self showTips:@"请选择证件正面照"];
        return;
    }
    if (self.picBase2.length <= 0) {
        [self showTips:@"请选择证件背面照"];
        return;
    }
    if (self.picBase3.length <= 0) {
        [self showTips:@"请选择手持证件照"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"name"] = self.nameTextField.text;
    param[@"pic1"] = self.picBase1;
    param[@"pic2"] = self.picBase2;
    param[@"pic3"] = self.picBase3;
    param[@"uuid"] = [Utilities randomUUID];
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/member_verify"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            [self showTips:@"上传成功"];
            [self getIsAuth];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}



@end
