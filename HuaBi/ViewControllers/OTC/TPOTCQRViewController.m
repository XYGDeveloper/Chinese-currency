//
//  TPOTCQRViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCQRViewController.h"

@interface TPOTCQRViewController ()

@property(nonatomic,strong)UIImageView *qrImageView;


@end

@implementation TPOTCQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setupUI
{
    self.view.backgroundColor = kWhiteColor;
    

    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 536 *kScreenHeightRatio)];
    topView.backgroundColor = kColorFromStr(@"#57A7DF");
    [self.view addSubview:topView];
    
    
    UIImageView *qrView = [[UIImageView alloc] initWithFrame:kRectMake(0, 0, 253 * kScreenHeightRatio, 253 *kScreenHeightRatio)];
    [topView addSubview:qrView];
    [qrView alignVertical];
    [qrView alignHorizontal];
    [qrView setImageWithURL:_qrString.ks_URL placeholder:nil options:YYWebImageOptionProgressive |YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    _qrImageView = qrView;
    
    
    UIButton *saveButton= [[UIButton alloc] initWithFrame:kRectMake(0, topView.bottom + 34 *kScreenHeightRatio, 268 *kScreenWidthRatio, 45) title:kLocat(@"OTC_qr_savetophone") titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [self.view addSubview:saveButton];
    saveButton.backgroundColor = kColorFromStr(@"#4173C8");
    kViewBorderRadius(saveButton, 4, 0, kRedColor);
    [saveButton alignHorizontal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.titleWithNoNavgationBar = @"";

    [self.view bringSubviewToFront:self.backBtn];
    
}
-(void)saveAction
{
    if (_qrImageView.image) {
        UIImageWriteToSavedPhotosAlbum(_qrImageView.image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    }else{
        [self downloadImageWithUrlString:_qrString];
    }

}




#pragma mark 下载图片
-(void)downloadImageWithUrlString:(NSString *)urlString
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        NSLog(@"File downloaded to: %@", filePath);
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        UIImage * image = [UIImage imageWithData:data];
        
        [self saveImage:image];
        
    }];
    [downloadTask resume];
}
//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    }
}
//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存圖片出錯%@", error.localizedDescription);
        dispatch_sync_on_main_queue(^{
            [self showTips:kLocat(@"OTC_qr_savefail")];
        });
    }
    else {
        dispatch_sync_on_main_queue(^{
            [self showTips:kLocat(@"OTC_qr_savesuccess")];
        });
        NSLog(@"保存圖片成功");
    }
}


@end
