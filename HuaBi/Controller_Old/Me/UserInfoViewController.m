//
//  UserInfoViewController.m
//  YJOTC
//
//  Created by l on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserTableViewCell.h"
#import "UserProfile.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)UserProfile *model;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BQActivityView showActiviTy];
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
    param[@"uuid"] = [Utilities randomUUID];
    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    param[@"token"] = kUserInfo.token;
    NSLog(@"------------%@",param);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:memberinfo] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [BQActivityView hideActiviTy];
        [self showTips:[responseObj ksObjectForKey:kMessage]];
        if (success) {
            self.model = [UserProfile mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            [self.tableview reloadData];
            kLOG(@"%@",[responseObj ksObjectForKey:kData]);
        }
    }];
    self.navigationItem.title = kLocat(@"k_userinfoViewcontroler_title");
    [self.tableview registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserTableViewCell class])];
    self.view.backgroundColor = kColorFromStr(@"#FFF4F4F4");
    self.tableview.separatorColor = kColorFromStr(@"#FFFFFF");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.itemLabel.text = kLocat(@"k_meViewcontroler_name");
            if (!self.model.user_name || self.model.user_name.length <= 0) {
                cell.infoLabel.text = @"暂未设置";
            }else{
                cell.infoLabel.text = self.model.user_name;
            }
        }else if (indexPath.row == 1){
            cell.itemLabel.text = kLocat(@"k_userinfoViewcontroler_email");
            if (!self.model.email) {
                cell.infoLabel.text = @"暂未设置";
            }else{
                cell.infoLabel.text = self.model.email;
            }
        }else{
            cell.itemLabel.text = kLocat(@"k_userinfoViewcontroler_phone");
            if (!self.model.user_account) {
                cell.infoLabel.text = @"暂未设置";
            }else{
            cell.infoLabel.text = self.model.user_account;
            }
        }

    }else{
        
        if (indexPath.row == 0) {
            cell.itemLabel.text = kLocat(@"k_userinfoViewcontroler_type");
            if (!self.model.cardtype) {
                cell.infoLabel.text = @"暂未设置";
            }else{
                cell.infoLabel.text = self.model.cardtype;
            }
        }else if (indexPath.row == 1){
            cell.itemLabel.text = kLocat(@"k_userinfoViewcontroler_number");
            if (!self.model.idcard) {
                cell.infoLabel.text = @"暂未设置";
            }else{
                cell.infoLabel.text = self.model.idcard;
            }
        }else{
            cell.itemLabel.text = kLocat(@"k_userinfoViewcontroler_time");
            if (!self.model.reg_time_m) {
                cell.infoLabel.text = @"暂未设置";
            }else{
                cell.infoLabel.text = self.model.reg_time_m;
            }
        }
    }
    
    return cell;
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
        return 10;
    }else{
        return 10;
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


@end
