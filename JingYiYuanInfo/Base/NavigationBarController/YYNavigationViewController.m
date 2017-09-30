//
//  YYNavigationViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNavigationViewController.h"
#import "UIBarButtonItem+YYExtension.h"
#import "UIView+YYViewFrame.h"
#import "UIImage+Category.h"
//#import <JPNavigationController/JPNavigationController.h>
#import "JZNavigationExtension.h"

@interface YYNavigationViewController ()

@end

@implementation YYNavigationViewController

#pragma mark -- lifeCycle
//APP生命周期中 只会执行一次
+ (void)initialize
{
    //导航栏主题 title文字属性
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:NaviColor];
    [navBar setTintColor:WhiteColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    
    [navBar setBackgroundImage:[UIImage imageWithColor:ThemeColor] forBarMetrics:UIBarMetricsDefault];
    
    //导航栏左右文字主题
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
}

//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
//    RTRootNavigationController *rt = [[RTRootNavigationController alloc] initWithRootViewController:rootViewController];
//    return rt;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.jz_navigationBarTransitionStyle = JZNavigationBarTransitionStyleDoppelganger;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- systemOpreation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    viewController.navigationItem.backBarButtonItem = back;
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"返回" forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        //设置返回的按钮都是中文返回键
//        [button setImage:[UIImage imageNamed:@"nav_back_white_20x20"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"nav_back_white_20x20"] forState:UIControlStateHighlighted];
//        button.size = CGSizeMake(40, 40);
//        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
////        [button sizeToFit];
//        // 让按钮的内容往左边偏移10
////        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        
//        // 修改导航栏左边的item
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}



@end
