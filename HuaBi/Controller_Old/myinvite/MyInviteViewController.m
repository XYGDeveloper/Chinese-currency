//
//  MyInviteViewController.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyInviteViewController.h"
#import "TOActionSheet.h"

@interface MyInviteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *invitedes;
@property (weak, nonatomic) IBOutlet UILabel *wailLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *pasteContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *pasteBtn;
@property (nonatomic, copy) NSString *URLString;

@end

@implementation MyInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.URLString = [NSString stringWithFormat:@"%@%@%@",kBasePath,@"/Reg/mobile/Member_id/",kUserInfo.user_id];
    self.title = kLocat(@"k_MyinviteViewController_top_label_0");
    
    self.bgview.layer.cornerRadius = 8; //设置imageView的圆角
    
    self.bgview.userInteractionEnabled = YES;
    
    self.bgview.layer.masksToBounds = YES;
    
     self.bgview.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    
     self.bgview.layer.shadowOpacity = 0.8;//设置阴影的透明度
    
     self.bgview.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
    
     self.bgview.layer.shadowRadius = 3;//设置阴影的圆角
    self.bgview.backgroundColor = kThemeColor;
    
    self.pasteContentLabel.layer.borderColor = kColorFromStr(@"#A97815").CGColor;
    self.pasteContentLabel.layer.borderWidth = 1.0f;
    self.pasteContentLabel.text = [NSString stringWithFormat:@"%@：%@%@%@", kLocat(@"k_MyinviteViewController_text_field_msg"), kBasePath,@"/Reg/mobile/Member_id/",kUserInfo.user_id];
    self.pasteContentLabel.lineBreakMode = NSLineBreakByClipping;
    [self.pasteBtn setTitle:kLocat(@"k_MyinviteViewController_top_label_paste_btn") forState:UIControlStateNormal];
    self.wailLabel.text = kLocat(@"k_MyinviteViewController_top_label_wailt");
    self.numberLabel.text = [NSString stringWithFormat:@"%@\"%@\"，%@%@%@",kLocat(@"k_MyinviteViewController_i_am"), kUserInfo.phone,kLocat(@"k_MyinviteViewController_hua_bi_hui_yuan"), kUserInfo.user_id, kLocat(@"k_MyinviteViewController_hua_bi_hui_yuan_num")];
     self.des.text = kLocat(@"k_MyinviteViewController_top_label_1");
     self.detail.text = kLocat(@"k_MyinviteViewController_top_label_2");
     self.invitecode.font = [UIFont systemFontOfSize:30.0];
     self.invitecode.text = [NSString stringWithFormat:@"%@",kUserInfo.user_id];
    self.invitedes.text = kLocat(@"k_MyinviteViewController_top_label_3_1");
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.QRcode.width, self.QRcode.height)];
    
    img.userInteractionEnabled = YES;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        UIImage *qrImg = [Utilities getQRImageWithContent:self.URLString];
        dispatch_async(dispatch_get_main_queue(), ^{
            img.image = qrImg;
        });
    });
    
    [self.QRcode addSubview:img];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        TOActionSheet *actionSheet = [[TOActionSheet alloc] init];
        actionSheet.title = kLocat(@"k_MyinviteViewController_top_label_3");
        actionSheet.contentstyle = TOActionSheetContentStyleDefault;
        [actionSheet addButtonWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") icon:nil tappedBlock:^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.URLString]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.URLString]];
            }
        }];
        actionSheet.actionSheetDismissedBlock = ^{
            NSLog(@"dissmiss");
        };
        [actionSheet showFromView:nil inView:self.view];
      
    }];
    [img addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pasteAction:(id)sender {
    [self showTips:kLocat(@"Copied")];
    if (self.URLString) {
        [UIPasteboard generalPasteboard].string = self.URLString;
    }
    
    
}

@end
