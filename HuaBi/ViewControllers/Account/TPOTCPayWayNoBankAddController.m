//
//  TPOTCPayWayNoBankAddController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPayWayNoBankAddController.h"
#import "TPOTCPayWayAddTFCell.h"
#import "TPOTCPayWayListController.h"
#import "UIImage+ZXCompress.h"

@interface TPOTCPayWayNoBankAddController ()<UITableViewDelegate,UITableViewDataSource,ImagePickerManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)ImagePickerManager *imagePicker;
@property(nonatomic,strong)UIImageView *pic;
@property(nonatomic,strong)UIButton *addButton;


@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *accountTF;
@property(nonatomic,strong)UITextField *payPWDTF;

@property(nonatomic,strong)UITextField *deleteTF;




@end

@implementation TPOTCPayWayNoBankAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorFromStr(@"#0B132A");
    [self setupUI];
    if (_type == TPOTCPayWayNoBankAddControllerTypeListWX || _type == TPOTCPayWayNoBankAddControllerTypeListZFB) {
        [self addRightBarButtonWithFirstImage:kImageFromStr(@"shoukuan_icon_bianji") action:@selector(finishAction)];
    }else{
        [self addNavi];
    }
}

-(void)addNavi
{
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"k_popview_select_paywechat_finish") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kColorFromStr(@"#11B1ED") forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = PFRegularFont(16);
    [rightbBarButton addTarget:self action:@selector(finishAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
}

-(void)setupUI
{
    if (_type == TPOTCPayWayNoBankAddControllerTypeAddWX) {
        self.title = kLocat(@"k_popview_select_paywechat_addwechat");
    }else if(_type == TPOTCPayWayNoBankAddControllerTypeAddZFB){
        self.title = kLocat(@"k_popview_select_paywechat_addalipay");
    }else if(_type == TPOTCPayWayNoBankAddControllerTypeListZFB){
        self.title =kLocat(@"k_popview_select_payalipay");
    }else if(_type == TPOTCPayWayNoBankAddControllerTypeListWX){
        self.title = kLocat(@"k_popview_select_paywechat");
    }else if(_type == TPOTCPayWayNoBankAddControllerTypeEditWX){
        self.title = kLocat(@"k_popview_select_paywechat_editwechat");
    }else if(_type == TPOTCPayWayNoBankAddControllerTypeEditZFB){
        self.title =kLocat(@"k_popview_select_paywechat_editalipay");
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH ) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    [_tableView reloadData];
    _tableView.backgroundColor = kColorFromStr(@"#0B132A");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPayWayAddTFCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPayWayAddTFCell"];
    
    _tableView.bounces = NO;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_type == TPOTCPayWayNoBankAddControllerTypeListZFB || _type == TPOTCPayWayNoBankAddControllerTypeListWX ) {
        static NSString *rid = @"TPOTCPayWayAddTFCell";
        TPOTCPayWayAddTFCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.tf.userInteractionEnabled = YES;
        if (indexPath.section == 0) {
            cell.tf.userInteractionEnabled = NO;
            if (!_model.name) {
                cell.tf.text =kUserInfo.user_name;
            }else{
                cell.tf.text =_model.name;
            }
            
        }else if (indexPath.section == 1){
            cell.tf.text = _model.cardnum;

        }else if (indexPath.section == 2){
            
            cell.tf.text = kLocat(@"k_popview_select_paywechat_rececode");
            cell.tf.textColor = kColorFromStr(@"#545762");
            cell.tf.userInteractionEnabled = NO;
            UIImageView *icon = [[UIImageView alloc] initWithFrame:kRectMake(kScreenW - 12 - 22, 4, 22, 22)];
            icon.image = kImageFromStr(@"shou_icon_ewm");
            [cell.contentView addSubview:icon];
            
            icon.userInteractionEnabled = YES;
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showQRCode)]];
            
        }
        return cell;
        
    }else{
        
        if (indexPath.section == 0) {
            UITableViewCell *cell = [UITableViewCell new];
            UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(12, 0, kScreenW - 24, 170)];
            [cell.contentView addSubview:bgView];
            bgView.backgroundColor = kColorFromStr(@"#282D39");
            cell.contentView.backgroundColor = kColorFromStr(@"#0B132A");
            
            UIImageView *pic = [[UIImageView alloc] initWithFrame:bgView.bounds];
            [bgView addSubview:pic];
            pic.backgroundColor = kClearColor;
            _pic = pic;
            pic.userInteractionEnabled = YES;
            [pic addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSelectePhoto)]];
            
            UIButton *addButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 50, 50)];
            [bgView addSubview:addButton];
            [addButton alignVertical];
            [addButton alignHorizontal];
            _addButton = addButton;
            [addButton addTarget:self action:@selector(toSelectePhoto) forControlEvents:UIControlEventTouchUpInside];
            [addButton setImage:kImageFromStr(@"shoukuan_icon_shc") forState:UIControlStateNormal];
            cell.selectionStyle = 0;
            
            if (_model) {
                [_pic setImageWithURL:_model.img.ks_URL placeholder:nil];
            }
            
            return cell;
        }else{
            
            static NSString *rid = @"TPOTCPayWayAddTFCell";
            TPOTCPayWayAddTFCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            if (indexPath.section == 1) {
                cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"k_popview_select_paywechat_name_placehoder") attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"#545762")}];
                _nameTF = cell.tf;
                _nameTF.userInteractionEnabled = NO;
                _nameTF.text = kUserInfo.user_name;
            }else if (indexPath.section == 2){
                cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"k_popview_select_paywechat_accounter_placehoder") attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"#545762")}];
                _accountTF = cell.tf;
                if (_model) {
                    _accountTF.text = _model.cardnum;
                }
            }else if (indexPath.section == 3){
                cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"k_popview_select_paywechat_pwd_placehoder") attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"#545762")}];
                cell.tf.keyboardType = UIKeyboardTypeNumberPad;
                cell.tf.secureTextEntry = YES;
                _payPWDTF = cell.tf;
            }
            return cell;
        }
    }
    
    return nil;
}

