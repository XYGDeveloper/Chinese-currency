//
//  HBCommonQuestionViewController.m
//  HuaBi
//
//  Created by l on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCommonQuestionViewController.h"
#import "YTDetailModel.h"
#import "HBQdetailViewController.h"

@interface HBCommonQuestionViewController ()
@property (nonatomic,strong)YTDetailModel *model;
@property (nonatomic,strong)NSArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation HBCommonQuestionViewController

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
    param[@"judge"] = @(self.judge);
    param[@"page"] = @"1";
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/art/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        kHideHud;
        if (success) {
            self.list = [YTDetailModel mj_objectArrayWithKeyValuesArray:[responseObj ksObjectForKey:kData]];
            [self.tableview reloadData];
            //            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    self.tableview.backgroundColor = kRGBA(24, 30, 50, 1);
    self.tableview.separatorColor = kRGBA(24, 30, 50, 1);
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.backgroundColor = kColorFromStr(@"#0B132A");
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = kColorFromStr(@"DEE5FF");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    YTDetailModel *model = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTDetailModel *model = [self.list objectAtIndex:indexPath.row];
    HBQdetailViewController *detail  = [HBQdetailViewController new];
    detail.title = self.title;
    detail.qid = model.article_id;
    kNavPush(detail);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
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



@end
