//
//  HBAboutUsViewController.m
//  HuaBi
//
//  Created by l on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBAboutUsViewController.h"
#import "YTDetailModel.h"
@interface HBAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet NSArray *list;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *q1;
@property (weak, nonatomic) IBOutlet UILabel *q2;
@property (weak, nonatomic) IBOutlet UILabel *w1;
@property (weak, nonatomic) IBOutlet UILabel *w2;
@property (weak, nonatomic) IBOutlet UILabel *mail1;

@end

@implementation HBAboutUsViewController
- (void)loadData{
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
    param[@"judge"] = @"118";
    param[@"page"] = @"1";
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Art/aboutus"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        if (success) {
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            self.content.text = [[dic ksObjectForKey:@"about"] ksObjectForKey:@"title"];
            self.contentLabel.text = [[dic ksObjectForKey:@"about"] ksObjectForKey:@"content"];
            self.mail1.text = [[dic ksObjectForKey:@"contact"] ksObjectForKey:@"email"];
            self.q1.text = [NSString stringWithFormat:@"QQ1:%@",[[dic ksObjectForKey:@"contact"] ksObjectForKey:@"qq1"]];
            self.q2.text = [NSString stringWithFormat:@"QQ2:%@",[[dic ksObjectForKey:@"contact"] ksObjectForKey:@"qq2"]];
            self.w1.text = [NSString stringWithFormat:@"wechat1:%@",[[dic ksObjectForKey:@"contact"] ksObjectForKey:@"weixin1"]];
            self.w2.text = [NSString stringWithFormat:@"wechat2:%@",[[dic ksObjectForKey:@"contact"] ksObjectForKey:@"weixin2"]];
        }
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_HBHelpCenteriewController_about");
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    [self loadData];
 
    // Do any additional setup after loading the view from its nib.
}



@end
