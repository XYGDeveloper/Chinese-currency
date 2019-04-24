
//
//  YWCircleChangeController.m
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleChangeController.h"
#import "YWCircleChangeCell.h"

@interface YWCircleChangeController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<YWCircleGroupModel *> *hotArray;

@property(nonatomic,strong)NSMutableArray<YWCircleGroupModel *> *listArray;

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,copy)NSString *selectedArea;

@property(nonatomic,strong)NSArray *cityArray;

@property(nonatomic,strong)NSDictionary *selectedInfo;


@end

@implementation YWCircleChangeController

- (void)viewDidLoad {
    [super viewDidLoad];

    _hotArray = [NSMutableArray array];
    _listArray = [NSMutableArray array];


    [self setupUI];
    [self loadDataWithAreaID:@"1"];
//    [self loadCityInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_selectedModel == nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"didChooseCirclGroup" object:self.hotArray.firstObject];
    }
}
-(void)setupUI
{
    self.title = kLocat(@"R_ChangeCoinCircle");
    self.view.backgroundColor = kWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,  kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleChangeCell" bundle:nil] forCellReuseIdentifier:@"YWCircleChangeCell"];
    _tableView.backgroundColor = kBGColor;
    
    
}

-(void)loadDataWithAreaID:(NSString *)areaID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"request_type"] = @"list";
    param[@"act"] = @"district";
    param[@"op"] = @"group";
//    param[@"group_city"] = areaID;
    param[@"group_city"] = @"1";
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    __weak typeof(self)weakSelf = self;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kGetGroup] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [_hotArray removeAllObjects];
            [_listArray removeAllObjects];
            NSArray *hot = [responseObj ksObjectForKey:kData][@"hot"];
            for (NSDictionary *dic in hot) {
                [weakSelf.hotArray addObject:[YWCircleGroupModel modelWithDictionary:dic]];
            }
            NSArray *list = [responseObj ksObjectForKey:kData][@"list"];
            for (NSDictionary *dic in list) {
                [weakSelf.listArray addObject:[YWCircleGroupModel modelWithDictionary:dic]];
            }

            [weakSelf.tableView reloadData];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}
