//
//  IndexNoticeTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "IndexNoticeTableViewCell.h"
#import "IndexModel.h"
#import "LSPaoMaView.h"

@interface IndexNoticeTableViewCell()
@property (nonatomic,strong)LSPaoMaView *pamaView;
@end

@implementation IndexNoticeTableViewCell

- (void)refreshWithModel:(articleModel *)model{
    if (self.pamaView) {
        [self.pamaView removeFromSuperview];
        self.pamaView = nil;
    }
    
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
         self.pamaView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(0, 0, self.contentLabel.width,self.contentLabel.height) title:model.title_en];
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
         self.pamaView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(0, 0, self.contentLabel.width,self.contentLabel.height) title:model.title_tc];
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        self.pamaView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(0, 0, self.contentLabel.width,self.contentLabel.height) title:model.title_tc];
    }else if ([currentLanguage containsString:Japanese]){//繁体
        self.pamaView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(0, 0, self.contentLabel.width,self.contentLabel.height) title:model.title_tc];
    }else{//简体
        lang = ThAI;
    }
    [self.contentLabel addSubview:self.pamaView];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
