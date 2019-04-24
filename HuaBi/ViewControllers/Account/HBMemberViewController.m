//
//  HBMemberViewController.m
//  HuaBi
//
//  Created by l on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMemberViewController.h"
#import "UserProfile.h"
#import "MemberHeaderTableViewCell.h"
#import "HBMeberTableViewCell.h"
#import "HBBaseMemberTableViewCell.h"
#import "NSObject+SVProgressHUD.h"

@interface HBMemberViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)UserProfile *profile;
@property (nonatomic,strong)MemberHeaderTableViewCell *header;
@property (nonatomic,strong)UIButton *loginOutBtn;

@end

@implementation HBMemberViewController

- (void)loadData{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        lang = KoreanLanage;
    }else if ([currentLanguage containsString:Japanese]){//繁体
        lang = Japanese;
    }else{//泰文
        lang = ThAI;
    }
    param[@"language"] = lang;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"key"] = kUserInfo.token;
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/memberinfo"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        kHideHud;
        if (success) {
            self.profile = [UserProfile mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            kUserInfo.nick = self.profile.nick;
            [kUserInfo saveUserInfo];
            [self.header.avater setImageWithURL:[NSURL URLWithString:self.profile.user_head] placeholder:[UIImage imageNamed:@""]];
            [self.tableview reloadData];
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"HBMemberViewController_info");
       [self.tableview registerNib:[UINib nibWithNibName:@"HBMeberTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HBMeberTableViewCell class])];
    self.tableview.separatorColor = kRGBA(24, 30, 50, 1);
     [self.tableview registerNib:[UINib nibWithNibName:@"HBBaseMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"name"];
    MemberHeaderTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"MemberHeaderTableViewCell" owner:nil options:nil] lastObject];
    head.userInteractionEnabled = YES;
    self.header = head;
    self.header.baseInfoLabl.text = kLocat(@"HBMemberViewController_info");
    self.tableview.tableHeaderView = self.header;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
    footView.backgroundColor = [UIColor clearColor];
    self.loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:self.loginOutBtn];
    [self.loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
        make.centerY.mas_equalTo(footView.mas_centerY);
    }];
    [self.loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginOutBtn.backgroundColor = kColorFromStr(@"#4173C8");
    self.loginOutBtn.layer.cornerRadius = 23;
    self.loginOutBtn.layer.masksToBounds = YES;
    [self.loginOutBtn setTitle:kLocat(@"HBMemberViewController_loginOut") forState:UIControlStateNormal];
    [self.loginOutBtn addTarget:self action:@selector(loginOutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableview.tableFooterView = footView;
    // Do any additional setup after loading the view from its nib.
}

- (void)loginOutAction:(UIButton *)sender{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = kUserInfo.user_id;
    param[@"key"] = kUserInfo.token;
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/logout"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        kHideHud;
        if (success) {
            [kUserInfo clearUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutScuess" object:nil];
              kNavPop;
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HBMeberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HBMeberTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.authLabel.text = kLocat(@"HBMemberViewController_authdes");
      
//        verify_state -1未认证 0未通过 1:已认证 2: 审核中
        if ([self.profile.verify_state isEqualToString:@"-1"]) {
            cell.authState.text = kLocat(@"HBMemberViewController_authstat0");
        }else if ([self.profile.verify_state isEqualToString:@"0"]){
            cell.authState.text = kLocat(@"HBMemberViewController_authstat1");
        }else if([self.profile.verify_state isEqualToString:@"1"]){
             cell.authState.text = kLocat(@"HBMemberViewController_authstat2");
            cell.authFlage.image = [UIImage imageNamed:@"authed"];
        }else{
            cell.authState.text = kLocat(@"HBMemberViewController_authstat3");
            cell.authFlage.image = [UIImage imageNamed:@""];
        }
        return cell;
    } else {
        HBBaseMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
        if (indexPath.row == 1){
    
            cell.itemLabel.text = kLocat(@"HBMemberViewController_nickname");
        
            if (self.profile.nick.length <= 0) {
                cell.contentLabel.text = kLocat(@"HBMemberViewController_setting");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.contentLabel.textColor = kColorFromStr(@"#4173C8");
                cell.contentTrailingConstraint.constant = 0;
            }else{
                cell.contentLabel.text = self.profile.nick;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.contentLabel.textColor = kColorFromStr(@"#DEE5FF");
                cell.contentTrailingConstraint.constant = 15;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 2){
            cell.itemLabel.text = kLocat(@"HBMemberViewController_name");
            if (self.profile.name.length <= 0) {
                cell.contentLabel.text = kLocat(@"k_contactViewController_empty");
            }else{
                cell.contentLabel.text = self.profile.name;
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 3){
            cell.itemLabel.text = kLocat(@"HBMemberViewController_acctounter");
            if (kUserInfo.phone) {
                cell.contentLabel.text = kUserInfo.seurityEmailOrPhone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 4){
            
            cell.itemLabel.text = @"ID";
            if (kUserInfo.user_id) {
                cell.contentLabel.text = kUserInfo.user_id;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 5){
            
            cell.itemLabel.text = kLocat(@"HBMemberViewController_country");
            if (self.profile.country) {
                cell.contentLabel.text = self.profile.country;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 6){
            
            cell.itemLabel.text = kLocat(@"HBMemberViewController_carid");
            if (self.profile.idcard) {
                cell.contentLabel.text = self.profile.idcard;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            
            cell.itemLabel.text = kLocat(@"HBMemberViewController_time");
            cell.contentLabel.text =self.profile.verify_time;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if (self.profile && (self.profile.nick.length == 0)) {
            [self _alertNicknameTextField];
        }
    }
}

#pragma mark - Alert

- (void)_alertNicknameTextField {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocat(@"HBMemberViewController_set_nickname") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *nickName = alertController.textFields.firstObject.text;
        [self modifyNick:nickName];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)modifyNick:(NSString *)nick {
    if (!nick) {
        return;
    }
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/Account/modifynick" parameters:@{@"nick" : nick ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {

        kHideHud;
        if ([model succeeded]) {
            [self showSuccessWithMessage:model.message];
            self.profile.nick = nick;
            kUserInfo.nick = self.profile.nick;
            [kUserInfo saveUserInfo];
            [self.tableview reloadData];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

@end
