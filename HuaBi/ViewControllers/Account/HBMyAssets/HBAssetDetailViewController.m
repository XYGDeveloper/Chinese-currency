//
//  HBAssetDetailViewController.m
//  HuaBi
//
//  Created by l on 2018/11/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBAssetDetailViewController.h"
#import "FinModel.h"
@interface HBAssetDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;        //变动类型
@property (weak, nonatomic) IBOutlet UILabel *desLabel;         //描述
@property (weak, nonatomic) IBOutlet UILabel *countLabel;       //变动数量
@property (weak, nonatomic) IBOutlet UILabel *szTypeLabel;      //收入支出类型
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;      //状态
@property (weak, nonatomic) IBOutlet UILabel *tradeTimeLabel;   //成交时间
@property (weak, nonatomic) IBOutlet UILabel *typeConent;
@property (weak, nonatomic) IBOutlet UILabel *desContent;
@property (weak, nonatomic) IBOutlet UILabel *countContent;
@property (weak, nonatomic) IBOutlet UILabel *typeContent;
@property (weak, nonatomic) IBOutlet UILabel *statusContent;
@property (weak, nonatomic) IBOutlet UILabel *timeContent;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@end

@implementation HBAssetDetailViewController

+ (instancetype)fromStoryboard {
    return [UIStoryboard storyboardWithName:@"MyAssetsDetail" bundle:nil].instantiateInitialViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshWithModel];
    self.title = kLocat(@"k_FinsetViewController_title");
    self.tableView.backgroundColor = kThemeBGColor;
    self.view.backgroundColor = kThemeBGColor;
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
}

- (void)refreshWithModel{
    self.typeLabel.text = kLocat(@"k_FinsetViewController_type2");
    self.desLabel.text = kLocat(@"k_FinsetViewController_type2_1");
    self.countLabel.text = kLocat(@"k_FinsetViewController_type2_2");
    self.szTypeLabel.text = kLocat(@"k_FinsetViewController_type2_3");
    self.statusLabel.text = kLocat(@"k_FinsetViewController_type2_4");
    self.tradeTimeLabel.text = kLocat(@"k_FinsetViewController_type2_5");
    if ([self.model.operation intValue] == IncomeAndExpenditureTypeIncome) {
        self.typeContent.textColor  =kColorFromStr(@"#03C086");
        self.typeContent.text = kLocat(@"k_FinsetViewController_type6");
    }else{
        self.typeContent.textColor  =kColorFromStr(@"#E96E44");
        self.typeContent.text = kLocat(@"k_FinsetViewController_type7");
    }
    self.desContent.text = self.model.remark_text;
    self.countContent.text = self.model.amount;
    self.typeConent.text = self.model.type_text;
    self.statusContent.text = kLocat(@"OTC_order_done");
    self.timeContent.text = [Utilities timestampSwitchTime:[self.model.create_time integerValue] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
