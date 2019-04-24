//
//  TPOTCPayWayBankController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPayWayBankController.h"
#import "TPOTCPayWayAddTFCell.h"
#import "TPOTCPayWayListController.h"
#import "HClActionSheet.h"
#import "BankModel.h"
#import "MOFSPickerManager.h"
@interface TPOTCPayWayBankController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *placeHoldArray;


@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *bankNameTF;
@property(nonatomic,strong)UITextField *bankAddressTF;
@property(nonatomic,strong)UITextField *numberTF;
@property(nonatomic,strong)UITextField *confirmNumTF;
@property(nonatomic,strong)UITextField *pwdTF;

@property(nonatomic,strong)UITextField *deleteTF;
@property (nonatomic, strong) HClActionSheet *selectbank;
@property (nonatomic, strong) NSMutableArray *banklist;
@property (nonatomic, strong) NSString *bankNameid;

@end

@implementation TPOTCPayWayBankController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loaddats];
    [self setupUI];
   
    if (_type == TPOTCPayWayBankControllerTypeList) {
        [self addRightBarButtonWithFirstImage:kImageFromStr(@"shoukuan_icon_bianji") action:@selector(finishAction)];
    }else{
        
        [self addNavi];
    }
    
}

- (void)loaddats{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Bank/banklist"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            self.banklist = [NSMutableArray array];
            self.banklist = [BankModel mj_objectArrayWithKeyValuesArray:[responseObj ksObjectForKey:kData]];
            NSLog(@"%@",self.banklist);
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
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
  
    self.view.backgroundColor = kColorFromStr(@"#0B132A");
    
    if (_type == TPOTCPayWayBankControllerTypeAdd) {
        self.title = kLocat(@"k_popview_select_paywechat_add_bank");
      
    }else if(_type == TPOTCPayWayBankControllerTypeEdit){
        self.title = kLocat(@"k_popview_select_paywechat_edit_bank");
      
    }else{
        self.title = kLocat(@"k_popview_select_paybank");
    }
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH ) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _tableView.backgroundColor = kColorFromStr(@"#0B132A");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPayWayAddTFCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPayWayAddTFCell"];
    
    _tableView.bounces = NO;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenW - 12 * 2., 50.) text:kLocat(@"TPOTCPayWayBankController.tips") font:[UIFont systemFontOfSize:12.] textColor:kWhiteColor textAlignment:0 adjustsFont:YES];
    tipsLabel.numberOfLines = 0;
    _tableView.tableFooterView = tipsLabel;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPOTCPayWayAddTFCell";
    TPOTCPayWayAddTFCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    
    cell.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHoldArray[indexPath.section] attributes:@{NSForegroundColorAttributeName: kColorFromStr(@"#545762")}];
    cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    cell.tf.userInteractionEnabled = indexPath.section;
    if (indexPath.section == 0) {
        cell.tf.text = kUserInfo.user_name;
        cell.tf.userInteractionEnabled = NO;
        _nameTF = cell.tf;
        
    }else if (indexPath.section == 1){
        cell.tf.userInteractionEnabled = NO;
        _bankNameTF = cell.tf;
        
        if (_model) {
            cell.tf.text = _model.bname;
            self.bankNameid = _model.bank_id;
        }
    }else if (indexPath.section == 2){
        cell.tf.userInteractionEnabled = YES;
        _bankAddressTF = cell.tf;
        if (_model) {
            cell.tf.text = _model.inname;
        }
    }else if (indexPath.section == 3){
        cell.tf.keyboardType = UIKeyboardTypeNumberPad;
        _numberTF = cell.tf;
        if (_model) {
            cell.tf.text = _model.cardnum;
        }
    }else if (indexPath.section == 4){
        cell.tf.keyboardType = UIKeyboardTypeNumberPad;
        _confirmNumTF = cell.tf;
        if (_model) {
            cell.tf.text = _model.cardnum;
        }
    }else if (indexPath.section == 5){
        cell.tf.keyboardType = UIKeyboardTypeNumberPad;
        cell.tf.secureTextEntry = YES;
        _pwdTF = cell.tf;
    }
    if (_type == TPOTCPayWayBankControllerTypeList) {
        cell.tf.userInteractionEnabled = NO;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSMutableArray *temparr = [NSMutableArray array];
        for (BankModel *model in self.banklist) {
            [temparr addObject:model.name];
        }
        self.selectbank = [[HClActionSheet alloc] initWithTitle:kLocat(@"k_popview_select_paywechat_pop_select") style:HClSheetStyleWeiChat itemTitles:temparr];
        self.selectbank.delegate = self;
        self.selectbank.tag = 50;
        self.selectbank.titleTextColor = [UIColor blackColor];
        self.selectbank.titleTextFont = [UIFont systemFontOfSize:14.0f];
        self.selectbank.itemTextFont = [UIFont systemFontOfSize:16];
        self.selectbank.itemTextColor = [UIColor grayColor];
        self.selectbank.cancleTextFont = [UIFont systemFontOfSize:16];
        self.selectbank.cancleTextColor = [UIColor grayColor];
        
        [self.selectbank didFinishSelectIndex:^(NSInteger index, NSString *title) {
            BankModel *model = [self.banklist objectAtIndex:index];
            NSLog(@"%@",model.bid);
            self.bankNameid = model.bid;
            self.bankNameTF.text = title;
        }];
    }
    
