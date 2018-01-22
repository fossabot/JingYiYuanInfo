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

@interface YYMarketViewController ()<YPTabBarDelegate>

@end

@implementation YYMarketViewController
{
    YPTabItem *_lastItem;
}

- (void)dealloc {
    
    YYLogFunc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"行情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    
    self.tabBar.itemTitleColor = TitleColor;
    self.tabBar.itemTitleSelectedColor = ThemeColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = NavTitleFont;
    self.tabBar.leftAndRightSpacing = 0;
    self.tabBar.itemSelectedBgColor = ThemeColor;
    
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;

    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(38, 0, 0, 0) tapSwitchAnimated:NO];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    self.loadViewOfChildContollerWhileAppear = YES;
    
    self.tabBar.delegate = self;
    
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

#pragma mark ------- YPTabbar delegate ---------------------------

//- (BOOL)yp_tabBar:(YPTabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index {
//    return YES;
//}

/**
 *  切换到其他item调用
 */
- (void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index {
    
    YPTabItem *item = tabBar.items[index];
    if (_lastItem && item != _lastItem && [_lastItem.title isEqualToString:@"视频"]) {
        
        [kNotificationCenter postNotificationName:YYInfoVideoResetPlayerNotification object:nil];
    }else if (_lastItem && item != _lastItem && [_lastItem.title isEqualToString:@"音乐"]) {
        
        [kNotificationCenter postNotificationName:YYInfoMusicResetPlayerNotification object:nil];
    }
    _lastItem = item;
}



@end