-(void)toSelectePhoto
{
    [self.imagePicker requestImagePickerWithCamera:NO controller:self];

}
-(void)pickerImage:(UIImage *)image
{
    _pic.image = image;
    _addButton.hidden = YES;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == TPOTCPayWayNoBankAddControllerTypeListZFB || _type == TPOTCPayWayNoBankAddControllerTypeListWX ) {
        return 34;
    }
    
    if (indexPath.section == 0) {
        return 170;
    }
    return 34;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 300, 52)];
    headView.backgroundColor = kColorFromStr(@"#0B132A");
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 200, headView.height) text:self.titleArray[section] font:PFRegularFont(12) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [headView addSubview:label];
    [label alignVertical];
    
    return headView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


-(void)finishAction
{
    [self hideKeyBoard];
    //list
    if (_type == TPOTCPayWayNoBankAddControllerTypeListWX || _type == TPOTCPayWayNoBankAddControllerTypeListZFB ) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *desAction = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_action") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            TPOTCPayWayNoBankAddController *vc = [[TPOTCPayWayNoBankAddController alloc] init];
            if (_type == TPOTCPayWayNoBankAddControllerTypeListWX) {
                vc.type = TPOTCPayWayNoBankAddControllerTypeEditWX;
            }else{
                vc.type = TPOTCPayWayNoBankAddControllerTypeEditZFB;
            }
            vc.model = _model;
            kNavPush(vc);
        }];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_unbind") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self showTipsView];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_cancel") style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:desAction];
        [alertController addAction:deleteAction];
        [desAction setValue:kColorFromStr(@"#11B1ED") forKey:@"titleTextColor"];
        [deleteAction setValue:kColorFromStr(@"#11B1ED") forKey:@"titleTextColor"];
        [cancelAction setValue:kColorFromStr(@"#11B1ED") forKey:@"titleTextColor"];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{//提交
        
        if (_payPWDTF.text.length == 0) {
            [kKeyWindow showWarning:kLocat(@"k_popview_select_paywechat_pwd_placehoder")];
            return;
        }
        if (_accountTF.text.length == 0) {
            [kKeyWindow showWarning:kLocat(@"OTC_payway_enteraccount")];
            return;
        }
        if (_pic.image == nil) {
            
            [kKeyWindow showWarning:kLocat(@"oOTC_payway_choosepic")];
            return;
        }
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = kUserInfo.user_id;
        param[@"name"] = _nameTF.text;
        param[@"pwd"] = [_payPWDTF.text md5String];
        if (_model) {
            param[@"id"] = _model.pid;
        }
        if (_type == TPOTCPayWayNoBankAddControllerTypeAddWX || _type == TPOTCPayWayNoBankAddControllerTypeEditWX) {
            param[@"type"] = kWechat;
        }else{
            param[@"type"] = kZFB;
        }
        param[@"cardnum"] = _accountTF.text;
        
//        UIImage * image = _pic.image;
        UIImage * image = [UIImage imageWithData:[self imageData:_pic.image]];

        CGSize size = [UIImage zx_scaleImage:image length:180.];
         image = [image zx_imageWithNewSize:size];
        NSString *str = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:image]];
        
        param[@"img"] = [[Utilities convertToJSONData:@[str]] base64EncodedString];
        kShowHud;
        NSLog(@"添加%@   %@",param,param[@"type"]);
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Bank/add"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self showTips:kLocat(@"k_popview_select_paywechat_edit_scuess")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.isNew) {
                        TPOTCPayWayListController *list = [TPOTCPayWayListController new];
                        list.isNew = YES;
                        kNavPush(list);
                    }else{
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[TPOTCPayWayListController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                                return ;
                            }
                        }
                    }
                });
                
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }
}
-(void)showTipsView
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 190 *kScreenHeightRatio, kScreenW - 56, 195)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
  
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 70) text:kLocat(@"k_popview_select_paywechat_edit_unbind") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 150, midView.width/2, 45) title:kLocat(@"k_popview_select_paywechat_edit_cancel") titleColor:kColorFromStr(@"#31AAD7") font:PFRegularFont(16) titleAlignment:YES];
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*   sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, 150, midView.width/2, 45) title:kLocat(@"k_popview_select_paywechat_edit_sure") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");
    [confirmlButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:kRectMake(28, 70, midView.width - 56, 50)];
    pwdTF.font = PFRegularFont(14);
    pwdTF.textColor = k323232Color;
    pwdTF.secureTextEntry = YES;
    pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    kViewBorderRadius(pwdTF, 0, 0.5, kColorFromStr(@"#E1E1E1"));
    pwdTF.leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 10, 10)];
    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    [midView addSubview:pwdTF];
    pwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"k_popview_select_paywechat_pwd_placehoder") attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"#979CAD")}];
    _deleteTF = pwdTF;
}
#pragma mark - 删除地址
-(void)deleteAction:(UIButton *)button
{
    [_deleteTF resignFirstResponder];
    
    [self hideKeyBoard];
    if (_deleteTF.text.length == 0) {
        [kKeyWindow showWarning:kLocat(@"k_popview_select_paywechat_pwd_placehoder")];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"pwd"] = [_deleteTF.text md5String];
    param[@"id"] = _model.pid;
    if (_type == TPOTCPayWayNoBankAddControllerTypeListZFB) {
        param[@"type"] = kZFB;
    }else if(_type == TPOTCPayWayNoBankAddControllerTypeListWX){
        param[@"type"] = kWechat;

    }
    NSLog(@"删除%@   ---%d",param,self.type);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Bank/delete"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [kKeyWindow showWarning:kLocat(@"k_popview_select_paywechat_edit_scuess")];
            [button.superview.superview removeFromSuperview];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[TPOTCPayWayListController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        return ;
                    }
                }
            });
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


