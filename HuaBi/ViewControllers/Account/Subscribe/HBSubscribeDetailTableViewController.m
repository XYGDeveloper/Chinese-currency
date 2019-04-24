//
//  HBSubscribeDetailTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeDetailTableViewController.h"
#import "UITableViewCell+HB.h"
#import "HBSubscribeModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"
#import "NSDate+Utilities.h"
#import <SafariServices/SFSafariViewController.h>
#import "HBDateProgressView.h"

@interface HBSubscribeDetailTableViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSourc;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *webSiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *whitePagerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet HBDateProgressView *dateProgressView;


//Names
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLowNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodOfSubscribeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DetailNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *whitepapgerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNameLabel;

@end

@implementation HBSubscribeDetailTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = kThemeBGColor;
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    [self _setupLabelNames];
    [self _updateUI];
}

#pragma mark - Private

- (void)_setupLabelNames {
    self.priceNameLabel.text = kLocat(@"Subscription price");
    self.numberOfLowNameLabel.text = kLocat(@"Minimum quantity");
    self.goalNameLabel.text = kLocat(@"Subscription Goal");
    self.progressNameLabel.text = kLocat(@"Subscription Progress");
    self.numberOfPeopleNameLabel.text = kLocat(@"Subscription Number of people");
    self.periodOfSubscribeNameLabel.text = kLocat(@"Subscription detail period");
    self.startTimeNameLabel.text = kLocat(@"Subscription detail start time");
    self.endTimeNameLabel.text = kLocat(@"Subscription detail end time");
    self.DetailNameLabel.text = kLocat(@"Subscription detail Project Introduction");
    self.infoNameLabel.text = kLocat(@"Subscription detail Info");
    self.websiteNameLabel.text = kLocat(@"Subscription detail website");
    self.whitepapgerNameLabel.text = kLocat(@"Subscription detail whitepapger");
    self.releaseTimeNameLabel.text = kLocat(@"Subscription detail release time");
    self.totalNameLabel.text = kLocat(@"Subscription detail total");
}

- (void)_updateUI {
    [self.iconImageView setImageURL:[NSURL URLWithString:self.model.logo]];
    self.projectTitleLabel.text = self.model.title;
    self.priceLabel.text = self.model.priceAndCurrency;
    self.numberOfLowLabel.text = self.model.min_limit;
    self.goalLabel.text = self.model.num;
    self.progressLabel.text = self.model.blAndPrecent;
    self.numberOfPeopleLabel.text = self.model.peoples;
//    self.infoLabel.text = self.model.info;
    self.infoLabel.attributedText = [self.model.info attributedStringWithParagraphSize:8];
    self.webSiteLabel.text = self.model.website;
    self.whitePagerLabel.text = self.model.white_paper;
    
    NSTimeInterval addTimeInterval = [self.model.add_time integerValue];
    NSTimeInterval endTimeInterval = [self.model.end_time integerValue];
    self.dateLabel.text = [Utilities timestampSwitchTime:addTimeInterval andFormatter:@"yyyy-MM-dd"];
    self.totalLabel.text = self.model.num;
    self.addTimeLabel.text = [Utilities timestampSwitchTime:addTimeInterval andFormatter:@"yyyy/MM/dd"];
    self.endTimeLabel.text = [Utilities timestampSwitchTime:endTimeInterval andFormatter:@"yyyy/MM/dd"];
    
    NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:addTimeInterval];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTimeInterval];
    NSDate *today = [NSDate date];
    
    NSInteger totalDays = [addDate daysBeforeDate:endDate];
    NSInteger currentDays = [addDate daysBeforeDate:today];
    CGFloat progress = 0;
    if (totalDays != 0) {
        totalDays += 1;
        currentDays += 1;
        progress = (CGFloat)currentDays / (CGFloat)totalDays;
    }
    self.dateProgressView.progress = progress;
}


#pragma mark - UITableViewDataSource & Delegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell _addSelectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *string;
    switch (indexPath.row) {
        case 8:
            string = self.model.white_paper;
            break;
        case 7:
            string = self.model.website;
            break;
    }
    
    if (string) {
        if ([[string lowercaseString] hasPrefix:@"http"]) {
            UIViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:string]];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = string;
            
            [self showSuccessWithMessage:kLocat(@"Copied")];
        }
    }
    
}

#pragma mark - Setters

- (void)setModel:(HBSubscribeModel *)model {
    _model = model;
//    [self _requestSubscribeDetail];
    
    [self _updateUI];
    [self.tableView reloadData];
}

@end
