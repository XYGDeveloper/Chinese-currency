//
//  HBRecorderDetailViewController.m
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBRecorderDetailViewController.h"
#import "HBChongCurrencyRecorModel.h"
@interface HBRecorderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *item1;
@property (weak, nonatomic) IBOutlet UILabel *typenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *item2;
@property (weak, nonatomic) IBOutlet UILabel *numNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *item3;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *item4;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *item5;
@property (weak, nonatomic) IBOutlet UILabel *shouxuNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouxuLabel;
@property (weak, nonatomic) IBOutlet UIView *item6;
@property (weak, nonatomic) IBOutlet UILabel *teidNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teidLabel;
@property (weak, nonatomic) IBOutlet UIView *item7;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *canBtn;

@end

@implementation HBRecorderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canBtn.hidden = YES;
    [self.canBtn setTitle:kLocat(@"net_alert_load_message_cancel") forState:UIControlStateNormal];
    self.title = kLocat(@"HBTokenWithdrawViewController_token_detail");
    if ([self.type isEqualToString:@"1"]) {
        self.typeLabel.text = kLocat(@"k_ExchangeRecordViewController_topbar_2");
        if ([self.model.status isEqualToString:@"3"]) {
            self.typenameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_type");
            self.numNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_number");
            self.statusNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_sstatus");
            self.addressNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_address");
            self.shouxuNameLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_shouxu");
            self.teidNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_txid");
            self.timeNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_time");
            self.numberLabel.text = [NSString stringWithFormat:@"-%@%@",self.model.num,self.model.currency_mark];
            self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_chongbi");
            self.addressLabel.text = self.model.url;
            self.teidLabel.text = self.model.ti_id;
            self.shouxuLabel.text = self.model.fee;
            self.timeLabel.text = self.model.add_time;
        }else if ([self.model.status isEqualToString:@"-1"]){
            self.typenameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_type");
            self.numNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_number");
            self.statusLabel.textColor = kColorFromStr(@"#4173C8");
            self.statusNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_sstatus");
            self.addressNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_address");
            self.shouxuNameLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_shouxu");
            self.teidNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_time");
            self.numberLabel.text = [NSString stringWithFormat:@"-%@%@",self.model.num,self.model.currency_mark];            self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_reve");
            self.addressLabel.text = self.model.url;
            self.teidLabel.text = self.model.add_time;
            self.shouxuLabel.text = self.model.fee;
            self.item7.hidden = YES;
            self.canBtn.hidden = NO;
            
        }else{
            self.typenameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_type");
            self.numNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_number");
            self.statusNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_sstatus");
            self.addressNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_address");
            self.teidNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_time");
            self.shouxuNameLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_shouxu");
            self.numberLabel.text = [NSString stringWithFormat:@"-%@%@",self.model.num,self.model.currency_mark];
            if ([self.model.status isEqualToString:@"-1"]) {
                self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_reve");
            }else if ([self.model.status isEqualToString:@"-2"]){
                self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_resolve");
            }else if ([self.model.status isEqualToString:@"3"]){
                self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_chongbi");
            }else{
                self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_scuess");
            }
            self.addressLabel.text = self.model.url;
            self.teidLabel.text = self.model.add_time;
            self.shouxuLabel.text = self.model.fee;
            self.item7.hidden = YES;
        }
    }else{
        self.typenameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_type");
        self.numNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_number");
        self.statusNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_sstatus");
        self.addressNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_address");
        self.teidNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_time");
        self.shouxuNameLabel.text = kLocat(@"HBTokenWithdrawViewController_token_txid");
        self.typeLabel.text = kLocat(@"k_ExchangeRecordViewController_topbar_1");
        self.numberLabel.text = self.model.num;
        if ([self.model.status isEqualToString:@"-1"]) {
            self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_reve");
        }else if ([self.model.status isEqualToString:@"-2"]){
            self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_resolve");
        }else if ([self.model.status isEqualToString:@"3"]){
            self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_chongbi");
        }else{
            self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_scuess");
        }
        self.addressLabel.text = self.model.url;
        self.teidLabel.text = self.model.add_time;
        self.shouxuLabel.text = self.model.ti_id;
        self.item7.hidden = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)cancelAction:(id)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"id"] = self.model.id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/cancelCoin"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [kKeyWindow showWarning:kLocat(@"HBTokenWithdrawViewController_cancel_scuess")];
            kNavPop;
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}






@end
