//
//  YYCommunityViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/1.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityViewController.h"
#import "YYCommunityPersonController.h"
#import "YYCommunityMediaController.h"
#import "YYCommunityQuestionController.h"

@interface YYCommunityViewController ()


@end

@implementation YYCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationItem.title = @"公社";
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
    
    YYCommunityPersonController *personVc = [[YYCommunityPersonController alloc] init];
    personVc.yp_tabItemTitle = @"自媒体";
    personVc.classid = @"1";
    
    YYCommunityMediaController *mediaVc = [[YYCommunityMediaController alloc] init];
    mediaVc.yp_tabItemTitle = @"视频";
    mediaVc.classid = @"2";
    
    YYCommunityQuestionController *questionVc = [[YYCommunityQuestionController alloc] init];
    questionVc.yp_tabItemTitle = @"我的问答";
    questionVc.classid = @"3";
    
    self.viewControllers = [NSArray arrayWithObjects:personVc, mediaVc,questionVc, nil];
}


@end
