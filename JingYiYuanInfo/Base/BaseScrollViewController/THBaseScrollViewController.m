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
    
    YYLogFunc
    [self.view addSubview:self.baseScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    YYLogFunc
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
    
    CGFloat contentWidth = baseViewWidth > kScreenWidth ? baseViewWidth : 0;
    YYLog(@"baseScrollView -- contentWidth  %lf",contentWidth);
    if (self.stableWidth) {
        contentWidth = self.stableWidth;
    }
    
    CGFloat contentHeight = baseViewHeight >= kScreenHeight ? baseViewHeight+20 : kScreenHeight+20;
    YYLog(@"baseScrollView -- contentHeight  %lf",contentHeight);
    self.baseScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    
}


#pragma mark -- lazyMethods 懒加载区域

- (UIScrollView *)baseScrollView{
    if (!_baseScrollView) {
        CGRect rect;
        if (self.navigationController) {
            rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-YYTopNaviHeight);
        }else {
            rect = self.view.bounds;
        }
        _baseScrollView = [[UIScrollView alloc] initWithFrame:rect];
    }
    return _baseScrollView;
}





@end
