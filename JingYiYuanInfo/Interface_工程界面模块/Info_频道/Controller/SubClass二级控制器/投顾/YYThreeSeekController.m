//
//  YYThreeSeekController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYThreeSeekController.h"
#import "YYThreeSeekBaseController.h"
#import "YYSubtitle.h"

@interface YYThreeSeekController ()

@end

@implementation YYThreeSeekController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    
    self.tabBar.itemTitleColor = TitleColor;
    self.tabBar.itemTitleSelectedColor = ThemeColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = TitleFont;
    self.tabBar.leftAndRightSpacing = 10;
    self.tabBar.itemSelectedBgColor = ThemeColor;
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(38, 0, 0, 0) tapSwitchAnimated:YES];
    
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.tabBar.delegate = self;
    
    [self setUpAllChildViewControllers];
}

- (void)setUpAllChildViewControllers {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    YYThreeSeekBaseController *allVc = [[YYThreeSeekBaseController alloc] init];
    allVc.yp_tabItemTitle = @"全部";
    allVc.classid = @"0";
    allVc.fatherId = self.fatherId;
    [arr addObject:allVc];
    
    for (YYSubtitle *subtitle in self.datas) {
        
        YYThreeSeekBaseController *threeBaseVc = [[YYThreeSeekBaseController alloc] init];
        threeBaseVc.yp_tabItemTitle = subtitle.title;
        threeBaseVc.classid = [NSString stringWithFormat:@"%ld",subtitle.classid];
        threeBaseVc.fatherId = self.fatherId;
        [arr addObject:threeBaseVc];
    }
    
    self.viewControllers = arr;
    
}


@end
