//
//  HBAddAddressViewController.m
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBAddAddressViewController.h"
#import "HBAddressModel.h"
#import "KSScanningViewController.h"

@interface HBAddAddressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hlabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UITextField *noteTextfield;
@property (weak, nonatomic) IBOutlet UIButton *normalAddress;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic,strong)NSString *sele;
@end

@implementation HBAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hlabel.text = [NSString stringWithFormat:@"%@%@",self.currencyName,kLocat(@"HBTokenWithdrawViewController_singleaddress")];
    
    [self.addressLabel setValue:kColorFromStr(@"#6A7687") forKeyPath:@"_placeholderLabel.textColor"];
    [self.noteTextfield setValue:kColorFromStr(@"#6A7687") forKeyPath:@"_placeholderLabel.textColor"];
    self.detailLabel.text = kLocat(@"HBTokenWithdrawViewController_address");
    self.addressLabel.placeholder = kLocat(@"HBTokenWithdrawViewController_address_placehoder");
    self.noteTextfield.placeholder = kLocat(@"HBTokenWithdrawViewController_address_note_bixu");
    [self.normalAddress setTitle:kLocat(@"HBTokenWithdrawViewController_address_normal") forState:UIControlStateNormal];
    [self.normalAddress setTitle:kLocat(@"HBTokenWithdrawViewController_address_normal") forState:UIControlStateSelected];
    [self.normalAddress setImage:[UIImage imageNamed:@"nomal_address"] forState:UIControlStateNormal];
    
    [self.sureButton setTitle:kLocat(@"net_alert_load_message_sure") forState:UIControlStateNormal];
    if ([self.type isEqualToString:@"1"]) {
        self.title = kLocat(@"HBTokenWithdrawViewController_edit_address");
        self.addressLabel.text = self.model.qianbao_url;
        self.noteTextfield.text = self.model.name;
        if ([self.model.is_default isEqualToString:@"1"]) {
            self.normalAddress.selected = YES;
            self.sele = @"1";
        }else{
            self.normalAddress.selected = NO;
            self.sele = @"0";
        }
    }else{
        self.title = kLocat(@"HBTokenWithdrawViewController_add_address");
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)scanAddress:(id)sender {
    KSScanningViewController *vc = [[KSScanningViewController alloc] init];
    vc.callBackBlock = ^(NSString *scannedStr) {
        kLOG(@"%@",[NSString stringWithFormat:@"showName('%@')",scannedStr]);
        self.addressLabel.text = scannedStr;
    };
    kNavPush(vc);
    
}


- (IBAction)defaultAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"%d",sender.selected);
    if (sender.selected == YES) {
        self.sele = @"1";
    }else{
        self.sele = @"0";
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sureButton:(id)sender {
    if (self.addressLabel.text.length <= 0) {
        [kKeyWindow showWarning:kLocat(@"HBTokenWithdrawViewController_address_placehoder")];
        return;
    }
    if (self.noteTextfield.text.length <= 0) {
        [kKeyWindow showWarning:kLocat(@"HBTokenWithdrawViewController_address_note_bixu")];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = self.currencyid;
    param[@"name"] = self.noteTextfield.text;
    param[@"address"] = self.addressLabel.text;
    param[@"is_default"] = self.sele;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/add_qianbao_address"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            kNavPop;
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}




@end