//获取城市列表
-(void)loadCityInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"act"] = @"district";
    param[@"op"] = @"changeDistrict";
    param[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kGetGroupCityList] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
         
            _cityArray = [responseObj ksObjectForKey:kData];
            [self loadDataWithAreaID:_cityID];
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {

        return _hotArray.count;
    }else{

        return _listArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"YWCircleChangeCell";
    YWCircleChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    if (indexPath.section == 0) {
        cell.model = self.hotArray[indexPath.row];
        
    }else{
        cell.model = self.listArray[indexPath.row];
    }
    
    cell.topLine.hidden = indexPath.row;
    
    [cell.changeButton addTarget:self action:@selector(didClickChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.changeButton.tag = indexPath.row;
    
    return cell;
}

-(void)didClickChangeButton:(UIButton *)button
{
    YWCircleChangeCell *cell = (YWCircleChangeCell *)button.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    if (indexPath.section == 0) {//热门
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidChooseGroupKey" object:self.hotArray[button.tag]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidChooseGroupKey" object:self.listArray[button.tag]];
    }
    kNavPop;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138 / 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 40;
    }else{
        return 40;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bannerView = [[UIView alloc]initWithFrame:kRectMake(0, 0, kScreenW, 40)];
    bannerView.backgroundColor = kWhiteColor;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:kRectMake(0, 0, bannerView.width, bannerView.height)];
    [bannerView addSubview:titleLabel];
    NSString *proName = nil;
    if (section == 0) {
//        titleLabel.text = @"热门商圈";
        titleLabel.text = kLocat(@"R_HotCoinCircle");

    }else{
//        if (_selectedInfo) {
//            proName = _selectedInfo[@"area_name"];
//        }else{
//            for (NSDictionary *dic in self.cityArray) {
//                if ([dic[@"area_id"] integerValue] == self.listArray.firstObject.group_city.integerValue) {
//                    proName = dic[@"area_name"];
//                    break;
//                }
//            }
//        }
//        titleLabel.text = proName;
        titleLabel.text = kLocat(@"R_All");

    }

    titleLabel.textColor = kBlackColor;
    titleLabel.font = PFRegularFont(16);
    [titleLabel sizeToFit];
    [titleLabel alignHorizontal];
    [titleLabel alignVertical];
    
    UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:kRectMake(0, 0, 15, 15)];
    if (section == 0) {
        leftImgView.image = [UIImage imageNamed:@"qiehuanshangquan_zuo"];
    }else{
        leftImgView.image = [UIImage imageNamed:@"zuo2"];
    }
    [bannerView addSubview:leftImgView];
    leftImgView.right = titleLabel.left - 5;
    [leftImgView alignVertical];
    
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:kRectMake(0, 0, 15, 15)];
    if (section == 0) {
        rightImgView.image = [UIImage imageNamed:@"qiehuanshangquan_you"];
    }else{
        rightImgView.image = [UIImage imageNamed:@"you2"];
    }
    [bannerView addSubview:rightImgView];
    rightImgView.left = titleLabel.right + 5;
    [rightImgView alignVertical];
    
    
    return bannerView;

    
    if (section == 1) {
        
        YLButton *changeButton = [[YLButton alloc]initWithFrame:kRectMake(0, 0, 75, 12) title:@"切换省份" titleColor:kColorFromStr(@"939393") font:PFRegularFont(12) titleAlignment:0];
        [changeButton setImage:kImageFromStr(@"xiala") forState:UIControlStateNormal];
        [bannerView addSubview:changeButton];
        changeButton.titleRect = kRectMake(10, 0,49, changeButton.height);
        changeButton.imageRect = kRectMake(59, 2.5, 12, 7);
        [changeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            
            [self showPickViewWith:proName];
        }];
        [changeButton alignVertical];
        changeButton.right = kScreenW - kMargin;
    }

    if (section == 0) {
        return bannerView;
    }

    UIView *headView = [[UIView alloc]initWithFrame:kRectMake(0, 0, 43, 40 + 12)];
    headView.backgroundColor = kBGColor;
    [headView addSubview:bannerView];
    bannerView.frame = kRectMake(0, 12, kScreenW, 40);
    return headView;
}
-(void)showPickViewWith:(NSString *)title
{
    UIView *bgView = [[UIView alloc]initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight)];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
    [self.view addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self hidePickView];
    }]];
    
    UIView *bannerView = [[UIView alloc]initWithFrame:kRectMake(0, 0 - 307, kScreenW, 40)];
    bannerView.backgroundColor = kWhiteColor;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:kRectMake(0, 0, bannerView.width, bannerView.height)];
    [bannerView addSubview:titleLabel];
    _topView = bannerView;

    titleLabel.text = title;
    titleLabel.textColor = kBlackColor;
    titleLabel.font = PFRegularFont(16);
    [titleLabel sizeToFit];
    [titleLabel alignHorizontal];
    [titleLabel alignVertical];
    
    UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:kRectMake(0, 0, 15, 15)];
    
    leftImgView.image = [UIImage imageNamed:@"zuo2"];
    [bannerView addSubview:leftImgView];
    leftImgView.right = titleLabel.left - 5;
    [leftImgView alignVertical];
    
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:kRectMake(0, 0, 15, 15)];
    
    rightImgView.image = [UIImage imageNamed:@"you2"];
    [bannerView addSubview:rightImgView];
    rightImgView.left = titleLabel.right + 5;
    [rightImgView alignVertical];
    
    
    
    YLButton *changeButton = [[YLButton alloc]initWithFrame:kRectMake(0, 0, 75, 12) title:@"切换省份" titleColor:kColorFromStr(@"939393") font:PFRegularFont(12) titleAlignment:0];
    [changeButton setImage:kImageFromStr(@"shangla") forState:UIControlStateNormal];
    [bannerView addSubview:changeButton];
    changeButton.titleRect = kRectMake(10, 0,49, changeButton.height);
    changeButton.imageRect = kRectMake(59, 2.5, 12, 7);
    [changeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [bgView removeFromSuperview];
    }];
    [changeButton alignVertical];
    changeButton.right = kScreenW - kMargin;
    
    [bgView addSubview:bannerView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:kRectMake(0, bannerView.bottom - 307, kScreenW, 267)];
    bottomView.backgroundColor = kWhiteColor;
    [bgView addSubview:bottomView];
    _bottomView = bottomView;
    
    
    CGFloat w = (kScreenW - 24) / 5;
    CGFloat h = 30;
    CGFloat margin = 5;
    NSInteger totalColumns = 5;
    for (NSInteger i = 0; i < self.cityArray.count; i++) {
        NSInteger row = i / totalColumns;
        NSInteger col = i % totalColumns;
        CGFloat x = col * w + kMargin;
        CGFloat y = row * (h + margin) + margin;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:kRectMake(x, y, w, h) title:self.cityArray[i][@"area_name"] titleColor:kColorFromStr(@"999999") font:PFRegularFont(16) titleAlignment:1];
        [bottomView addSubview:btn];
        kViewBorderRadius(btn, 13.5,0, kRedColor);
        [btn setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"1eaafa")] forState:UIControlStateSelected];
        [btn setTitleColor:kWhiteColor forState:UIControlStateSelected];
//        btn.tag = i;
        if ([title isEqualToString:self.cityArray[i][@"area_name"]]) {
            btn.selected = YES;
        }
        
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            sender.selected = YES;
            
            [self.cityArray enumerateObjectsUsingBlock:^(NSDictionary *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                if ([obj[@"area_name"] isEqualToString:sender.currentTitle]) {
                    _selectedInfo = obj;
                    [self loadDataWithAreaID:obj[@"area_id"]];
                    *stop = YES;
                }
            }];
            
            [self hidePickView];
        }];
    }

    [UIView animateWithDuration:0.25 animations:^{
        _topView.frame = kRectMake(0, 0, kScreenW, 40);
        _bottomView.frame = kRectMake(0, bannerView.bottom, kScreenW, 267);
    }];
}
-(void)hidePickView
{
    [_bottomView.superview removeFromSuperview];
}



@end