-(void)showQRCode
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    [kKeyWindow addSubview:bgView];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    bgView.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:kRectMake(0, 0, 200, 200)];
    [bgView addSubview:imageView];
    [imageView alignVertical];
    [imageView alignHorizontal];
    [imageView setImageWithURL:_model.img.ks_URL placeholder:nil options:YYWebImageOptionProgressive completion:nil];
    imageView.userInteractionEnabled = YES;
    
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
    }]];
    
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer * sender) {
        [sender.view removeFromSuperview];
    }]];
    
}

-(NSArray *)titleArray
{
    if (_titleArray == nil) {
        if (_type == TPOTCPayWayNoBankAddControllerTypeAddWX || _type == TPOTCPayWayNoBankAddControllerTypeEditWX ) {
            _titleArray = @[kLocat(@"k_popview_list_uploadDes"),kLocat(@"k_popview_list_countname"),kLocat(@"k_popview_select_paywechat_accounter"),kLocat(@"k_popview_list_counter")];
        }else if(_type == TPOTCPayWayNoBankAddControllerTypeAddZFB || _type == TPOTCPayWayNoBankAddControllerTypeEditZFB){
            _titleArray = @[kLocat(@"k_popview_list_uploadDes"),kLocat(@"k_popview_list_countname"),kLocat(@"k_popview_list_aliycounter"),kLocat(@"k_popview_list_counter")];
        }else if (_type == TPOTCPayWayNoBankAddControllerTypeListWX){
            _titleArray = @[kLocat(@"k_popview_list_countname"),kLocat(@"k_popview_select_paywechat_rece_accoun"),@" "];
        }else if (_type == TPOTCPayWayNoBankAddControllerTypeListZFB){
            _titleArray = @[kLocat(@"k_popview_list_countname"),kLocat(@"k_popview_select_paywechat_rece_accoun"),@" "];
        }
    }
    return _titleArray;
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
