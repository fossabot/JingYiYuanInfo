//
//  YYNewVersionViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/1.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNewVersionViewController.h"
#import "YYTabBarViewController.h"

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"


@interface YYNewVersionViewController ()

/** animateImageView*/
@property (nonatomic, strong) FLAnimatedImageView *animateImageView;

/** pageControl*/
//@property (nonatomic, strong) UIPageControl *pageControl;

/** currentPage  代替pageControl.currentPage*/
@property (nonatomic, assign) NSInteger currentPage;

/** enterBtn*/
@property (nonatomic, strong) UIButton *enterBtn;

/** currentPage*/
@property (nonatomic, assign) NSInteger lastPage;

@end

@implementation YYNewVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastPage = 0;
    self.currentPage = 0;
    //配置子视图的布局
    [self configSubviews];
    //添加手势
    [self addGestures];
}


#pragma mark -- inner Methods 自定义方法


/**
 *  配置子视图的布局
 */
- (void)configSubviews {
    
    [self.view addSubview:self.animateImageView];
//    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.enterBtn];

    
    [self.animateImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.bottomMargin.equalTo(-30);
//        make.height.equalTo(20);
//        make.width.equalTo(100);
//    }];
    
    [self.enterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottomMargin.equalTo(-25);
        make.height.equalTo(70);
        make.width.equalTo(200);
    }];
    
}

/**
 *  进入主界面
 */
- (void)enterMain {
    
//    YYTabBarViewController *tab = [[YYTabBarViewController alloc] init];
//    [kKeyWindow setRootViewController:tab];
//    [kKeyWindow makeKeyAndVisible];

    [UIView animateWithDuration:1.0 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
    
}


/**
 *  添加手势
 */
- (void)addGestures {
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
}


/**
 *  手势轻扫的方法

 @param swipe 手势
 */
- (void)swipe:(UISwipeGestureRecognizer *)swipe {
    UISwipeGestureRecognizerDirection direction = swipe.direction;
    if (direction == UISwipeGestureRecognizerDirectionLeft) {//左扫
        
        if (_currentPage < 2) {
            _currentPage += 1;
        }else{
            _currentPage = 2;
        }
        if (_currentPage == 2 && _lastPage != _currentPage){
            [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                self.pageControl.hidden = YES;
                self.enterBtn.hidden = NO;
                
            } completion:nil];

        }else if (_currentPage == 2 && _lastPage == _currentPage){
            return;
        }
    }else if (direction == UISwipeGestureRecognizerDirectionRight) {//右扫
        
        if (_currentPage > 0) {
            _currentPage -= 1;
        }else {
            _currentPage = 0;
        }
        if (_currentPage == 1 && _lastPage == 2) {
            
            [UIView animateWithDuration:0.2 animations:^{
//                self.pageControl.hidden = NO;
                self.enterBtn.hidden = YES;
            }];
        }
        if (_currentPage == 0 && _lastPage == _currentPage){
            return;
        }

    }
    
    NSString *fileName = [NSString stringWithFormat:@"guideVie_%ld",_currentPage+1];
    self.animateImageView.animatedImage = [self getAnimateimageWithURLForResource:fileName];
    
    _lastPage = _currentPage;
}


- (FLAnimatedImage *)getAnimateimageWithURLForResource:(NSString *)fileName {

    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *img = [FLAnimatedImage animatedImageWithGIFData:data];
    [img setValue:@1 forKey:@"loopCount"];
    return img;
}



#pragma mark -- lazyMethods 懒加载区域

- (FLAnimatedImageView *)animateImageView {
    if (!_animateImageView) {
        _animateImageView = [[FLAnimatedImageView alloc] initWithFrame:self.view.bounds];
        _animateImageView.animatedImage = [self getAnimateimageWithURLForResource:@"guideVie_1"];
    }
    return _animateImageView;
}

//- (UIPageControl *)pageControl {
//    if (!_pageControl) {
//        _pageControl = [[UIPageControl alloc] init];
//        _currentPage = 0;
//        _pageControl.numberOfPages = 3;
//        _currentPageIndicatorTintColor = ThemeColor;
//    }
//    return _pageControl;
//}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.hidden = YES;
//        _enterBtn.layer.masksToBounds = YES;
//        _enterBtn.layer.cornerRadius = 10;
//        [_enterBtn setTitle:@"进入应用" forState:UIControlStateNormal];
//        [_enterBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
//        [_enterBtn setBackgroundColor:[UIColor whiteColor]];
        [_enterBtn setBackgroundImage:imageNamed(@"enter_400x140") forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(enterMain) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
