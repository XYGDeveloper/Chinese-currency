//
//  TPOTCBuyDetaiHeadView.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyDetaiHeadView.h"





@implementation TPOTCBuyDetaiHeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = kColorFromStr(@"#0B132A");
    
    _currencyNameLabel.textColor = kColorFromStr(@"#CDD2E3");
    _currencyNameLabel.font = PFRegularFont(18);
    
    _statusLabel.textColor = kColorFromStr(@"#EA6E44");
    _statusLabel.font = PFRegularFont(14);
    
    _tipsLabel.textColor = kColorFromStr(@"#707589");
    _tipsLabel.font = PFRegularFont(12);
    
    _leftTimeLabel.textColor = kColorFromStr(@"#CDD2E3");
    _leftTimeLabel.font = PFRegularFont(12);
    
    
    _tipsLabel.text = kLocat(@"OTC_view_havecashdeposit");
    _statusLabel.text = kLocat(@"OTC_notPay");
    
}

@end
