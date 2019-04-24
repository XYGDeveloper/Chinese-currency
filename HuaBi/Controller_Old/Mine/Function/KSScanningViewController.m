
//
//  lhScanQCodeViewController.m
//  lhScanQCodeTest
//
//  Created by bosheng on 15/10/20.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "KSScanningViewController.h"
#import "QRCodeReaderView.h"
//#import "JSYBaseWebController.h"
#import "XYLScanView.h"
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
//#import "JSYScanConfirmController.h"


#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

@interface KSScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate, XYLScanViewDelegate>
{
    AVCaptureDevice *frontCamera;  //前置摄像机
    AVCaptureDevice *backCamera;  //后置摄像机
    AVCaptureSession *session;         //捕捉对象
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureInput *input;              //输入流
    AVCaptureMetadataOutput *output;//输出流
    BOOL isTorchOn;

}

@property (strong, nonatomic) CIDetector *detector;
@property (nonatomic, assign) XYLScaningWarningTone tone;
@property (nonatomic, strong) XYLScanView *overView;    //扫码界面
//@property(weak, nonatomic)UILabel *titleLabel;
@end

@implementation KSScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"扫一扫";
    self.title = kLocat(@"K_Scan");
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//  @{NSFontAttributeName:[UIFont systemFontOfSize:18],
//    NSForegroundColorAttributeName:kWhiteColor}];
//    self.navigationItem.leftBarButtonItems = [NSArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAction) name:@"kDidConfirmLoginByPhone" object:nil];

    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(kMargin, 475 * kScreenHeightRatio, kScreenW - 2 * kMargin, 15)];
    label.text = @"将二维码放入框内,即可自动扫描";
    label.text = kLocat(@"K_ScanTips");
    
//    label.textColor = kColorFromStr(@"#8d8d8f");
    label.textColor = kWhiteColor;

    label.font = PFRegularFont(14);
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;

    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(0);
//        make.height.equalTo(15);
//        make.top.equalTo(475 * kScreenHeightRatio);
//    }];
    
    UIBarButtonItem *rbbItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(alumbBtnEvent)];
//    self.navigationItem.rightBarButtonItem = rbbItem;
    rbbItem.tintColor = kWhiteColor;
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonEvent)];
//    backItem.tintColor = kWhiteColor;
//    self.navigationItem.leftBarButtonItem = backItem;
//    [ZZFactory addPopBackItemForVC:self];
    // 开始扫描
    [self scanSelected];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self.overView isDisplayedInScreen])
    {
        [session stopRunning];
        [self.overView removeFromSuperview];
        self.overView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    if (previewLayer) {
//        [previewLayer removeFromSuperlayer];
//    }
    [self scanSelected];
    [session startRunning];

}

//点击扫码
-(void)scanSelected
{
    if (![self.overView isDisplayedInScreen])
    {
#if TARGET_IPHONE_SIMULATOR
        UIAlertController *simulatorAlert = [UIAlertController alertControllerWithTitle:nil message:@"虚拟机不支持相机" preferredStyle:UIAlertControllerStyleActionSheet];
        [simulatorAlert addAction:[UIAlertAction actionWithTitle:@"好吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return;
        }]];
        [self presentViewController:simulatorAlert animated:YES completion:nil];
        
#elif TARGET_OS_IPHONE
        
        //判断相机权限
        if ([self isVideoUseable] == NO) {
            UIAlertController *simulatorAlert = [UIAlertController alertControllerWithTitle:nil message:@"相机权限未开通，请前往设置打开" preferredStyle:UIAlertControllerStyleActionSheet];
            [simulatorAlert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self backAction];
            }]];
            [self presentViewController:simulatorAlert animated:YES completion:nil];
            return;
        }
        
        [self isVideoUseable];
        if (self.overView) {
            self.overView.hidden = NO;
        }else{
            //添加扫面界面视图
            [self initOverView];
            [self initCapture];
            [self config];
            [self addGesture];
        }
#endif
    }
}

-(BOOL)isVideoUseable
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//        UIAlertController *simulatorAlert = [UIAlertController alertControllerWithTitle:nil message:@"相机权限未开通，请打开" preferredStyle:UIAlertControllerStyleActionSheet];
//        [simulatorAlert addAction:[UIAlertAction actionWithTitle:@"好吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            return;
//        }]];
//        [self presentViewController:simulatorAlert animated:YES completion:nil];
        return NO;
    }else{
        return YES;
    }
}

/**
 *  添加扫码视图
 */
- (void)initOverView
{
    if (!_overView) {
        _overView = [[XYLScanView alloc]initWithFrame:[UIScreen mainScreen].bounds lineMode:XYLScaningLineModeImge ineMoveMode:XYLScaningLineMoveModeUpAndDown];
        _overView.delegate = self;
        [self.view insertSubview:_overView atIndex:1];
    }
    
}

- (void)view:(UIView *)view didCatchGesture:(UIGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ViewWillDisappearNotification" object:nil];
}