//    if (indexPath.section == 2) {
//        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultZipcode:@"450000-450900-450921" title:kLocat(@"k_popview_select_paywechat_address_select") cancelTitle:kLocat(@"k_popview_select_paywechat_edit_cancel") commitTitle:kLocat(@"k_popview_select_paywechat_edit_sure") commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
//            self.bankAddressTF.text = address;
//            NSLog(@"%@", zipcode);
////            self.zipcode = zipcode;
////            NSArray *arr = [zipcode componentsSeparatedByString:@"-"];
////            self.pid = arr[0];
////            self.cid = arr[1];
////            self.zid = arr[2];
//        } cancelBlock:^{
//
//        }];
//    }
    
}


-(void)finishAction
{
    [self hideKeyBoard];
    
    if (_type == TPOTCPayWayBankControllerTypeList) {
      
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *desAction = [UIAlertAction actionWithTitle:kLocat(@"k_popview_select_paywechat_edit_action") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            TPOTCPayWayBankController *vc = [[TPOTCPayWayBankController alloc] init];
            vc.type = TPOTCPayWayBankControllerTypeEdit;
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
    }else{
   
        if (_nameTF.text.length == 0) {
            [self showTips:self.placeHoldArray[0]];
            return;
        }
        if (_bankNameTF.text.length == 0) {
            [self showTips:self.placeHoldArray[1]];
            return;
        }
        if (_bankAddressTF.text.length == 0) {
            [self showTips:self.placeHoldArray[2]];
            return;
        }
        if (_numberTF.text.length == 0) {
            [self showTips:self.placeHoldArray[3]];
            return;
        }
        if (_confirmNumTF.text.length == 0) {
            [self showTips:self.placeHoldArray[4]];
            return;
        }
        if (_pwdTF.text.length == 0) {
            [self showTips:self.placeHoldArray[5]];
            return;
        }
        if (![_numberTF.text isEqualToString:_confirmNumTF.text]) {
            [self showTips:kLocat(@"k_popview_select_paywechat_confirm_notsame")];
            return;
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = kUserInfo.user_id;
        param[@"name"] = _nameTF.text;
        param[@"type"] = @"bank";
        param[@"inname"] = _bankAddressTF.text;
        param[@"bname"] = _bankNameid;
        if (_model) {
            param[@"id"] = _model.pid;
        }
        param[@"cardnum"] = _numberTF.text;
        param[@"pwd"] = [_pwdTF.text md5String];
        NSLog(@"%@",param);
        kShowHud;
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

-(NSArray *)titleArray
{
    if (_titleArray == nil) {
        if (_type == TPOTCPayWayBankControllerTypeList) {
            _titleArray = @[kLocat(@"k_popview_input_name"),kLocat(@"k_popview_input_bank"),kLocat(@"k_popview_input_branchbank"),kLocat(@"k_popview_input_branchbank_carnumber")];
        }else {
            _titleArray = @[kLocat(@"k_popview_input_name"),kLocat(@"k_popview_input_bank"),kLocat(@"k_popview_input_branchbank"),kLocat(@"k_popview_input_branchbank_carnumber"),kLocat(@"k_popview_input_branchbank_confirm__concarnumber"),kLocat(@"k_popview_list_counter")];
        }
    }
    return _titleArray;
}


-(NSArray *)placeHoldArray
{
    if (_placeHoldArray == nil) {
        _placeHoldArray = @[kLocat(@"k_popview_select_paywechat_name_placehoder"),kLocat(@"k_popview_select_paywechat_bankname_placehoder"),kLocat(@"k_popview_select_paywechat_kaihubankname_placehoder"),kLocat(@"k_popview_select_paywechat_kaihubankcarnumber_placehoder"),kLocat(@"k_popview_select_paywechat_2kaihubankcarnumber_placehoder"),kLocat(@"k_popview_select_paywechat_pwd_placehoder")];
    }
    
    return _placeHoldArray;
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
    param[@"type"] = kYHK;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Api/Bank/delete"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
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
@end
