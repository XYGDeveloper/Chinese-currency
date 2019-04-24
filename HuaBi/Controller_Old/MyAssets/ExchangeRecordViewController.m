//
//  ExchangeRecordViewController.m
//  YJOTC
//
//  Created by l on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ExchangeRecordViewController.h"
#import "SegmentContainer.h"
#import "RlistViewController.h"

@interface ExchangeRecordViewController ()<SegmentContainerDelegate>
@property (nonatomic,strong)SegmentContainer *container;
@property (nonatomic,strong)NSMutableArray *titleArray;

@end

@implementation ExchangeRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
        self.title = kLocat(@"k_ExchangeRecordViewController_title");
    self.titleArray = @[kLocat(@"k_ExchangeRecordViewController_topbar_0"),kLocat(@"k_ExchangeRecordViewController_topbar_1"),kLocat(@"k_ExchangeRecordViewController_topbar_2"),kLocat(@"k_ExchangeRecordViewController_topbar_3"),kLocat(@"k_ExchangeRecordViewController_topbar_4")].mutableCopy;
    [self.view addSubview:self.container];
}
#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.averageSegmentation = NO;
        _container.titleFont = [PFRegularFont(13) fontWithBold];
        _container.titleNormalColor = kColorFromStr(@"#333333");
        _container.titleSelectedColor = kColorFromStr(@"#896FED");
        _container.indicatorColor = kColorFromStr(@"#896FED");
        _container.indicatorOffset = 20;
        _container.containerBackgroundColor = [UIColor whiteColor];
        _container.topBar.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.titleArray.count;
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    RlistViewController *exchange = [[RlistViewController alloc]initWithType:[self.titleArray objectAtIndex:index]];
    return exchange;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titleArray objectAtIndex:index];
}

@end
