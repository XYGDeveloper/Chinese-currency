//
//  YWEMGroupInfoTopCell.m
//  ywshop
//
//  Created by 周勇 on 2017/12/8.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWEMGroupInfoTopCell.h"
#import "YWEMGroupInfoCollectionCell.h"

@interface YWEMGroupInfoTopCell()

@property(nonatomic,assign)BOOL isOwner;

@end

@implementation YWEMGroupInfoTopCell


-(void)reloadDataWith:(NSArray *)dataArray isOwner:(BOOL)isOwner
{
    _isOwner = isOwner;
    _dataArray = dataArray;
    [self.collectView reloadData];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    //创建布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //确定item的大小
    layout.itemSize = CGSizeMake(kScreenW/5, 82);
    
    //确定横向间距
    layout.minimumLineSpacing = 0;
    
    //确定纵向间距
    layout.minimumInteritemSpacing = 0;
    
    //确定滚动方向
    layout.scrollDirection = 0;
    
    
    //创建集合视图(需要布局对象进行初始化)
    self.collectView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.contentView addSubview:self.collectView];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = kWhiteColor;
    
    self.collectView.scrollEnabled = NO;
    
    [self.collectView registerNib:[UINib nibWithNibName:@"YWEMGroupInfoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"YWEMGroupInfoCollectionCell"];

    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    lineView.backgroundColor = kColorFromStr(@"e6e6e6");
    
    UIView *lineView1 = [[UIView alloc] init];
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    lineView1.backgroundColor = kColorFromStr(@"e6e6e6");


}
//元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (_dataArray.count == 0) {
        return 0;
    }else if (_isOwner){
        return self.dataArray.count + 2;
    }else{
        return self.dataArray.count + 1;
    }
}

//数据分配
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWEMGroupInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YWEMGroupInfoCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count) {
        cell.nameLabel.text = self.dataArray[indexPath.item].member_nick;
        [cell.avatar setImageWithURL:self.dataArray[indexPath.item].member_avatar.ks_URL placeholder:kImageFromStr(@"a_img")];
    }else if (indexPath.item == self.dataArray.count){
        cell.nameLabel.text = @"";
        cell.avatar.image = kImageFromStr(@"addFriend");
    }else{
        cell.nameLabel.text = @"";

        cell.avatar.image = kImageFromStr(@"deleteFriend");
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(didClickCollectionCell:)]) {
        [self.delegate didClickCollectionCell:indexPath.item];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
