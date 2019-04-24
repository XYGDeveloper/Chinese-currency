//
//  HBExchangeRecordViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeRecordViewController.h"
#import "HBExchangeRecordCell.h"
#import "HBExchangeRecordListTableViewController.h"

@interface HBExchangeRecordViewController () <ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation HBExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocat(@"Exchange_Records");
    [self setupUI];
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
        self.titles = @[@"全部",@"兌換成功",@"審核中",@"兌換失敗"];
    style.scrollTitle = YES;
    
    
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 ) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    //    _scrollPageView.contentView.collectionView.bounces = NO;
    _scrollPageView.segmentView.backgroundColor = kColorFromStr(@"#0B132A");
    
    _scrollPageView.contentView.backgroundColor = kColorFromStr(@"#0B132A");;
    _scrollPageView.contentView.collectionView.backgroundColor = kColorFromStr(@"#0B132A");;
    [self.view addSubview:_scrollPageView];
    
    
}

-(NSInteger)numberOfChildViewControllers
{
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    HBExchangeRecordListTableViewController *childVc = (HBExchangeRecordListTableViewController *)reuseViewController;
    
    if (!childVc) {
        childVc = [HBExchangeRecordListTableViewController fromStoryboard];
    }
    NSInteger status = 100;
    switch (index) {
        case 1:
            status = 1;
            break;
        case 2:
            status = 0;
            break;
        case 3:
            status = -1;
            break;
        default:
            break;
    }
    childVc.status = status;
    return childVc;
}


@end
