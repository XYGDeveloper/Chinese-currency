//
//  TPOTCOrderBaseController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCOrderBaseController.h"
#import "TPOTCOrderListController.h"

@interface TPOTCOrderBaseController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation TPOTCOrderBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)setupUI
{
    
    self.view.backgroundColor = kColorFromStr(@"#0B132A");
    
    self.navigationItem.title = kLocat(@"OTC_main_order");
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.scrollLineColor = kColorFromStr(@"FFD401");
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollLineHeight = 2;
    style.titleFont = PFRegularFont(16);
    style.normalTitleColor = kColorFromStr(@"#7582A4");
    style.selectedTitleColor = kColorFromStr(@"#FFD401");
    style.adjustCoverOrLineWidth = NO;
    style.gradualChangeTitleColor = YES;
    style.segmentHeight = 44;
    style.scrollTitle = YES;
 
    //    self.titles = @[@"标签",@"用户",@"文章",@"资讯"];
//    self.titles = @[@"全部",@"未付款",@"待放行",@"已取消",@"已完成",@"申訴中"];
    self.titles = @[kLocat(@"OTC_order_all"),kLocat(@"OTC_order_notpay"),kLocat(@"OTC_order_todischarge"),kLocat(@"OTC_order_cancel"),kLocat(@"OTC_order_done"),kLocat(@"OTC_appleal")];

    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
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
    
    TPOTCOrderListController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        
        childVc = [TPOTCOrderListController new];
    }
    if (index == 0) {
        childVc.type = TPOTCOrderListControllerTypeAll;
    }else if (index == 1){
        childVc.type = TPOTCOrderListControllerTypeNotPay;
    }else if (index == 2){
        childVc.type = TPOTCOrderListControllerTypePaid;
    }else if (index == 3){
        childVc.type = TPOTCOrderListControllerTypeCancel;
    }else if (index == 4){
        childVc.type = TPOTCOrderListControllerTypeDone;
    }else if (index == 5){
        childVc.type = TPOTCOrderListControllerTypeAppeal;
    }

    
    return childVc;
}

@end
