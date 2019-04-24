//
//  TPKLineFullScreenController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPKLineFullScreenController.h"
#import "objc/Runtime.h"
#import "ZXAssemblyView.h"



@interface TPKLineFullScreenController ()<AssemblyViewDelegate,ZXSocketDataReformerDelegate>


@property(nonatomic,assign)UIInterfaceOrientationMask inteface;

/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *横竖屏方向
 */
@property (nonatomic,assign) UIInterfaceOrientation orientation;
/**
 *当前绘制的指标名
 */
@property (nonatomic,strong) NSString *currentDrawQuotaName;
/**
 *所有的指标名数组
 */
@property (nonatomic,strong) NSArray *quotaNameArr;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *dataArray;
/**
 *
 */
@property (nonatomic,assign) ZXTopChartType topChartType;

@end

@implementation TPKLineFullScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.enablePanGesture = NO;
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    
    
    


    
    [self addSubviews];
    [self addConstrains];
//    [self configureData];
    
    //这句话必须要,否则拖动到两端会出现白屏
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    self.topChartType = ZXTopChartTypeCandle;
    //
    self.currentDrawQuotaName = self.quotaNameArr[0];

    [self loadKlineData];
    
    //翻转为横屏时
    [self.assenblyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
    }];
    [UIViewController attemptRotationToDeviceOrientation];

    

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    // 强制横屏
    [self forceOrientationLandscape];
    
    YJBaseNavController *nav = (YJBaseNavController *)self.navigationController;
    nav.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    nav.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    //强制旋转竖屏
    [self forceOrientationPortrait];
    YJBaseNavController *navi = (YJBaseNavController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];

}

#pragma mark - Private Methods
- (void)addSubviews
{
    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [self.view addSubview:self.assenblyView];
}

- (void)addConstrains
{
    
    self.navigationController.navigationBar.hidden = YES;
    [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
        
    }];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenH - 50, -5, 50, 50)];
//    UIButton *backButton = [[UIButton alloc] init];
    [self.view addSubview:backButton];
    [backButton setImage:kImageFromStr(@"fd_icon") forState:UIControlStateNormal];
//    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(@(kScreenH - 50));
//        make.right.mas_equalTo(self.assenblyView);
//
//
//        make.width.height.equalTo(@(50));
//    }];
    
    __weak typeof(self)weakSelf = self;

    [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {

        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
    return;
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //初始为竖屏
        self.navigationController.navigationBar.hidden = NO;
        [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.view).offset(200);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(TotalWidth);
            make.height.mas_equalTo(TotalHeight);
            
        }];
        
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        //初始为横屏
        self.navigationController.navigationBar.hidden = YES;
        [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(TotalWidth);
            make.height.mas_equalTo(TotalHeight);
            
        }];
    }
    
}


-(void)loadKlineData
{
    
    
    //绘制k线图
    [self.assenblyView drawHistoryCandleWithDataArr:self.datas precision:6 stackName:_currencyName needDrawQuota:self.currentDrawQuotaName];
    
    
    [self drawQuotaWithCurrentDrawQuotaName:@"VOL"];
    return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"market"] = _currencyName;
    param[@"range"] = @(5*60*1000);
    
    
    [kNetwork_Tool POST_HTTPS:@"/Api/Entrust/kline" andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        //        if (success) {
        
        NSArray *data = [responseObj ksObjectForKey:@"data"][@"lines"];
        NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:data.count];
        for (NSArray *arr in data) {//毫秒转秒
            NSArray *newArr = @[@([arr[0]unsignedLongLongValue]/1000),arr[4],arr[1],arr[2],arr[3],arr[5]];
            NSString *string = [newArr componentsJoinedByString:@","];
            [Marr addObject:string];
        }
        //            kLOG(@"%@",Marr);
        //数据处理
        //        NSArray *aa=    @[@"1504478340,1000,1233,1299,908,60",
        //                          @"1504579340,1300,1233,1299,908,70",
        //                          @"1504680340,1000,1233,1299,908,80",
        //                          @"1504781340,1200,1233,1299,908,90",
        //                          @"1504882340,1000,1233,1299,908,10",
        //                          @"1504983340,1000,1233,1299,908,20",
        //                          @"1505084340,1200,1233,1299,908,60",
        //                          @"1505185340,1000,1233,1299,908,40",
        //                          @"1505286340,1700,1233,1299,908,60",
        //                          @"1505387340,1600,1233,1299,908,50",
        //                          @"15055488340,1500,1233,1299,908,60",
        //                          @"1505689340,1300,1233,1299,908,60",
        //                          @"1505790340,1400,1233,1299,908,60",
        //                          @"1505891340,1800,1233,1299,908,70",
        //                          @"1505992340,10667,1233,1669,908,609"
        //                          ];
        NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:Marr.copy currentRequestType:@"M1"];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:transformedDataArray];
        
        //绘制k线图
        [self.assenblyView drawHistoryCandleWithDataArr:self.datas precision:6 stackName:_currencyName needDrawQuota:self.currentDrawQuotaName];
        
        [self drawQuotaWithCurrentDrawQuotaName:@"VOL"];

        
    }];
    
}






