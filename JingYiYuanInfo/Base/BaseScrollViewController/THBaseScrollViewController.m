//
//  THBaseScrollViewController.m
//  基类封装
//
//  Created by VINCENT on 2017/6/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseScrollViewController.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface THBaseScrollViewController ()

@end

@implementation THBaseScrollViewController


#pragma mark -- lifeCycle 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.baseScrollView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat baseViewHeight = 0;
    CGFloat baseViewWidth = 0;
    NSArray *subViews = self.baseScrollView.subviews;
    
    //遍历视图中MAXY值最大的和MAXX最大的控件，然后设置ScrollView的contentsize
    for (UIView *subView in subViews) {
        
        CGFloat maxX = CGRectGetMaxX(subView.frame);
        CGFloat maxY = CGRectGetMaxY(subView.frame);
        
        if ( maxX > baseViewWidth) {
            baseViewWidth = maxX;
        }
        if ( maxY > baseViewHeight) {
            baseViewHeight = maxY;
        }
        
    }
    
    CGFloat contentWidth = baseViewWidth > kScreenWidth ? baseViewWidth : kScreenWidth;
  
    CGFloat contentHeight = baseViewHeight >= kScreenHeight ? baseViewHeight+20 : kScreenHeight;
    
    self.baseScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    
}




#pragma mark -- lazyMethods 懒加载区域

- (UIScrollView *)baseScrollView{
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _baseScrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
