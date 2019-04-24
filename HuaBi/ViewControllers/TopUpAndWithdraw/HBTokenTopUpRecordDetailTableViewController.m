//
//  HBTokenTopUpRecordDetailTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/19.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBTokenTopUpRecordDetailTableViewController.h"
#import "HBChongCurrencyRecorModel.h"
@interface HBTokenTopUpRecordDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *txlLabel;
@property (weak, nonatomic) IBOutlet UILabel *txlContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeContentLabel;

@end

@implementation HBTokenTopUpRecordDetailTableViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"HBTokenTopUpRecordDetailTableViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"HBTokenTopUpRecordDetailTableViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"HBTokenWithdrawViewController_token_detail");
    self.typeLabel.text = kLocat(@"HBTokenWithdrawViewController_token_type");
    self.numberLabel.text = kLocat(@"HBTokenWithdrawViewController_token_number");
    self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_sstatus");
    self.addressLabel.text = kLocat(@"HBTokenWithdrawViewController_token_address");
    self.txlLabel.text = kLocat(@"HBTokenWithdrawViewController_token_txid");
    self.timeLabel.text = kLocat(@"HBTokenWithdrawViewController_token_time");
    if ([self.type isEqualToString:@"0"]) {
        self.typeLabel.text = kLocat(@"k_ExchangeRecordViewController_topbar_1");
    }else{
        self.typeLabel.text = kLocat(@"k_ExchangeRecordViewController_topbar_2");
    }
    self.numberContentLabel.text = self.model.num;
    if ([self.model.status isEqualToString:@"-1"]) {
        self.statusContentLabel.text = kLocat(@"HBTokenWithdrawViewController_token_reve");
    }else if ([self.model.status isEqualToString:@"-2"]){
        self.statusContentLabel.text = kLocat(@"HBTokenWithdrawViewController_token_resolve");
    }else if ([self.model.status isEqualToString:@"3"]){
        self.statusContentLabel.text = kLocat(@"HBTokenWithdrawViewController_token_chongbi");
    }else{
        self.statusContentLabel.text = kLocat(@"HBTokenWithdrawViewController_token_scuess");
    }
    self.addressContentLabel.text = self.model.url;
    self.txlContentLabel.text = self.model.ti_id;
    self.timeContentLabel.text = self.model.add_time;
    
}

@end
