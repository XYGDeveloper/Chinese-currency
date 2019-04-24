//
//  HBTokenTopUpTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBTokenTopUpTableViewController.h"
#import "NSObject+SVProgressHUD.h"
#import "HBTokenTopUpRecordsViewController.h"
#import "HBSelectTokenTableViewController.h"
#import "HBTakeTmodel.h"
#import "HBTakeTokenRecordViewController.h"
#import <CoreImage/CoreImage.h>
#import "HBTokenListModel.h"
#import "QRcodeManager.h"
typedef void (^selectCurrencyCate)(NSString *currency);
@interface HBTokenTopUpTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *takeTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *seleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveQRCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *topUpUrlLabel;
@property (weak, nonatomic) IBOutlet UIButton *duplicateButton;
@property (nonatomic,strong)selectCurrencyCate currencyCate;
@property (weak, nonatomic) IBOutlet UILabel *chongDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;

@property (nonatomic,strong)HBTakeTmodel *model;
@end

@implementation HBTokenTopUpTableViewController

#pragma mark - Lifecycle

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"TopupAndWithdraw" bundle:nil] instantiateViewControllerWithIdentifier:@"HBTokenTopUpTableViewController"];
}

- (void)loaddata{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = self.currencyid;
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/bpay"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSLog(@"%@",[responseObj ksObjectForKey:kResult]);
            self.model = [HBTakeTmodel mj_objectWithKeyValues:[responseObj ksObjectForKey:kResult]];
            self.topUpUrlLabel.text = self.model.chongzhi_url;
            if (self.model.chongzhi_url.length <= 0) {
                self.qrImageView.image = [UIImage imageNamed:@"zhanweitu"];
            }else{
                [self getqrimg:self.model.chongzhi_url];
            }
            self.takeTypeLabel.text = [NSString stringWithFormat:@"%@%@",_currencyname,kLocat(@"k_ExchangeRecordViewController_topbar_1")];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            self.qrImageView.image = [UIImage imageNamed:@"zhanweitu"];
        }
    }];
}



/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)getqrimg:(NSString *)url{
    // 1.创建过滤器 -- 苹果没有将这个字符封装成常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
    NSString *dataString = url;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.显示二维码
   self.qrImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.qrImageView.width];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_ExchangeRecordViewController_topbar_1");
    self.currencyNameLabel.text = _currencyname;
    self.chongDesLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_chongbi");
    [self.seleBtn setTitle:kLocat(@"HBTokenWithdrawViewController_select") forState:UIControlStateNormal];
    [self.saveQRCodeButton setTitle:kLocat(@"HBTokenWithdrawViewController_saveqrcode") forState:UIControlStateNormal];
    [self.duplicateButton setTitle:kLocat(@"HBTokenWithdrawViewController_copy") forState:UIControlStateNormal];
    [self loaddata];
}

#pragma mark - Actions

- (IBAction)showRecordsAction:(id)sender {
    HBTakeTokenRecordViewController *recorder = [HBTakeTokenRecordViewController new];
    recorder.currency_id = self.currencyid;
    recorder.type = @"0";
    kNavPush(recorder);
}

- (IBAction)saveQrImageAction:(id)sender {
    if (self.qrImageView.image == nil) {
        return;
    }
    [[QRcodeManager sharedInstance] saveImageToPhotosWithView:self.qrImageView Scale:0 Block:^(BOOL success, NSError *error) {
        if (success) {
            [self showSuccessWithMessage:kLocat(@"HBHomeViewController_address_saveimg_scuess")];
        }else{
            [self showErrorWithMessage:kLocat(@"HBHomeViewController_address_saveimg_fail")];
        }
    }];
}

- (IBAction)copyURLAction:(id)sender {
    NSString *urlString = self.topUpUrlLabel.text;
    if (urlString.length > 0) {
        [UIPasteboard generalPasteboard].string = urlString;
        [self showSuccessWithMessage:kLocat(@"Copied")];
    }
}

- (IBAction)toSelectCurrencyCate:(id)sender {
    HBSelectTokenTableViewController *vc = [HBSelectTokenTableViewController new];
    vc.select = ^(HBTokenListModel * _Nonnull model) {
        self.currencyid = model.currency_id;
        self.currencyNameLabel.text = model.currency_name;
        _currencyname = model.currency_name;
        [self loaddata];
    };
    kNavPush(vc);
}

@end
