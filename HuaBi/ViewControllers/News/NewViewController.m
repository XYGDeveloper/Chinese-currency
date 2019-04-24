//
//  NewViewController.m
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "NewViewController.h"
#import "SegmentContainer.h"
#import "YTNewDetailViewController.h"
#import "QlistModel.h"
#import "SafeCategory.h"
#import "EmptyManager.h"
#import "YTNewsModel.h"
@interface NewViewController ()<SegmentContainerDelegate>
@property (nonatomic,strong)SegmentContainer *container;
@property (nonatomic,strong)NSMutableArray *titleArray;
//@property (nonatomic,strong)XNGetLabelListApi *api;
@property (nonatomic,strong)NSArray *tagArray;
@end

@implementation NewViewController


#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.averageSegmentation = NO;
        _container.titleFont = [PFRegularFont(15) fontWithBold];
        _container.titleNormalColor = kColorFromStr(@"#DEE5FF");
        _container.titleSelectedColor = kColorFromStr(@"#FFD401");
        //        _container.minIndicatorWidth = kScreenW/self.titleArray.count;
        _container.indicatorColor = kColorFromStr(@"#FFD401");
        _container.indicatorOffset = 20;
        _container.containerBackgroundColor =kRGBA(24, 30, 50, 1);
        _container.topBar.backgroundColor = kRGBA(24, 30, 50, 1);
    }
    return _container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"news");
    [self loadData];
    [self.view addSubview:self.container];
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
    param[@"uuid"] = [Utilities randomUUID];
    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    param[@"token"] = kUserInfo.token;
    NSLog(@"%@",param);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/art/cates"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        //        [self.tableview.mj_header endRefreshing];
        if (error) {
            [self showTips:error.localizedDescription];
            if (error.code) {
                [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                    [self loadData];
                }];
            }
        }
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            NSLog(@"%@",[responseObj ksObjectForKey:kData]);
            //            [self showTips:[responseObj ksObjectForKey:kMessage]];
            self.titleArray = [NSMutableArray array];
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *arr0 = [YTNewsModel mj_objectArrayWithKeyValuesArray:[responseObj ksObjectForKey:kData]];
            self.tagArray = arr0;
            NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
            if ([currentLanguage containsString:@"en"]) {//英文
                for (YTNewsModel *model in arr0) {
                    [arr addObject:model.name];
                }
                
            }else if ([currentLanguage containsString:@"Hant"]){//繁体
                for (YTNewsModel *model in arr0) {
                    [arr addObject:model.name];
                }
            }else{
                for (YTNewsModel *model in arr0) {
                    [arr addObject:model.name];
                }
            }
           
            self.titleArray = arr;
            [self.container reloadData];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];

}

- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.titleArray.count;
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    YTNewDetailViewController *exchange = [YTNewDetailViewController new];
    YTNewsModel *model = [self.tagArray safeObjectAtIndex:index];
    exchange.cid = model.id;
     NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    if ([currentLanguage containsString:@"en"]) {//英文
        exchange.titles = model.name;
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        exchange.titles = model.name;
    }else{
        exchange.titles = model.name;
    }
    return exchange;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titleArray safeObjectAtIndex:index];
}



@end
