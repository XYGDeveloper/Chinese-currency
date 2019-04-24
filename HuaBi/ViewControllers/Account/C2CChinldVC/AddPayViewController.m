//
//  AddPayViewController.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AddPayViewController.h"
#import "SegmentContainer.h"
#import "AddWechatViewController.h"
#import "AddAliViewController.h"
#import "AddCardViewController.h"
@interface AddPayViewController ()<SegmentContainerDelegate>
@property (nonatomic,strong)SegmentContainer *container;
@property (nonatomic,strong)NSMutableArray *titleArray;
@end
@implementation AddPayViewController

#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.averageSegmentation = YES;
        _container.titleFont = [PFRegularFont(13) fontWithBold];
        _container.titleNormalColor = kColorFromStr(@"#333333");
        _container.titleSelectedColor = kColorFromStr(@"#896FED");
        //        _container.minIndicatorWidth = kScreenW/self.titleArray.count;
        _container.indicatorColor = kColorFromStr(@"#896FED");
        _container.indicatorOffset = 20;
        _container.containerBackgroundColor = [UIColor whiteColor];
        _container.topBar.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_PAYViewController_typed");
    self.titleArray = @[kLocat(@"k_PAYViewController_typec"),kLocat(@"k_PAYViewController_typea"),kLocat(@"k_PAYViewController_typew")].mutableCopy;
    [self.view addSubview:self.container];
}

- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.titleArray.count;
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    if (index == 0) {
        AddCardViewController *card = [[AddCardViewController alloc]init];
        return card;
        
    }else if (index ==1){
        AddAliViewController *alipay = [[AddAliViewController alloc]init];
        return alipay;
    }else{
        AddWechatViewController *wechat = [[AddWechatViewController alloc]init];
        return wechat;
    }
    
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titleArray objectAtIndex:index];
}

@end
