//
//  YYProjectViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProjectViewController.h"
#import "YYProjectListController.h"
#import "YYSubtitle.h"

@interface YYProjectViewController ()

@end

@implementation YYProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"项目";
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    
    self.tabBar.itemTitleColor = TitleColor;
    self.tabBar.itemTitleSelectedColor = ThemeColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = NavTitleFont;
//    self.tabBar.itemSelectedBgColor = ThemeColor;
    self.tabBar.indicatorColor = ThemeColor;
    self.tabBar.indicatorAnimationStyle = YPTabBarIndicatorAnimationStyleDefault;
    [self.tabBar setIndicatorInsets:UIEdgeInsetsMake(38, 0, 0, 0) tapSwitchAnimated:NO];
    
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    
    [self setContentScrollEnabled:YES tapSwitchAnimated:YES];
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    self.loadViewOfChildContollerWhileAppear = YES;
    self.tabBar.delegate = self;
    
    // 添加所有子控制器
    [self setUpAllViewController];
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    NSMutableArray *viewContrllers = [NSMutableArray array];
    
    YYProjectListController *baseVc = [[YYProjectListController alloc] init];
    baseVc.yp_tabItemTitle = @"推荐";
    baseVc.classid = @"0";
    [viewContrllers addObject:baseVc];
    
    for (YYSubtitle *subTitle in self.datas) {
        NSLog(@"title -- %@   classid -- %ld",subTitle.title,subTitle.classid);
        YYProjectListController *baseVc = [[YYProjectListController alloc] init];
        baseVc.yp_tabItemTitle = subTitle.title;
        baseVc.classid = [NSString stringWithFormat:@"%ld",subTitle.classid];
        [viewContrllers addObject:baseVc];
    }
    self.viewControllers = viewContrllers;
}




@end