- (void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{}

//设置扫描反馈模式：这里是声音提示
- (void)config{
    _tone = XYLScaningWarningToneSound;
}

- (void)initCapture
{
    //创建捕捉会话
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //获取摄像设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in devices) {
        if (camera.position == AVCaptureDevicePositionFront) {
            frontCamera = camera;
        }else{
            backCamera = camera;
        }
    }
    //创建输入流
    input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
    
    //输出流
    output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //添加输入设备(数据从摄像头输入)
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    //添加输出数据
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    //设置设置输入元数据的类型(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,              AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code,
                                   AVMetadataObjectTypeUPCECode,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                AVMetadataObjectTypeCode39Mod43Code];
    
    //添加扫描图层
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    //开始捕获
    [session startRunning];
    
    CGFloat screenHeight = ScreenSize.height;
    CGFloat screenWidth = ScreenSize.width;
    CGRect cropRect = CGRectMake((screenWidth - TransparentArea([_overView width], [_overView height]).width) / 2,
                                 (screenHeight - TransparentArea([_overView width], [_overView height]).height) / 2,
                                 TransparentArea([_overView width], [_overView height]).width,
                                 TransparentArea([_overView width], [_overView height]).height);
    //设置扫描区域
    [output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                         cropRect.origin.x / screenWidth,
                                         cropRect.size.height / screenHeight,
                                         cropRect.size.width / screenWidth)];
    
}

/**
 * 获取扫描数据
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadateObject = [metadataObjects objectAtIndex:0];
        stringValue = metadateObject.stringValue;
        [self readingFinshedWithMessage:stringValue];
        [previewLayer removeFromSuperlayer];
    }
}




#pragma mark - 读取扫描结果
/**
 *  读取扫描结果
 */
- (void)readingFinshedWithMessage:(NSString *)msg
{
    if (msg) {
        [session stopRunning];
//        [self saveInformation:msg];
        [self playSystemSoundWithStyle:_tone];
        [self.overView stopMove];
        kLOG(@"扫描结果-->%@",msg);
        self.callBackBlock(msg);
        kNavPop;
        
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
//        param[@"type"] = @"scan";
//        param[@"content"] = msg;
//        param[@"key"] = kUserInfo.token;
//        param[@"act"] = @"mb_index";
//        param[@"op"] = @"scanlogin";
//        param[@"uuid"] = [Utilities randomUUID];
//        kShowHud;
//        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kScanForLogin] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//            kHideHud;
//            if (success) {
#pragma mark - 扫描结果
//                JSYScanConfirmController *vc = [[JSYScanConfirmController alloc]init];
//                vc.content = msg;
//                [self presentViewController:vc animated:YES completion:nil];
//            }else{
//
//                [self showTips:[responseObj ksObjectForKey:kMessage]];
//
//                if ([[responseObj ksObjectForKey:@"code"] intValue] == 10100) {
//                    [self gotoLoginVC];
//                }
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                    [self.overView removeFromSuperview];
//                    self.overView = nil;
//
//                    [session startRunning];
//                    [self scanSelected];
//
//
//                });
//
//            }
//
//        }];

    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"读取失败" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确定");
           
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)saveInformation:(NSString *)strValue{
    
    NSMutableArray *history = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"history"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[strValue, [self getSystemTime]] forKeys:@[@"value",@"time"]];
    if (!history)
    {
        history = [NSMutableArray array];
    }
    [history addObject:dic];
    [[NSUserDefaults standardUserDefaults]setObject:history forKey:@"history"];
}

- (NSString *)getSystemTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

/**
 *  展示声音提示
 */
- (void)playSystemSoundWithStyle:(XYLScaningWarningTone)tone{
    
    NSString *path = [NSString stringWithFormat:@"%@/scan.wav", [[NSBundle mainBundle] resourcePath]];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(filePath), &soundID);
    switch (tone) {
        case XYLScaningWarningToneSound:
            AudioServicesPlaySystemSound(soundID);
            break;
        case XYLScaningWarningToneVibrate:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            break;
        case XYLScaningWarningToneSoundAndVibrate:
            AudioServicesPlaySystemSound(soundID);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 返回
- (void)backButtonEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    // 关闭图层上面的扫描视图
    if ([self.overView isDisplayedInScreen])
    {
        //停止扫描
        [session stopRunning];
        [self.overView removeFromSuperview];
        self.overView = nil;
        
    }  //扫描图像从图层上面移除
    [previewLayer removeFromSuperlayer];
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    NSArray *features = [self.detector featuresInImage:ciImage];

    if (features.count >=1) {
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //播放扫描二维码的声音
//            SystemSoundID soundID;
//            NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
//            AudioServicesPlaySystemSound(soundID);
            [session stopRunning];
            [self accordingQcode:scannedResult];
        }];
    }
    else{
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            [session startRunning];
            [self scanSelected];

        }];
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [session startRunning];
        [self scanSelected];
    }];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{
//    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
//    JSYBaseWebController *vc = [[JSYBaseWebController alloc] init];
//    vc.urlStr = str;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
