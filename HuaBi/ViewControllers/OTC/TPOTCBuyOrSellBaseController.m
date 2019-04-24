
//
//  TPOTCBuyBaseController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyOrSellBaseController.h"
#import "TPOTCBuyOrSellListController.h"

@interface TPOTCBuyOrSellBaseController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property(nonatomic,strong)NSMutableArray<TPCurrencyModel *> *dataArr;


@end

@implementation TPOTCBuyOrSellBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_hasPostedOrder:) name:@"kUserDidPostAdKey" object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_hasPostedOrder:(NSNotification *)notification {
    [self.dataArr enumerateObjectsUsingBlock:^(TPCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.currencyID isEqual:notification.object]) {
            [self.scrollPageView setSelectedIndex:idx animated:NO];
        }
    }];
}

-(void)loadData
{
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/currencys"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            _dataArr = [NSMutableArray arrayWithCapacity:datas.count];
            for (NSDictionary *dic in datas) {
                [self.dataArr addObject:[TPCurrencyModel modelWithJSON:dic]];
            }
            
            [NSKeyedArchiver archiveRootObject:self.dataArr toFile:[@"kDidGetAllAvailableCurrencyKey" appendDocument]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidGetAllAvailableCurrencyKey" object:_dataArr.copy];
            [self setupUI];
            
        }
    }];
}


-(void)setupUI
{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.scrollLineColor = kColorFromStr(@"FFD401");
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollLineHeight = 2;
    style.titleFont = [PFRegularFont(16) fontWithBold];
    style.normalTitleColor = kColorFromStr(@"#7582A4");
    style.selectedTitleColor = kColorFromStr(@"#FFD401");
    style.autoAdjustTitlesWidth = YES;
    style.adjustCoverOrLineWidth = NO;
    style.gradualChangeTitleColor = YES;
    style.segmentHeight = 44;
    //    self.titles = @[@"标签",@"用户",@"文章",@"资讯"];
    style.scrollTitle = YES;
    
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.dataArr.count];
    
    for (TPCurrencyModel *model in self.dataArr) {
        [titles addObject:model.currencyName];
    }
 
    self.titles = titles.mutableCopy;
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height ) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    //    _scrollPageView.contentView.collectionView.bounces = NO;
    _scrollPageView.segmentView.backgroundColor = kColorFromStr(@"#0B132A");
    
    _scrollPageView.contentView.backgroundColor = kColorFromStr(@"#0B132A");;
    _scrollPageView.contentView.collectionView.backgroundColor = kColorFromStr(@"#0B132A");;
    [self.view addSubview:_scrollPageView];
    
    
}

-(NSInteger)numberOfChildViewControllers
{
    return self.dataArr.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    TPOTCBuyOrSellListController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [TPOTCBuyOrSellListController new];
    }
    childVc.model = self.dataArr[index];
    childVc.isTypeOfBuy = self.isTypeOfBuy;
    return childVc;
}


@end
