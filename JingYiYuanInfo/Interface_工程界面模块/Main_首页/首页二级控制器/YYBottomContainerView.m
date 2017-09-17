//
//  YYBottomContainerView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBottomContainerView.h"
#import "YYTitleView.h"
#import "YYHotView.h"
#import "YYNiuView.h"

@interface YYBottomContainerView()

/** titleView*/
@property (nonatomic, strong) YYTitleView *titleView;

/** scrollview*/
@property (nonatomic, strong) UIScrollView *container;

/** hotView*/
@property (nonatomic, strong) YYHotView *hotView;

/** niuView*/
@property (nonatomic, strong) YYNiuView *niuView;

@end

@implementation YYBottomContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}


/** 创建子控件*/
- (void)createSubview {
    
    YYWeakSelf
    self.titleView.selectedBlock = ^(NSInteger index){
        YYStrongSelf
        [strongSelf.container setContentOffset:CGPointMake(index*kSCREENWIDTH, 0)];
        
    };
    [self addSubview:self.titleView];
    
    [self addSubview:self.container];
    
    self.hotView = [[YYHotView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, self.container.bounds.size.height)];
    self.hotView.backgroundColor = [UIColor redColor];
    [self.container addSubview:self.hotView];
    
    self.niuView = [[YYNiuView alloc] initWithFrame:CGRectMake(kSCREENWIDTH, 0, kSCREENWIDTH, self.container.bounds.size.height)];
    self.niuView.backgroundColor = [UIColor blueColor];
    [self.container addSubview:self.niuView];
    
}


#pragma mark -- lazyMethods 懒加载区域

- (YYTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[YYTitleView alloc] initWithTitles:@[@"热搜榜",@"牛人榜"]];
    }
    return _titleView;
}

- (UIScrollView *)container {
    if (!_container) {
        
        _container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TabHeaderH, kSCREENWIDTH, self.bounds.size.height - TabHeaderH)];
        _container.contentSize = CGSizeMake(2*kSCREENWIDTH, self.yy_height - TabHeaderH);
        _container.showsVerticalScrollIndicator = NO;
        _container.showsHorizontalScrollIndicator = NO;
        _container.scrollEnabled = NO;
        
    }
    return _container;
}
@end
