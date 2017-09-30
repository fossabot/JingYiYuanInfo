//
//  YYPhotoBrowser.m
//  PhotoBrowser
//
//  Created by VINCENT on 2017/9/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPhotoBrowser.h"
#import "PhotoCell.h"
#import "YYHotPicsModel.h"

@interface YYPhotoBrowser()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/** collectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;

/** flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** back*/
@property (nonatomic, strong) UIButton *back;

/** images*/
@property (nonatomic, strong) NSMutableArray *images;

/** titles*/
@property (nonatomic, strong) NSMutableArray *titles;

/** 评论区*/
@property (nonatomic, strong) UIView *commentView;

/** sum 1/6*/
@property (nonatomic, strong) UILabel *imageLabel;

/** title图片描述*/
@property (nonatomic, strong) UILabel *title;

@end

@implementation YYPhotoBrowser
{
    NSInteger _index;
}
- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _images = [images mutableCopy];
        _titles = [titles mutableCopy];
        _index = 0;
        [self configSubview];
        [self changCommentView:0];
    }
    return self;
}

- (instancetype)initWithModels:(NSArray<YYHotPicsModel *> *)models {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _images = [NSMutableArray array];
        _titles = [NSMutableArray array];
        for (YYHotPicsModel *model in models) {
            
            [_images addObject:model.img];
            [_titles addObject:model.desc];
        }
        
        [self configSubview];
        [self changCommentView:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSubview];
    }
    return self;
}

- (void)configSubview {
    
    [self addSubview:self.collectionView];
    [self addSubview:self.back];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40)];
    commentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self addSubview:commentView];
    self.commentView = commentView;
    
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    imageLabel.textColor = [UIColor whiteColor];
    self.imageLabel = imageLabel;
    [self.commentView addSubview:imageLabel];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    self.title = title;
    [self.commentView addSubview:title];
    
}


- (void)setPicsModels:(NSArray<YYHotPicsModel *> *)picsModels {
    
    _picsModels = picsModels;
    self.images = [NSMutableArray array];
    self.titles = [NSMutableArray array];
    for (YYHotPicsModel *model in picsModels) {
        
        [_images addObject:model.img];
        [_titles addObject:model.desc];
    }
//    [self configSubview];
    [self.collectionView reloadData];
    [self changCommentView:0];
}

- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView transitionWithView:self duration:2.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [window addSubview:self];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss {

    if (_dismissBlock) {
        _dismissBlock();
    }
//    [UIView transitionWithView:self duration:2.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            
//            [self removeFromSuperview];
//        }
//    }];
    
}


- (void)changCommentView:(NSInteger)index {
    
    self.imageLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.images.count];
    [self.imageLabel sizeToFit];
    NSString *desc = self.titles[index];
    CGSize size = [desc boundingRectWithSize:CGSizeMake(SCREENWIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.title.text = desc;
    NSLog(@"height%lf",size.height);
//    [self.title sizeToFit];
    self.imageLabel.frame = CGRectMake(10, 0, 40, 20);
    self.title.frame = CGRectMake(10, 30, SCREENWIDTH-20, size.height);
    
    self.commentView.frame = CGRectMake(0, SCREENHEIGHT-CGRectGetMaxY(self.title.frame)-10, SCREENWIDTH, CGRectGetMaxY(self.title.frame)+10);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    YYLogFunc;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX/SCREENWIDTH;
    if (_index != index) {
        
        [self changCommentView:index];
        _index = index;
    }

}


#pragma mark -------  collectionview  代理方法 -------------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _images.count;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"willDisplayCell  indexpath:%ld",indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
//    [self changCommentView:indexPath.row];
    NSLog(@"didEndDisplayingCell indexpath:%ld",indexPath.row);
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.tap = ^{
        [UIView animateWithDuration:0.5 animations:^{
            
            weakSelf.commentView.hidden = !weakSelf.commentView.hidden;
            weakSelf.back.hidden = weakSelf.commentView.hidden;
        }];
    };
    
    [cell setImgUrl:self.images[indexPath.row] total:self.images.count index:indexPath.row];
    
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}


- (UIButton *)back {
    if (!_back) {
        _back = [UIButton buttonWithType:UIButtonTypeCustom];
        _back.frame = CGRectMake(10, 30, 40, 40);
        _back.showsTouchWhenHighlighted = YES;
        [_back setImage:[UIImage imageNamed:@"back_24x24"] forState:UIControlStateNormal];
        [_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_back addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back;
}

@end
