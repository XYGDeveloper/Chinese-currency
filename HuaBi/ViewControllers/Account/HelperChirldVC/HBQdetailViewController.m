//
//  HBQdetailViewController.m
//  HuaBi
//
//  Created by l on 2018/10/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBQdetailViewController.h"

@interface HBQdetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation HBQdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = kLocat(@"k_HBHelpCenteriewController_normal");

    [self loadData];
    // Do any additional setup after loading the view from its nib.
}


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
    param[@"id"] = self.qid;

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/art/details"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSString *str = [responseObj ksObjectForKey:kData][@"content"];
            [self.webview loadHTMLString:str baseURL:[NSURL URLWithString:kBasePath]];
        }
    }];
}

@end