#pragma mark - AssemblyViewDelegate
- (void)tapActionActOnQuotaArea
{
    //这里可以进行quota图的切换
    NSInteger index = [self.quotaNameArr indexOfObject:self.currentDrawQuotaName];
    if (index<self.quotaNameArr.count-1) {
        
        self.currentDrawQuotaName = self.quotaNameArr[index+1];
    }else{
        self.currentDrawQuotaName = self.quotaNameArr[0];
    }
    [self drawQuotaWithCurrentDrawQuotaName:self.currentDrawQuotaName];
}

- (void)tapActionActOnCandleArea
{
    if (self.topChartType==ZXTopChartTypeBrokenLine) {
        
        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
        self.topChartType = ZXTopChartTypeCandle;
    }else if (self.topChartType==ZXTopChartTypeCandle)
    {
        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeBrokenLine];
        self.topChartType = ZXTopChartTypeBrokenLine;
    }
    
}
#pragma mark - 画指标
//在返回的数据里面。可以调用预置的指标接口绘制指标，也可以根据返回的数据自己计算数据，然后调用绘制接口进行绘制
- (void)drawQuotaWithCurrentDrawQuotaName:(NSString *)currentDrawQuotaName
{
    if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[0]])
    {
        //macd绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithMACD];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[1]])
    {
        
        //KDJ绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithKDJ];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[2]])
    {
        
        //BOLL绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithBOLL];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[3]])
    {
        
        //RSI绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithRSI];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[4]])
    {
        
        //Vol绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithVOL];
    }
    
}
#pragma mark - ZXSocketDataReformerDelegate
- (void)bulidSuccessWithNewKlineModel:(KlineModel *)newKlineModel
{
    //维护控制器数据源
    if (newKlineModel.isNew) {
        
        [self.dataArray addObject:newKlineModel];
        [[ZXQuotaDataReformer sharedInstance] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
    }else{
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
        [[ZXQuotaDataReformer alloc] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
    }
    //绘制最后一个蜡烛
    [self.assenblyView drawLastKlineWithNewKlineModel:newKlineModel];
}


#pragma mark - Event Response



#pragma mark - CustomDelegate



#pragma mark - Getters & Setters
- (ZXAssemblyView *)assenblyView
{
    if (!_assenblyView) {
        _assenblyView = [[ZXAssemblyView alloc] initWithDrawJustKline:NO];
        _assenblyView.delegate = self;
        _assenblyView.isDisplayCandelInfoInTop = NO;
        
        
    }
    return _assenblyView;
}
- (UIInterfaceOrientation)orientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}
- (NSArray *)quotaNameArr
{
    if (!_quotaNameArr) {
        _quotaNameArr = @[@"MACD",@"KDJ",@"BOLL",@"RSI",@"VOL"];
    }
    return _quotaNameArr;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma  mark 横屏设置
//强制横屏
- (void)forceOrientationLandscape{
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait{
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}





- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



- (BOOL)shouldAutorotate
{
    return NO;
}




@end
