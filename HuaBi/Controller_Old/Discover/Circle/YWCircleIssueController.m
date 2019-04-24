//
//  YWCircleIssueController.m
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleIssueController.h"
#import "YYTextView.h"
#import "YWCircleIssueCell.h"
#import "PhotoRevealCell.h"
#import <TZImagePickerController.h>
#import <ACAlertController.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//#import <AMapSearchKit/AMapSearchKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CoreCaptureHeader.h"
//#import "JSYCurrentLocationController.h"
//#import "YWCircleRecommendController.h"


#define kDisableColor kColorFromStr(@"#848698")
@interface YWCircleIssueController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate,TZImagePickerControllerDelegate,ImagePickerManagerDelegate,RCMediaViewControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *countLabel;

@property(nonatomic,strong)NSMutableArray<PhotoRevealCell *> *subsViewArr;

@property(nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,strong)UIButton *submitButton;
@property(nonatomic,strong)ACAlertController *alertVC;
@property(nonatomic,strong)YYTextView *txtView;
@property(nonatomic,strong)ImagePickerManager *imagePicker;

@property(nonatomic,assign)double longitude;
@property(nonatomic,assign)double latitude;
@property(nonatomic,strong)UILabel *addressLabel;


@property(nonatomic,strong)AVPlayer *player;
//@property(nonatomic,strong)YWGoodsModel *goodsModel;
@property(nonatomic,strong)UILabel *goodsLabel;


@end

@implementation YWCircleIssueController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseAddress:) name:@"kUserDidChooseAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetLocation:) name:@"userHasLocated" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseGoods:) name:@"kUserDidChooseRecommendGoods" object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

-(void)setupUI
{
    self.title = LocalizedString(@"Dis_PostDistrite");

    self.view.backgroundColor = kBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,  kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = [UIView new];
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleIssueCell" bundle:nil] forCellReuseIdentifier:@"YWCircleIssueCell"];
    _tableView.backgroundColor = kBGColor;
    _tableView.scrollEnabled = NO;
    [self setupNavItem];

    
}

-(void)setupNavItem
{
    //右边❓
    UIButton *refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    refreshButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [refreshButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    refreshButton.titleLabel.font = [UIFont pingFangSC_RegularFontSize:16];
    //    [refreshButton setImage:[UIImage imageNamed:@"liaotianICON"] forState:UIControlStateNormal];
    [refreshButton setTitle:LocalizedString(@"Dis_Post") forState:UIControlStateNormal];
    [refreshButton setTitleColor:kColorFromStr(@"#848698") forState:UIControlStateNormal];
    
    refreshButton.userInteractionEnabled = NO;
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    refreshButton.titleLabel.font = PFRegularFont(14);
    _submitButton = refreshButton;
    rightNegativeSpacer.width = -8;
    [refreshButton sizeToFit];  // 设置按钮大小
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: refreshButton];  // 自定义UIBarButtonItem对象
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: rightNegativeSpacer, rightItem, nil];  // 设置导航条右边的按钮
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return 1;
    }else{
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commonCellRid = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCellRid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCellRid];
        cell.selectionStyle = 0;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YYTextView *txtView = [[YYTextView alloc]initWithFrame:kRectMake(kMargin, 0, kScreenW - 24, 142)];
            [cell.contentView addSubview:txtView];
            txtView.placeholderText = LocalizedString(@"Dis_PostTips");
            txtView.delegate = self;
//            txtView.textContainerInset = UIEdgeInsetsMake(12, 0, 0, 0);
            txtView.placeholderFont = PFRegularFont(14);
            txtView.font = PFRegularFont(14);
            txtView.textColor = k323232Color;
            txtView.placeholderTextColor = kColorFromStr(@"939393");
            _txtView = txtView;

            UILabel *countLabel = [[UILabel alloc]initWithFrame:kRectMake(0, txtView.height - 20, 100, 14)];
                [cell.contentView addSubview:countLabel];
            countLabel.textColor = kColorFromStr(@"#939393");
            countLabel.font = PFRegularFont(14);
            countLabel.textAlignment = NSTextAlignmentRight;
            countLabel.text = @"0/140";
            countLabel.right = kScreenW - 12;
            _countLabel = countLabel;
