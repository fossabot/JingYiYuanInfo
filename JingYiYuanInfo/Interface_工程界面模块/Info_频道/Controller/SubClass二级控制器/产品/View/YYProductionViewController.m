//
//  YYProductionViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  产品界面

#import "YYProductionViewController.h"
#import "YYProductionListController.h"
#import "YYCompanyListController.h"

@interface YYProductionViewController ()

@end

@implementation YYProductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品";
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    
    self.tabBar.itemTitleColor = TitleColor;
    self.tabBar.itemTitleSelectedColor = ThemeColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = TitleFont;
    self.tabBar.leftAndRightSpacing = 0;
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
    
    YYProductionListController *produtionVc = [[YYProductionListController alloc] init];
    produtionVc.yp_tabItemTitle = @"按产品分类";
    produtionVc.classid = @"1";
    
    YYProductionListController *companyVc = [[YYProductionListController alloc] init];
    companyVc.yp_tabItemTitle = @"按公司分类";
    companyVc.classid = @"2";
    
    self.viewControllers = [NSArray arrayWithObjects:produtionVc, companyVc, nil];
}


@end
