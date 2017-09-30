//
//  YYPicsDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPicsDetailController.h"
#import "PhotoCell.h"
#import "YYHotPicsModel.h"

//#import "JPNavigationControllerKit.h"

@interface YYPicsDetailController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

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

/** titleLabel图片描述*/
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation YYPicsDetailController
{
    NSInteger _index;
}

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    [self configSubview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)configSubview {
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.back];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT-40, kSCREENWIDTH, 40)];
    commentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:commentView];
    self.commentView = commentView;
    
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    imageLabel.textColor = [UIColor whiteColor];
    self.imageLabel = imageLabel;
    [self.commentView addSubview:imageLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;
    [self.commentView addSubview:titleLabel];
    
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


- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)changCommentView:(NSInteger)index {
    
    self.imageLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.images.count];
    [self.imageLabel sizeToFit];
    NSString *desc = self.titles[index];
    CGSize size = [desc boundingRectWithSize:CGSizeMake(kSCREENWIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.titleLabel.text = desc;
    NSLog(@"height%lf",size.height);
    //    [self.titleLabel sizeToFit];
    self.imageLabel.frame = CGRectMake(10, 0, 40, 20);
    self.titleLabel.frame = CGRectMake(10, 30, kSCREENWIDTH-20, size.height);
    
    self.commentView.frame = CGRectMake(0, kSCREENHEIGHT-CGRectGetMaxY(self.titleLabel.frame)-10, kSCREENWIDTH, CGRectGetMaxY(self.titleLabel.frame)+10);
}

/** scrollview减速时 滑动完毕 选中相应的文字*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    YYLogFunc;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX/kSCREENWIDTH;
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    YYWeakSelf
    cell.tap = ^{
        YYStrongSelf
        [UIView animateWithDuration:0.5 animations:^{
            
            strongSelf.commentView.hidden = !strongSelf.commentView.hidden;
            strongSelf.back.hidden = strongSelf.commentView.hidden;
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
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
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
        [_back addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back;
}


@end
