//
//  YYMarketViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMarketViewController.h"
#import "YYBaseInfoViewController.h"

#import "YYSubtitle.h"

@interface YYMarketViewController ()

@end

@implementation YYMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"行情";
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    
    self.tabBar.itemTitleColor = TitleColor;
    self.tabBar.itemTitleSelectedColor = ThemeColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = NavTitleFont;
    self.tabBar.leftAndRightSpacing = 10;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = ThemeColor;
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(38, 0, 0, 0) tapSwitchAnimated:YES];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    NSMutableArray *viewContrllers = [NSMutableArray array];
    for (YYSubtitle *subTitle in self.datas) {
        NSLog(@"title -- %@   classid -- %ld",subTitle.title,subTitle.classid);
        YYBaseInfoViewController *baseVc = [[YYBaseInfoViewController alloc] init];
        baseVc.yp_tabItemTitle = subTitle.title;
        baseVc.classid = [NSString stringWithFormat:@"%ld",subTitle.classid];
        [viewContrllers addObject:baseVc];
    }
    self.viewControllers = viewContrllers;

}


@end
