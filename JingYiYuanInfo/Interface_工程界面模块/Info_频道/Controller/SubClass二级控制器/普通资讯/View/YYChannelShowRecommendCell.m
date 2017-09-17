//
//  YYChannelShowRecommendCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannelShowRecommendCell.h"
#import "YYChannelShowRecommendSubCell.h"
#import "YYShowOtherDetailController.h"
#import "YYShowRecommendModel.h"
#import "UIView+YYParentController.h"

static NSString * const cellId = @"cellId";

@interface YYChannelShowRecommendCell()<UICollectionViewDelegate,UICollectionViewDataSource>

/** collectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;

/** flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation YYChannelShowRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubView];
    }
    return self;
}

/**
 *  加载子控件
 */
- (void)configSubView {
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

#pragma mark -------  collectionview  代理方法 ----------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    YYShowRecommendModel *model = self.dataSource[indexPath.row];
    YYShowOtherDetailController *detail = [[YYShowOtherDetailController alloc] init];
    detail.url = model.webUrl;
    detail.shareImgUrl = model.indeximg;
    [self.parentNavigationController pushViewController:detail animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YYChannelShowRecommendSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    YYShowRecommendModel *model = self.dataSource[indexPath.row];
    cell.imgUrl = model.indeximg;
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] init];
        _collectionView.collectionViewLayout = self.flowLayout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [_collectionView registerClass:[YYChannelShowRecommendSubCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(120, 90);
        _flowLayout.minimumInteritemSpacing = YYInfoCellCommonMargin;
    }
    return _flowLayout;
}


@end