//            cell.backgroundColor = kRandColor;

        }else if (indexPath.row == 1){
            CGFloat w = kScreenW - 2 * kMargin - 40;
            w = w / 5;
            UIView *bgView = [[UIView alloc]initWithFrame:kRectMake(kMargin, 15, kScreenW - 2 * kMargin, w * 2 + 10)];
            [cell.contentView addSubview:bgView];
            CGFloat margin = 10;
            NSInteger totalColumns = 5;
            NSInteger itemsCount = (_type == 0)?1:9;
 
            _subsViewArr = [NSMutableArray arrayWithCapacity:itemsCount];
            for (NSInteger i = 0; i < itemsCount; i++) {
                
                NSInteger row = i / totalColumns;
                NSInteger col = i % totalColumns;
                CGFloat x = col * (w + margin);
                CGFloat y = row * (w + margin);
                PhotoRevealCell *cell = [[PhotoRevealCell alloc]initWithFrame:kRectMake(x, y, w, w)];
                [bgView addSubview:cell];
                cell.tag = i;
                if (i == 0) {
                    cell.hasPic = YES;
                }else{
                    cell.hasPic = NO;
                }
                [cell removeData];
                
                [_subsViewArr addObject:cell];
                
                cell.deleteButton.tag = i;
                [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTapAction:)]];
                if (_type == 0) {
                    [self itemTapAction:nil];
                }
            }
 
        }else{
            
            static NSString *rid = @"YWCircleIssueCell";
            YWCircleIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            cell.infoLabel.font = PFRegularFont(14);
            cell.selectionStyle = 0;
            if (indexPath.row == 2) {
                cell.infoLabel.text = @"选择地址";
                cell.icon.image = kImageFromStr(@"coordinate");
                _addressLabel = cell.infoLabel;
            }else{
                cell.infoLabel.text = @"推荐我的宝贝";
                cell.icon.image = kImageFromStr(@"tuijianbaobei");
                _goodsLabel = cell.infoLabel;
            }

            return cell;
        }
  
    }else{
        UILabel *circleLabel = [[UILabel alloc] initWithFrame:kRectMake(kMargin, 20, 100, 14) text:@"" font:PFRegularFont(14) textColor:kColorFromStr(@"b8b8b8") textAlignment:0 adjustsFont:YES];
        if (_groupModel) {
            circleLabel.text = [NSString stringWithFormat:@"%@%@",_groupModel.city_name,_groupModel.group_name];
        }else{
            circleLabel.text  = @"广东深圳圈";
        }
        
        [cell.contentView addSubview:circleLabel];

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 2) {
//        JSYCurrentLocationController *vc = [[JSYCurrentLocationController alloc]init];
//        kNavPush(vc);
    }else if (indexPath.row == 3){
        
        if (kUserInfo.isSeller) {
//            YWCircleRecommendController *vc = [YWCircleRecommendController new];
//            vc.model = _goodsModel;
//            kNavPush(vc);
        }else{
            [self showTips:@"成为商家才能推荐宝贝哦"];
            
        }
    }
}

#pragma mark - 提交
-(void)submitAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (_txtView.text.length > 0) {
        param[@"content"] = _txtView.text;
    }
    param[@"act"] = @"district";
    param[@"op"] = @"publish";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (_groupModel) {
        param[@"group_id"] = _groupModel.group_id;
    }else{
        param[@"group_id"] = @"1";
    }
    
    if (self.dataArray.count > 0) {
        kLOG(@"%@===",[NSDate date]);
        NSMutableArray *compressArray = [NSMutableArray arrayWithCapacity:self.dataArray.count];
        
        for (UIImage *image in self.dataArray) {
            
            [compressArray addObject: [UIImage imageWithData:[self imageData:image]]];
            //            [compressArray addObject:[self imageWithImage:image scaledToSize:kSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage))]];
        }
        
        
        NSMutableArray *base64s = [NSMutableArray arrayWithCapacity:compressArray.count];
        for (UIImage *image in compressArray) {
            
            [base64s addObject:[NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:image]]];
        }
        //数组转json字符串 再base64
        NSString *jsonStr = [[self arrayToJSONString:base64s.mutableCopy] base64EncodedString];
        param[@"attachments"] = jsonStr;
        param[@"attachments_type"] = @"image";
        kLOG(@"%@===",[NSDate date]);

    }else if(_hasVideo == YES){//视频
        
        NSData *data = [NSData dataWithContentsOfFile:_videoPath];
        NSString *encodedImageStr = [data base64EncodedString];
        
        //        NSArray *base64 = @[[NSString stringWithFormat:@"%@%@",@"data:video/mp4;base64,",encodedImageStr]];
        //        NSString *jsonStr = [[self arrayToJSONString:base64]base64EncodedString];
        param[@"attachments"] = [NSString stringWithFormat:@"%@%@",@"data:video/mp4;base64,",encodedImageStr];
        
        param[@"attachments_thumbnail"] = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:_thumbnail]];
        
        param[@"attachments_type"] = @"video";
    }
    
    if (_longitude > 0) {
        param[@"longitude"] = @(_longitude);
        param[@"latitude"] = @(_latitude);
        param[@"location"] = _addressLabel.text;
    }
    
