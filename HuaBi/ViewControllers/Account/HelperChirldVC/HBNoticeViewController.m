//
//  HBNoticeViewController.m
//  HuaBi
//
//  Created by l on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBNoticeViewController.h"
#import "YTDetailModel.h"
#import "HBNoticeTableViewCell.h"
#import "HBQdetailViewController.h"
@interface HBNoticeViewController ()
@property (nonatomic,strong)NSArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation HBNoticeViewController

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
    param[@"judge"] = @"1";
    param[@"page"] = @"1";
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/art/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        kHideHud;
        if (success) {
            self.list = [YTDetailModel mj_objectArrayWithKeyValuesArray:[responseObj ksObjectForKey:kData]];
            [self.tableview reloadData];
            NSLog(@"%@",self.list);
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = kLocat(@"k_HBHelpCenteriewController_notice");
    [self loadData];
    [self.tableview registerNib:[UINib nibWithNibName:@"HBNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HBNoticeTableViewCell class])];
    self.tableview.separatorColor = kRGBA(24, 30, 50, 1);
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HBNoticeTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YTDetailModel *model = [self.list objectAtIndex:indexPath.row];
    [cell refreshWithMOdel:model];
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTDetailModel *model = [self.list objectAtIndex:indexPath.row];
    HBQdetailViewController *detail  = [HBQdetailViewController new];
    detail.title = self.title;
    detail.qid = model.article_id;
    kNavPush(detail);
}





@end
