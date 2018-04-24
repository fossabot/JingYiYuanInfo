//
//  YYMineMsgHistoryViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineMsgHistoryViewController.h"
#import "YYPeriodicalController.h"

@interface YYMineMsgHistoryViewController ()

@end

@implementation YYMineMsgHistoryViewController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推送历史记录";
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    
    self.tabBar.itemTitleColor = TitleColor;
    self.tabBar.itemTitleSelectedColor = ThemeColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = TitleFont;
    [self.tabBar setIndicatorInsets:UIEdgeInsetsMake(38, 0, 0, 0) tapSwitchAnimated:YES];

    self.tabBar.indicatorColor = ThemeColor;
//    self.tabBar.indicatorAnimationStyle = YPTabBarIndicatorAnimationStyle1;
    
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    
    [self setContentScrollEnabled:YES tapSwitchAnimated:YES];
    self.interceptRightSlideGuetureInFirstPage = YES;
    self.loadViewOfChildContollerWhileAppear = YES;
    self.tabBar.delegate = self;
    
    [self setUpAllChildViewControllers];
}

- (void)setUpAllChildViewControllers {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    YYPeriodicalController *weekVc = [[YYPeriodicalController alloc] init];
    weekVc.yp_tabItemTitle = @"周刊";
    weekVc.classid = @"1";
    [arr addObject:weekVc];
    
    YYPeriodicalController *monthVc = [[YYPeriodicalController alloc] init];
    monthVc.yp_tabItemTitle = @"月刊";
    monthVc.classid = @"2";
    [arr addObject:monthVc];
    
    self.viewControllers = arr;
    
}


@end
