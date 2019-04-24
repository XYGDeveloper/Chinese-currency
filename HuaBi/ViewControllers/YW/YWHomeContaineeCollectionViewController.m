//
//  YWHomeContaineeCollectionViewController
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWHomeContaineeCollectionViewController.h"
#import "YWHomeContaineeCollectionViewCell.h"
#import "YWTableView.h"
#import "HBShopGoodModel+Request.h"
#import "HBShopCategoryModel.h"
#import "HBGoodsDetailViewController.h"
#import "HBLoginTableViewController.h"

@interface YWHomeContaineeCollectionViewController ()

@property (nonatomic, readonly, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL isFristAppear;
//@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;

@end

@implementation YWHomeContaineeCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    

    self.collectionView.tag = YWShouldRecognizeSimultaneouslyWithGestureRecognizerTag;
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf _requestGoodsListWithIsRefresh:NO];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.width = kScreenW;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat itemWidth = (kScreenW - 10 - 12. - 12.) / 2.;
    itemWidth = floorf(itemWidth);
    
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 106);
}

#pragma mark - Public

- (void)refresh {
    [self _requestGoodsListWithIsRefresh:YES];
}

#pragma mark - Private


- (void)_requestGoodsListWithIsRefresh:(BOOL)isRefresh {
    
    if (self.isFetchInProgress) {
        if (isRefresh && self.requestDidComplete) {
            self.requestDidComplete(nil);
        }
        return;
    }
    
    self.isFetchInProgress = YES;
    
    if (isRefresh) {
        self.currentPage = 1;
        self.noMoreData = NO;
    }
    
    [HBShopGoodModel requestGoodsWithPage:self.currentPage pageSize:sizeOfPage categoryID:self.categoryModel.cat_id success:^(NSArray<HBShopGoodModel *> * _Nonnull models, YWNetworkResultModel * _Nonnull obj) {
        self.isFetchInProgress = NO;
        self.currentPage++;
        [self.collectionView.mj_footer endRefreshing];
        self.noMoreData = models.count < sizeOfPage;
        if (isRefresh) {
            self.models = models;
//            self.emptyDataSetDataSource.title = @"暂无数据";
        } else {
            if (models.count > 0) {
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:self.models];
                [tmp addObjectsFromArray:models];
                self.models = tmp.copy;
            }
        }
        if (isRefresh && self.requestDidComplete) {
            self.requestDidComplete(nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
//        self.emptyDataSetDataSource.title = error.localizedDescription;
        self.isFetchInProgress = NO;
        [self.collectionView.mj_footer endRefreshing];
        if (isRefresh && self.requestDidComplete) {
            self.requestDidComplete(error);
        }
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (HBShopGoodModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.models.count) {
        return self.models[indexPath.item];
    }

    return nil;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWHomeContaineeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YWHomeContaineeCollectionViewCell" forIndexPath:indexPath];
    cell.model = [self modelAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([Utilities isExpired]) {
//        UIViewController *vc = [HBLoginTableViewController fromStoryboard];
//        [self presentViewController:vc animated:YES completion:nil];
//        return;
//    }

    HBShopGoodModel *model = [self modelAtIndexPath:indexPath];
    
    HBGoodsDetailViewController *vc = [[HBGoodsDetailViewController alloc] initWithGoodsId:model.goods_id];
    kNavPush(vc);
}



#pragma mark - Getters && Setters

- (void)setModels:(NSArray<HBShopGoodModel *> *)models {
    _models = models;

    [self.collectionView reloadData];
}



- (UICollectionViewFlowLayout *)flowLayout {
    return (UICollectionViewFlowLayout *)self.collectionViewLayout;
}



- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    
    if (!_canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}

- (void)setNoMoreData:(BOOL)noMoreData {
    _noMoreData = noMoreData;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_noMoreData) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer resetNoMoreData];
        }
//        [self.collectionView.mj_footer setNeedsDisplay];
    });
    
    
}

- (void)setupFooterRefreshView {
    self.collectionView.mj_footer.hidden = self.models.count <= 5;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.y <= 0) {
        self.canScroll = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:YWHomeContaineeViewControllerLeaveTop object:nil];
    }
}

@end
