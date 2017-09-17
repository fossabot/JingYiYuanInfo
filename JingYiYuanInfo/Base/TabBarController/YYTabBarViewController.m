//
//  YYTabBarViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYTabBarViewController.h"
#import "YYNavigationViewController.h"

#import "YYMainViewController.h"
#import "YYChannelViewController.h"
#import "YYCommunityViewController.h"
#import "YYMineViewController.h"

#import "YYNewVersionViewController.h"

#import "YYTabBar.h"


@interface YYTabBarViewController ()

/** newvc*/
@property (nonatomic, strong) YYNewVersionViewController *versionVC;

@end

@implementation YYTabBarViewController

#pragma mark -- lifeCycle
+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = GrayColor;
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = ThemeColor;
   
    //设置文字属性（选中状态的及为选中的状态下的文字颜色）
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    //设置tabbar的背景图片
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    
    //设置文字位置（水平及垂直方向）
//    [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 替换tabbar
//    [self setValue:[[YYTabBar alloc] init] forKeyPath:@"tabBar"];

    //初始化子控制器的方法
    [self configChildViewcontrollers];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  初始化子控制器的方法
 */
- (void)configChildViewcontrollers {
    
    //资讯首页
    YYMainViewController *mainViewController = [[YYMainViewController alloc] init];
    [self addChildController:mainViewController title:@"首页" iconNormal:@"Tab_main_normal_25x25_" iconSelected:@"Tab_main_highlighted_25x25_"];
    
    //初始化频道界面
    YYChannelViewController *channelViewController = [[YYChannelViewController alloc] init];
    [self addChildController:channelViewController title:@"频道" iconNormal:@"Tab_channel_normal_25x25_" iconSelected:@"Tab_channel_highlighted_25x25_"];
    
    //初始化服务页面
    YYCommunityViewController *communityViewController = [[YYCommunityViewController alloc] init];
    [self addChildController:communityViewController title:@"公社" iconNormal:@"Tab_community_normal_25x25_" iconSelected:@"Tab_community_highlighted_25x25_"];
    
    //初始化个人中心页面
    YYMineViewController *mineViewController = [[YYMineViewController alloc] init];
    [self addChildController:mineViewController title:@"我的" iconNormal:@"Tab_personal_normal_25x25_" iconSelected:@"Tab_personal_highlighted_25x25_"];
    
}


/**
 *  初始化tabbarviewcontroller的每个子控制器的方法
 */
- (void)addChildController:(UIViewController *)viewController title:(NSString*)title iconNormal:(NSString *)iconNormal iconSelected:(NSString *)iconSelected {

    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:iconNormal];
    UIImage *selectedImage = [UIImage imageNamed:iconSelected];
    // 声明：这张图片按照原始的样子显示出来，不要渲染成其他的颜色（比如说默认的蓝色）
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    [self addChildViewController:[[YYNavigationViewController alloc] initWithRootViewController:viewController]];
    
}


@end
