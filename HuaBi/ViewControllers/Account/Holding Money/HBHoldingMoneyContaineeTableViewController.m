//
//  HBHoldingMoneyContaineeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHoldingMoneyContaineeTableViewController.h"
#import "YBPopupMenu.h"
#import "HBMoneyInterestWarpperModel.h"
#import "HBPickerViewController.h"
#import "UITableViewCell+HB.h"
#import "HBHoldingMoneyProjectDetailTableViewController.h"
#import "HMSegmentedControl+HB.h"

@interface HBHoldingMoneyContaineeTableViewController () <YBPopupMenuDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@property (weak, nonatomic) IBOutlet UILabel *advantageLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTime2Label;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

//Names
@property (weak, nonatomic) IBOutlet UILabel *advantageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *featureNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peroidNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeName2Label;
@property (weak, nonatomic) IBOutlet UILabel *endTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expectedIncomeNameLabel;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;


@property (nonatomic, strong) NSArray<NSString *> *currencyNames;
@property (nonatomic, strong) HBMoneyInterestModel *selectedModel;
@property (nonatomic, strong) NSArray<HBMoneyInterestModel *> *models;
@property (nonatomic, strong) HBMoneyInterestInfoModel *infoModel;
@property (nonatomic, strong, readwrite) HBMoneyInterestSettingModel *selectedSettingModel;

@property (nonatomic, strong) HBPickerViewController *pickerVC;

@end

@implementation HBHoldingMoneyContaineeTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kThemeBGColor;
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    
    
    self.pickerVC = [HBPickerViewController fromStoryboard];
    
    __weak typeof(self) weakSelf = self;
    self.pickerVC.didSelectModelBlock = ^(HBMoneyInterestSettingModel  *_Nonnull model) {
        weakSelf.selectedSettingModel = model;
    };
    [self _setupLabelNames];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProjectDetailVC"]) {
        HBHoldingMoneyProjectDetailTableViewController *vc = (HBHoldingMoneyProjectDetailTableViewController *)segue.destinationViewController;
        
        vc.advantage = self.infoModel.advantage;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return self.selectedModel != nil;
}

#pragma mark - Private

- (void)_setupLabelNames {
    self.advantageNameLabel.text = kLocat(@"Money Interest advantage");
    self.featureNameLabel.text = kLocat(@"Money Interest feature");
    self.startTimeNameLabel.text = kLocat(@"Money Interest Join time");
    self.peroidNameLabel.text = kLocat(@"Money Interest Management period");
    self.startTimeName2Label.text = kLocat(@"Money Interest Join time");
    self.endTimeNameLabel.text = kLocat(@"Money Interest End Time");
    self.currencyNameLabel.text = kLocat(@"Money Interest Currency");
    self.expectedIncomeNameLabel.text = kLocat(@"Money Interest Expected annualized income");
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell _addSelectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.selectedModel) {
        return;
    }
    if (indexPath.row == 3) {
        self.pickerVC.models = self.selectedModel.setting;
        [self.pickerVC show];
    }
}

#pragma mark - Actions


- (HBMoneyInterestModel *)modelAtIndex:(NSInteger)index{
    if (index < self.models.count) {
        return self.models[index];
    }
    
    return nil;
}

#pragma mark - Setters

- (void)setWarpperModel:(HBMoneyInterestWarpperModel *)warpperModel {
    _warpperModel = warpperModel;
    self.models = _warpperModel.currency_setting;
    self.infoModel = _warpperModel.info;
}

- (void)setInfoModel:(HBMoneyInterestInfoModel *)infoModel {
    _infoModel = infoModel;
    
    self.advantageLabel.text = infoModel.feature;
}

- (void)setModels:(NSArray<HBMoneyInterestModel *> *)models {
    _models = models;
    
    NSMutableArray *tmpArray = @[].mutableCopy;
    [models enumerateObjectsUsingBlock:^(HBMoneyInterestModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.currency_name) {
            [tmpArray addObject:obj.currency_name];
        }
        
    }];
    self.currencyNames = tmpArray.copy;
    self.segmentedControl.sectionTitles = self.currencyNames;
    
    
    if ([models containsObject:self.selectedModel]) {
        NSUInteger index = [models indexOfObject:self.selectedModel];
        HBMoneyInterestModel *newSelectedModel = models[index];
        self.selectedSettingModel.interestModel = newSelectedModel;
    } else {
        self.selectedModel = models.firstObject;
    }
}

- (void)setSelectedModel:(HBMoneyInterestModel *)selectedModel {
    _selectedModel = selectedModel;
    
    self.currencyLabel.text = selectedModel.currency_name;
    self.selectedSettingModel = _selectedModel.setting.firstObject;
}

- (void)setSelectedSettingModel:(HBMoneyInterestSettingModel *)selectedSettingModel {
    _selectedSettingModel = selectedSettingModel;
    
    self.startTimeLabel.text = selectedSettingModel.start_time;
    self.startTime2Label.text = selectedSettingModel.start_time;
    self.endTimeLabel.text = selectedSettingModel.end_time;
    
    self.monthsLabel.text = selectedSettingModel.name;
    self.rateLabel.text = selectedSettingModel.rateOfPrecent;
}

- (void)setSegmentedControl:(HMSegmentedControl *)segmentedControl {
    _segmentedControl = segmentedControl;
    
    _segmentedControl.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    _segmentedControl.indexChangeBlock = ^(NSInteger index) {
        weakSelf.selectedModel = [weakSelf modelAtIndex:index];
    };
    [_segmentedControl _configureStyle];
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 20);
}

@end
