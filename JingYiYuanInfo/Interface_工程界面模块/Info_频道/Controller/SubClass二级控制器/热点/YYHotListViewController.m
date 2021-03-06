//
//  YYHotViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotListViewController.h"
#import "YYBaseInfoViewController.h"
#import "YYSubtitle.h"

@interface YYHotListViewController ()

@end

@implementation YYHotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"热点";
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    
    self.tabBar.itemTitleColor = TitleColor;
    self.tabBar.itemTitleSelectedColor = ThemeColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:22];
//    self.tabBar.leftAndRightSpacing = 0;
    
    self.tabBar.indicatorColor = ThemeColor;
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabled:YES tapSwitchAnimated:YES];
    self.interceptRightSlideGuetureInFirstPage = YES;
    self.loadViewOfChildContollerWhileAppear = YES;
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    NSMutableArray *viewContrllers = [NSMutableArray array];
    for (YYSubtitle *subTitle in self.datas) {
        
        YYBaseInfoViewController *baseVc = [[YYBaseInfoViewController alloc] init];
        baseVc.yp_tabItemTitle = subTitle.title;
        baseVc.classid = [NSString stringWithFormat:@"%ld",subTitle.classid];
        [viewContrllers addObject:baseVc];
    }
    
    self.viewControllers  = viewContrllers;
    
}
@end
