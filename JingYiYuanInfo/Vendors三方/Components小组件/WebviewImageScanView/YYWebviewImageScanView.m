//
//  YYWebviewImageScanView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/26.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYWebviewImageScanView.h"

#define ScanCellId @"ScanCellId"

@interface YYWebviewImageScanView ()<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/** collection*/
@property (nonatomic, strong) UICollectionView *collectionView;

/** layout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

/** images*/
@property (nonatomic, strong) NSArray *imagesArr;

/** url*/
@property (nonatomic, copy) NSString *url;

/** bgView*/
@property (nonatomic, strong) UIScrollView *bgView;

@end


@interface ScanCell ()<UIScrollViewDelegate>

/** scrollView*/
@property (nonatomic, strong) UIScrollView *scrollView;

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation YYWebviewImageScanView
{
    NSInteger selectedIndex;
}
    
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

+ (void)showImages:(NSArray *)images selectedUrl:(NSString *)url {
    YYWebviewImageScanView *view = [[YYWebviewImageScanView alloc] initWithFrame:kMainScreen.bounds];
    view.backgroundColor = BlackColor;
    view.imagesArr = images;
    view.url = url;
    [view addSubview:view.collectionView];
    [view showBigImage:url];

}


#pragma mark 显示大图片
-(void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    self.bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT)];
    [self.bgView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
    self.bgView.contentSize = CGSizeMake(kSCREENWIDTH *self.imagesArr.count, kSCREENHEIGHT);
    self.bgView.pagingEnabled = YES;
    [self addSubview:self.bgView];
    
    //创建关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setFrame:CGRectMake(kSCREENWIDTH/2.0 - 13, 200, 26, 26)];
    [self addSubview:closeBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    //创建显示图像视图
    for (int i = 0; i < self.imagesArr.count; i++) {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(kSCREENWIDTH *i, (kSCREENHEIGHT - 240)/2.0, kSCREENWIDTH-20, 240)];
        [self.bgView addSubview:borderView];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tap];
        
        NSArray *imageIndex = [NSMutableArray arrayWithArray:[self.imagesArr[i] componentsSeparatedByString:@"YYindex"]];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageIndex.firstObject] placeholderImage:nil];
        
        [borderView addSubview:imgView];
        
    }
    NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"YYindex"]];
    
    
    int i = [imageIndex.lastObject intValue];
    [self.bgView setContentOffset:CGPointMake(kSCREENWIDTH *i, 0)];
    
}


//关闭按钮
-(void)removeBigImage
{
    self.bgView.hidden = YES;
}

/** 保存图片*/
- (void)save {
    
    UIImage *image = self.imagesArr[selectedIndex];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//必要实现的协议方法, 不然会崩溃
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}



#pragma mark  scrollview 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ScanCell class] forCellWithReuseIdentifier:ScanCellId];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = self.bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

@end



#pragma scancell  声明区域  -------------------------


@implementation ScanCell
{
    BOOL _zooming;  //是否在zooming状态（是，不调用滑动和点击手势）
    NSInteger total;  //总数
    NSInteger index;  //当前位置
    BOOL _enoughFar; //当滑动距离够100时，足够远了  这时就可以将图片浏览视图关闭了
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self config];
    }
    return self;
}

- (void)config {
    
    [self.contentView addSubview:self.scrollView];
}

/**
 *   判断手势方向
 *
 *  @param translation translation description
 */
- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;
    
    
    if (absX > absY ) {
        
        if (translation.x<0) {
            
            //向左滑动
        }else{
            
            //向右滑动
        }
        
    } else if (absY > absX) {
       
        self.imageView.transform = CGAffineTransformMakeTranslation(0, translation.y);
        if (self.distance) {
            self.distance(translation.y);
        }
        
        if (absY > 100) {
            _enoughFar = YES;
        }else {
            _enoughFar = NO;
        }
        
        if (translation.y<0) {
            
            //向上滑动
            
        }else{
            
            //向下滑动
        }
    }
    
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
}


- (void)pan:(UIPanGestureRecognizer *)pan {
    
    if (_zooming) {
        return;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[pan translationInView:self.imageView]];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        
    }
}

#pragma mark setter

- (void)setImgUrl:(NSString *)imgUrl total:(NSInteger)total index:(NSInteger)index {
    
    //移除上一个imageView
//    [self.imageView removeFromSuperview];
    
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.yy_width, self.yy_width*2/3)];
    //    self.imageView.image = [UIImage imageNamed:@"placeholder"];
//    self.imageView.yy_center = self.center;
//    self.imageView.yy_width = self.yy_width;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView.userInteractionEnabled = YES;
//    [self.scrollView addSubview:self.imageView];
    YYWeakSelf
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:placeHolderMini] options:SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        [SVProgressHUD show];
//        YYStrongSelf
        if (expectedSize) {
            
        }
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        YYStrongSelf
        if (image) {
            
//            strongSelf.imageView.frame = [strongSelf setImage:image];
            //设置scroll的contentsize的frame
            strongSelf.scrollView.contentSize = strongSelf.imageView.frame.size;
        }
        [SVProgressHUD dismiss];
    }];
    
}



#pragma mark  scrollview  代理方法

//这个方法的返回值决定了要缩放的内容(只能是UISCrollView的子控件)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//控制缩放是在中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView addSubview:self.imageView];
    }
    return _scrollView;
}


- (UIImageView *)imageView{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.maximumNumberOfTouches = 1;
        [_imageView addGestureRecognizer:pan];
        
    }
    return _imageView;
}


@end