//    if (_goodsModel) {
//        param[@"goods_id"] = _goodsModel.goods_id;
//        param[@"goods_name"] = _goodsModel.goods_name;
//        param[@"goods_image_url"] = _goodsModel.img_url;
//        param[@"goods_url"] = _goodsModel.goods_url;
//        param[@"goods_price"] = _goodsModel.goods_price;
//    }
    
    
    param[@"uuid"] = [Utilities randomUUID];
    

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kDistrictPublish] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            [self showTips:LocalizedString(@"Dis_PostSuccess")];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidSubmitDistrictKey object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backAction];
            });
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];
    
    
    
}




#pragma mark - 照片按钮删除事件
-(void)deleteAction:(UIButton *)button
{
    if (_hasVideo == YES && _type == 0) {
        [self.subsViewArr.firstObject removeData];
        //        self.subsViewArr[1].hasPic = NO;
        _hasVideo = NO;
        _submitButton.userInteractionEnabled = NO;
        [_submitButton setTitleColor:kColorFromStr(@"#64696f") forState:UIControlStateNormal];
        
        return;
    }
    [self.dataArray removeObjectAtIndex:button.tag];
    
    if ( button.tag == 0 && self.dataArray.count == 0) {
        
        [self.subsViewArr.firstObject removeData];
        self.subsViewArr[1].hasPic = NO;
        
    }else{
        
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            [self.subsViewArr[i] reloadDataWithImage:self.dataArray[i]];
        }
        for (NSInteger i = self.dataArray.count; i < self.subsViewArr.count; i++) {
            [self.subsViewArr[i] removeData];
            self.subsViewArr[i].hasPic = NO;
        }
        self.subsViewArr[self.dataArray.count].hidden = NO;
    }
}
//照片添加事件
-(void)itemTapAction:(UITapGestureRecognizer *)tap
{
    [self hideKeyBoard];
    
    if (_type == 0) {
        _selectedIndex = 0;

        RCMediaViewController *rvc = [[RCMediaViewController alloc] init];
        rvc.mediaDelegate = self;
        rvc.title = LocalizedString(@"Dis_RecordVideo");
        _type = 0;
        [self.navigationController pushViewController:rvc animated:YES];
        
        return;
    }
    _selectedIndex = tap.view.tag;

    __weak typeof(self)weakSelf = self;

    ACAlertController *alertVc = [[ACAlertController alloc]initWithActionSheetTitles:@[LocalizedString(@"Dis_TakePhoto"),LocalizedString(@"Dis_ChooseFromAlbum")] cancelTitle:LocalizedString(@"Cancel")];
    alertVc.cancelButtonTextFont = PFRegularFont(14);
    alertVc.cancelButtonTextColor = k323232Color;
    alertVc.actionButtonsTextFont = PFRegularFont(14);
    alertVc.actionButtonsTextColor = k323232Color;
    
   
    [alertVc clickActionButton:^(NSInteger index) {
        if (index == 0) {//拍照
            [self.imagePicker requestImagePickerWithCamera:YES controller:self];

        }else{//相册
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:9 - weakSelf.dataArray.count columnNumber:4 delegate:self pushPhotoPickerVc:NO];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
                [weakSelf.dataArray addObjectsFromArray:photos];
                [self reloadPicView];
                
            }];

            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
    }];
     [alertVc show];
    
}

