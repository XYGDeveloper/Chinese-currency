//
//  AddCardViewController.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AddCardViewController.h"
#import "selectTableViewCell.h"
#import "HClActionSheet.h"
#import "BankModel.h"
#import "MOFSPickerManager.h"

@interface AddCardViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)selectTableViewCell *name;
@property (nonatomic,strong)selectTableViewCell *bankName;
@property (nonatomic,strong)selectTableViewCell *address;
@property (nonatomic,strong)selectTableViewCell *branchBank;
@property (nonatomic,strong)selectTableViewCell *bankNumber;
@property (nonatomic,strong)selectTableViewCell *conbankNumber;
@property (nonatomic, strong) HClActionSheet *selectbank;
@property (nonatomic, strong) NSString *bankNameid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *zid;
@property (nonatomic, strong) NSString *zipcode;

@property (nonatomic, strong) NSMutableArray *banklist;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation AddCardViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRGBA(244, 244, 244, 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (selectTableViewCell *)name {
    if (!_name) {
        _name = [[selectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:kLocat(@"k_bank_popview_list_countname") placeholder:kLocat(@"k_bank_popview_list_countname_place")];
        _name.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _name;
}

- (selectTableViewCell *)bankName {
    if (!_bankName) {
        _bankName = [[selectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_bankName setTypeName:kLocat(@"k_bank_popview_list_countname_kaihu") placeholder:kLocat(@"k_bank_popview_list_countname_kaihu_place")];
        _bankName.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _bankName.selectionStyle = UITableViewCellSelectionStyleNone;
        _bankName.textField.userInteractionEnabled = YES;
        [_bankName setEditAble:NO];
    }
    return _bankName;
}

- (selectTableViewCell *)address {
    if (!_address) {
        _address = [[selectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_address setTypeName:kLocat(@"k_bank_popview_list_szd") placeholder:@""];
        _address.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _address.selectionStyle = UITableViewCellSelectionStyleNone;
        _address.textField.userInteractionEnabled = YES;
        [_address setEditAble:NO];
    }
    return _address;
}

- (selectTableViewCell *)branchBank {
    if (!_branchBank) {
        _branchBank = [[selectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_branchBank setTypeName:kLocat(@"k_bank_popview_list_khzh") placeholder:@""];
        _branchBank.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _branchBank;
}

- (selectTableViewCell *)bankNumber {
    if (!_bankNumber) {
        _bankNumber = [[selectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_bankNumber setTypeName:kLocat(@"k_bank_popview_list_yhk") placeholder:@""];
        _bankNumber.selectionStyle = UITableViewCellSelectionStyleNone;
        _bankNumber.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _bankNumber;
}

- (selectTableViewCell *)conbankNumber {
    if (!_conbankNumber) {
        _conbankNumber = [[selectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_conbankNumber setTypeName:kLocat(@"k_bank_popview_list_countname_repeat") placeholder:@""];
        _conbankNumber.selectionStyle = UITableViewCellSelectionStyleNone;
        _conbankNumber.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return _conbankNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaddats];
    self.list = @[self.name,self.bankName,self.address,self.branchBank,self.bankNumber,self.conbankNumber];
    [self.view addSubview:self.tableView];
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenH, 60)];
    self.headerView.backgroundColor = [UIColor clearColor];
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.backgroundColor = kColorFromStr(@"#896FED");
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(20, 20, kScreenW - 40, 40);
    [commitButton setTitle:kLocat(@"k_popview_list_sureto_add") forState:UIControlStateNormal];
    [self.headerView addSubview:commitButton];
    commitButton.layer.cornerRadius = 8;
    commitButton.layer.masksToBounds = YES;
    [commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.headerView;
    
    // Do any additional setup after loading the view from its nib.
}


- (void)loaddats{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/getBankList"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
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

- (void)commit:(UIButton *)sender{
    
    if (self.name.text.length <= 0) {
        [self showTips:kLocat(@"k_bank_add_01")];
        return;
    }
    if (self.bankNameid.length <= 0) {
        [self showTips:kLocat(@"k_bank_add_02")];
        return;
    }
    if (self.zipcode.length <= 0) {
        [self showTips:kLocat(@"k_bank_add_03")];
        return;
    }
    if (self.branchBank.text.length <= 0) {
        [self showTips:kLocat(@"k_bank_add_04")];
        return;
    }
    if (self.bankNumber.text.length <= 0) {
        [self showTips:kLocat(@"k_bank_add_05")];
        return;
    }
    if (self.conbankNumber.text.length <= 0) {
        [self showTips:kLocat(@"k_bank_add_06")];
        return;
    }
    
    if (![self.bankNumber.text isEqualToString:self.conbankNumber.text]) {
        [self showTips:kLocat(@"k_c2c_input_equal")];
        return;
    }
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"key"] = kUserInfo.token;
    param[@"truename"] = self.name.text;
    param[@"bankname"] = self.bankNameid;
    param[@"province_id"] = self.pid;
    param[@"city_id"] = self.cid;
    param[@"county"] = self.zid;
    param[@"bankadd"] = self.branchBank.text;
    param[@"bankcard"] = self.bankNumber.text;
    param[@"rbankcard"] = self.conbankNumber.text;
    param[@"type"] = @"1";
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/addPayment"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            kHideHud;
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.list objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        NSMutableArray *temparr = [NSMutableArray array];
        for (BankModel *model in self.banklist) {
            [temparr addObject:model.name];
        }
        self.selectbank = [[HClActionSheet alloc] initWithTitle:@"请选择银行" style:HClSheetStyleWeiChat itemTitles:temparr];
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
            self.bankName.text = title;
        }];
    }else if(indexPath.row == 2){
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultZipcode:@"450000-450900-450921" title:@"选择地址" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
            self.address.text = address;
            NSLog(@"%@", zipcode);
            self.zipcode = zipcode;
            NSArray *arr = [zipcode componentsSeparatedByString:@"-"];
            self.pid = arr[0];
            self.cid = arr[1];
            self.zid = arr[2];
        } cancelBlock:^{
            
        }];
    }
}


@end
