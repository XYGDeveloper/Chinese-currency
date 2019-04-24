//
//  YTDealViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTDealViewController.h"

@interface YTDealViewController ()

@property(nonatomic,strong)NSString *currencyID;

@property(nonatomic,strong)NSString *paraStr;


@end

@implementation YTDealViewController

- (void)viewDidLoad {
    YJTabBarController *tabbarVC = (YJTabBarController *)self.tabBarController;
    if (tabbarVC.currentParam) {
        NSString *para = tabbarVC.currentParam;
        NSArray *arr = [para componentsSeparatedByString:@","];
        kLOG(@"%@",arr);//后面是币的id
        _currencyID = arr.lastObject;
        if ([para hasPrefix:@"gosell"]) {//卖
            self.urlStr = [NSString stringWithFormat:@"%@/Mobile/entrust/tradall_sell/currency/%@/%@",kBasePath,_currencyID,[Utilities dataChangeUTC]];
        }else{//买
            self.urlStr = [NSString stringWithFormat:@"%@/Mobile/entrust/tradall_buy/currency/%@/%@",kBasePath,_currencyID,[Utilities dataChangeUTC]];
        }
    }
    
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidClickBuyOrSell:) name:@"kUserDidClickBuyOrSellButtonKey" object:nil];

}

-(void)userDidClickBuyOrSell:(NSNotification *)noti
{
    NSString *para = noti.object;
    NSArray *arr = [para componentsSeparatedByString:@","];
    kLOG(@"%@",arr);//后面是币的id
    _currencyID = arr.lastObject;
    if ([para hasPrefix:@"gosell"]) {//卖
        
        self.urlStr = [NSString stringWithFormat:@"%@/Mobile/entrust/tradall_sell/currency/%@/%@",kBasePath,_currencyID,[Utilities dataChangeUTC]];
        
    }else{//买
        self.urlStr = [NSString stringWithFormat:@"%@/Mobile/entrust/tradall_buy/currency/%@/%@",kBasePath,_currencyID,[Utilities dataChangeUTC]];
    }
    [self userDidLogin];
}


-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
