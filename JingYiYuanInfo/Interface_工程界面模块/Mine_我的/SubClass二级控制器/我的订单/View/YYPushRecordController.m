//
//  YYPushRecordController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/5/8.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPushRecordController.h"
#import "YYPushRereadController.h"

#define recordJointUrl @"http://yyapp.1yuaninfo.com/app/houtai/pushRecord.php?"

@interface YYPushRecordController ()

@end

@implementation YYPushRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详情内容";
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
    
    YYPushRereadController *buyVc = [[YYPushRereadController alloc] init];
    buyVc.yp_tabItemTitle = @"服务通知";
//    buyVc.url = [NSString stringWithFormat:@"%@id=%@&type=%@",recordJointUrl,self.pushId,@"1"];

    buyVc.url = @"http://yyapp.1yuaninfo.com/app/houtai/pushRecord.php?id=9&type=1";
    [arr addObject:buyVc];
    
    YYPushRereadController *sellVc = [[YYPushRereadController alloc] init];
    sellVc.yp_tabItemTitle = @"服务提醒";
    sellVc.url = [NSString stringWithFormat:@"%@id=%@&type=%@",recordJointUrl,self.pushId,@"0"];
    [arr addObject:sellVc];
    
    self.viewControllers = arr;
    
}

@end
