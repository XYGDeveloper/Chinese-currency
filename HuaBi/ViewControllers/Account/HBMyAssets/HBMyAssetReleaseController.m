//
//  HBMyAssetReleaseController.m
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetReleaseController.h"
#import "HBMyAssetReleaseRecordController.h"

@interface HBMyAssetReleaseController ()

@property (weak, nonatomic) IBOutlet UILabel *tips1Label;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *lockLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulerLabel;

@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property(nonatomic,assign)BOOL isReleased;

@property(nonatomic,assign)double rate;


@end

@implementation HBMyAssetReleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkIfReleaseToday];
    
    [self setupUI];
}

-(void)setupUI
{
    self.title = self.isPresentation ? kLocat(@"Assert_detail_presetation_release") : kLocat(@"Assert_detail_release");
    
    _tips1Label.textColor = kColorFromStr(@"#DEE5FF");
    _tips1Label.font = PFRegularFont(18);
    
    _nameLabel.textColor = kColorFromStr(@"DEE5FF");
    _nameLabel.font = PFRegularFont(14);
    
    _lockLabel.textColor = kColorFromStr(@"DEE5FF");
    _lockLabel.font = PFRegularFont(14);
    
    _releaseLabel.textColor = kColorFromStr(@"DEE5FF");
    _releaseLabel.font = PFRegularFont(14);
    
    _rulerLabel.textColor = kColorFromStr(@"DEE5FF");
    _rulerLabel.font = PFRegularFont(14);
    _rulerLabel.numberOfLines = 0;
    
    _tipsLabel.textColor = kColorFromStr(@"7582A4");
    _tipsLabel.font = PFRegularFont(12);
    _tipsLabel.hidden = YES;
    
    [_actionButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#CCCCCC")] forState:UIControlStateDisabled];
    [_actionButton setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateDisabled];
    
    [_actionButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#4173C8")] forState:UIControlStateNormal];
    [_actionButton setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateNormal];
     
     
    
    [_actionButton setTitle:kLocat(@"Assert_detail_release_action_button_title")                                                 forState:UIControlStateNormal];
    _actionButton.enabled = YES;
    
    [_actionButton addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    _rulerLabel.text = kLocat(@"Assert_detail_releaserule");
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"Assert_detail_releaserecord") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = PFRegularFont(16);
    [rightbBarButton addTarget:self action:@selector(recordListAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    rightbBarButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
    _tips1Label.text = kLocat(@"Assert_detail_releaseaction");
    _nameLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"Assert_detail_currencyname"),_currencyName];
    
    _releaseLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"Assert_detail_releaseVolume"),@"0"];
    _rulerLabel.text = kLocat(@"Assert_detail_releaserule");
    
    NSString *numberString = self.isPresentation ? kLocat(@"Assert_detail_presetation_balance") : kLocat(@"Assert_detail_lockvolume");
    NSString *num = self.isPresentation ? _dataDic[@"num_award"] : _dataDic[@"lock_num"];
    _lockLabel.text = [NSString stringWithFormat:@"%@:%@",numberString,num];;

    _tipsLabel.text = kLocat(@"Assert_detail_releasetips");
    _tipsLabel.hidden = YES;

}

#pragma mark - 点击事件

-(void)recordListAction
{
    HBMyAssetReleaseRecordController *vc = [HBMyAssetReleaseRecordController new];
    vc.currencyID = _currencyID;
    vc.isPresentation = self.isPresentation;
    
    kNavPush(vc);
}
//检查今日是否释放
-(void)checkIfReleaseToday
{
    kShowHud;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _currencyID;
    
    NSString *api = self.isPresentation ? @"/Api/AccountManage/isReceive_award" : @"/AccountManage/isReceive";
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:api] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            //1为已领取，2为未领取
            NSInteger result = [[responseObj ksObjectForKey:kData][@"isReceive"] integerValue];
            _rate = [[responseObj ksObjectForKey:kData][@"rate"] floatValue];
            NSString *key = self.isPresentation ? @"num_award" : @"lock_num";
            double releaseVol = [_dataDic[key] doubleValue] * _rate / 100.;
            
            _releaseLabel.text = [NSString stringWithFormat:@"%@:%6f",kLocat(@"Assert_detail_releaseVolume"),releaseVol];
            
//            if ([_rulerLabel.text containsString:@"3‰"]) {
//              _rulerLabel.text = [_rulerLabel.text stringByReplacingOccurrencesOfString:@"3‰" withString:[NSString stringWithFormat:@"%@%%",[responseObj ksObjectForKey:kData][@"rate"]]];
//            }
            
            if ([_rulerLabel.text containsString:@"0.001"]) {
                _rulerLabel.text = [_rulerLabel.text stringByReplacingOccurrencesOfString:@"0.001" withString:[NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kData][@"limit"]]];
            }
            
            
            
            if (result == 1) {
                _actionButton.enabled = NO;
                _tipsLabel.hidden = NO;
            }else{
                _actionButton.enabled = YES;
                _tipsLabel.hidden = YES;
            }
        }
    }];
}
-(void)releaseAction
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _currencyID;
    kShowHud;
    NSString *api = self.isPresentation ? @"/Api/AccountManage/everydayFreed_award" : @"/AccountManage/everydayFreed";
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:api] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
    
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            _actionButton.enabled = NO;
            _tipsLabel.hidden = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kHBMyAssetExchangeControllerUserDidExchangeSuccessKey" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                HBMyAssetReleaseRecordController *vc = [HBMyAssetReleaseRecordController new];
                vc.currencyID = _currencyID;
                vc.fromSuccess = YES;
                vc.isPresentation = self.isPresentation;
                kNavPush(vc);
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }

    }];
}





@end