//imgaePicker回调
-(void)pickerImage:(UIImage *)image
{
    
    
    if (_selectedIndex == self.dataArray.count) {
        [self.dataArray addObject:image];
    }else{
        [self.dataArray replaceObjectAtIndex:_selectedIndex withObject:image];
    }
    
    [_subsViewArr[_selectedIndex] reloadDataWithImage:image];
    _subsViewArr[_selectedIndex].hasPic = YES;
    
    
    if (_selectedIndex < 8) {
        _subsViewArr[_selectedIndex + 1].hasPic = YES;
        _subsViewArr[_selectedIndex + 1].deleteButton.hidden = YES;
    }
    if (_txtView.text.length > 0 || self.dataArray.count > 0) {
        _submitButton.userInteractionEnabled = YES;
        [_submitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        
    }else{
        [_submitButton setTitleColor:kColorFromStr(@"#64696f") forState:UIControlStateNormal];
        
        _submitButton.userInteractionEnabled = NO;
    }
}
#pragma mark - 视频回调
-(void)rc_mediaController:(RCMediaViewController *)media didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *video_url = info[RCMediaVideoInfo];
    UIImage *image = [RCMediaViewController getCoverImage:video_url];
    [self.subsViewArr.firstObject reloadDataWithImage:image];
    kLOG(@"%@,%@",video_url,image);
    _thumbnail = image;
    _hasVideo = YES;
    _videoPath = video_url;
    _submitButton.userInteractionEnabled = YES;
    [_submitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    
}
-(void)reloadPicView
{
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        PhotoRevealCell *cell = self.subsViewArr[i];
        [cell reloadDataWithImage:self.dataArray[i]];
        cell.hidden = NO;
        cell.hasPic = YES;
    }
    if (self.dataArray.count < 8) {
        _subsViewArr[self.dataArray.count ].hasPic = YES;
        _subsViewArr[self.dataArray.count ].deleteButton.hidden = YES;
    }
    
    if (_txtView.text.length > 0 || self.dataArray.count > 0) {
        _submitButton.userInteractionEnabled = YES;
        [_submitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }else{
        [_submitButton setTitleColor:kDisableColor forState:UIControlStateNormal];
        _submitButton.userInteractionEnabled = NO;
    }
}


-(void)textViewDidChange:(YYTextView *)textView
{
    _countLabel.text = [NSString stringWithFormat:@"%zd/140",textView.text.length];
    if (_txtView.text.length > 0 || self.dataArray.count > 0) {
        _submitButton.userInteractionEnabled = YES;
        [_submitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }else{
        [_submitButton setTitleColor:kDisableColor forState:UIControlStateNormal];
        _submitButton.userInteractionEnabled = NO;
    }
}


#pragma mark - 定位回调

-(void)didChooseAddress:(NSNotification *)noti
{
//    if ([noti.object isKindOfClass:[AMapPOI class]]) {
//        AMapPOI * poi = noti.object;
//        _addressLabel.text = poi.name;
//        _latitude = poi.location.latitude;
//        _longitude = poi.location.longitude;
//    }else{
//        _addressLabel.text = @"所在位置";
//        _latitude = 0;
//        _longitude = 0;
//    }
}

-(void)didGetLocation:(NSNotification *)noti
{
    CLLocation *location = noti.object;
    _latitude = location.coordinate.latitude;
    _longitude = location.coordinate.longitude;
}


-(void)didChooseGoods:(NSNotification *)noti
{
//    _goodsModel = noti.object;
//    if (_goodsModel) {
//        _goodsLabel.text = _goodsModel.goods_name;
//    }else{
//        _goodsLabel.text = @"推荐我的宝贝";
//    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 100;
    }else{
        if (indexPath.row == 0) {
            return 135;
        }else if (indexPath.row == 1){
            return (kScreenW - 2 * kMargin - 40) / 5 * 2 + 20 + 10 + 15;
        }else {
            return 50;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ) {
        return 5;
    }else{
        return 0.01;
    }
}
-(ACAlertController *)alertVC
{
    if (_alertVC == nil) {
        ACAlertController *alertVc = [[ACAlertController alloc]initWithActionSheetTitles:@[@"拍照",@"从手机相册选择"] cancelTitle:@"取消"];
        alertVc.cancelButtonTextFont = PFRegularFont(14);
        alertVc.cancelButtonTextColor = k323232Color;
        alertVc.actionButtonsTextFont = PFRegularFont(14);
        alertVc.actionButtonsTextColor = k323232Color;
        _alertVC = alertVc;
    }
    return _alertVC;
}

-(ImagePickerManager *)imagePicker
{
    
    if (_imagePicker == nil) {
        _imagePicker = [[ImagePickerManager alloc]init];
        _imagePicker.imagePickerMgrDelegate = self;
    }
    return _imagePicker;
}


-(NSData *)imageData:(UIImage *)myimage
{
    myimage = [self imageWithImage:myimage scaledToSize:CGSizeMake(CGImageGetWidth(myimage.CGImage), CGImageGetHeight(myimage.CGImage))];
    
    NSData *data=UIImageJPEGRepresentation(myimage, 1);
    //    if (data.length>100*1024) {
    //        if (data.length>1024*1024) {//1M以及以上
    //            data=UIImageJPEGRepresentation(myimage, 0.1);
    //        }else if (data.length>512*1024) {//0.5M-1M            data=UIImageJPEGRepresentation(myimage, 0.5);
    //        }else if (data.length>200*1024) {//0.25M-0.5M            data=UIImageJPEGRepresentation(myimage, 0.9);
    //        }
    //    }
    return data;
}

- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    //    newSize = kSizeMake(kScreenW, kScreenW);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
