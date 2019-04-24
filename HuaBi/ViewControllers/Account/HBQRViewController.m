//
//  HBQRViewController.m
//  HuaBi
//
//  Created by l on 2018/10/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBQRViewController.h"

@interface HBQRViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRimg;
@property (weak, nonatomic) IBOutlet UIView *paltformBg;
@property (weak, nonatomic) IBOutlet UIButton *pasteBtn;

@end

@implementation HBQRViewController


- (IBAction)saveAction:(id)sender {
    
    [self showTips:@"保存成功"];
    UIAlertController *con = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存图片" preferredStyle:1];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_sure") style:0 handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.QRimg.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),NULL); // 写入相册
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_cancel") style:0 handler:nil];
           [con addAction:action];
    [con addAction:action1];
    [self presentViewController:con animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.QRimg setImageWithURL:[NSURL URLWithString:self.qrimg] placeholder:[UIImage imageNamed:@"shou_icon_ewm"]];
    if ([self.type isEqualToString:@"1"]) {
        self.paltformBg.backgroundColor = kRGBA(105, 175, 238, 1);
    }else{
        self.paltformBg.backgroundColor = kRGBA(115, 213, 114, 1);
    }
    self.pasteBtn.layer.cornerRadius = 8;
    self.pasteBtn.layer.masksToBounds = YES;
    [self.pasteBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
