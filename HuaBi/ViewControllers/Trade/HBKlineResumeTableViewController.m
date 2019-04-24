//
//  HBKlineResumeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBKlineResumeTableViewController.h"
#import "HBIconInfoModel.h"
#import "NSObject+SVProgressHUD.h"
#import <SafariServices/SFSafariViewController.h>

@interface HBKlineResumeTableViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCirculationLabel;
@property (weak, nonatomic) IBOutlet UILabel *trunoverLabel;
@property (weak, nonatomic) IBOutlet UILabel *raisePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *whitePaperLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockQueryLabel;
@property (weak, nonatomic) IBOutlet UILabel *featureLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCirculationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *trunoverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raisePriceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *whitePaperNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockQueryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (nonatomic, assign) CGFloat introCellHeight;

@end

@implementation HBKlineResumeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];

    self.timeNameLabel.text = kLocat(@"Issue date");
    self.totalCirculationNameLabel.text = kLocat(@"Total circulation");
    self.trunoverNameLabel.text = kLocat(@"Total turnover");
    self.raisePriceNameLabel.text = kLocat(@"Raise price");
    self.whitePaperNameLabel.text = kLocat(@"White paper");
    self.websiteNameLabel.text = kLocat(@"Website");
    self.blockQueryNameLabel.text = kLocat(@"Block query");
    self.introduceLabel.text = kLocat(@"Intro");
    [self _updateUI];
}

- (void)_updateUI {
    self.nameLabel.text = self.iconInfoModel.english_short ?: @"--";
    self.timeLabel.text = self.iconInfoModel.release_date ?: @"--";
    self.totalCirculationLabel.text = self.iconInfoModel.total_circulation ?: @"--";
    self.trunoverLabel.text = self.iconInfoModel.daibi_turnover ?: @"--";
    self.raisePriceLabel.text = self.iconInfoModel.raise_price ?: @"--";
    self.whitePaperLabel.text = self.iconInfoModel.white_paper ?: @"--";
    self.blockQueryLabel.text = self.iconInfoModel.block_query ?: @"--";
    self.websiteLabel.text = self.iconInfoModel.website ?: @"--";
    self.featureLabel.attributedText = [self _featureAttributedString];
}

- (NSAttributedString *)_featureAttributedString {
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.iconInfoModel.feature ?: @""];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.iconInfoModel.feature length])];
    
    return attributedString1;
}



- (void)setIconInfoModel:(HBIconInfoModel *)iconInfoModel {
    _iconInfoModel = iconInfoModel;
    
    [self _updateUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 9) {
        return self.introCellHeight;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string;  
    switch (indexPath.row) {
        case 5:
            string = self.iconInfoModel.white_paper;
            break;
        case 6:
            string = self.iconInfoModel.website;
            break;
        case 7:
            string = self.iconInfoModel.block_query;
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


- (CGFloat)getHeight {
    
    return 51 + 8 * 46 + self.introCellHeight;
}
- (CGFloat)introCellHeight {
    if (_introCellHeight == 0) {
        [self.featureLabel sizeToFit];
        _introCellHeight = self.featureLabel.frame.size.height + 24;
    }
    return _introCellHeight;
}

@end
