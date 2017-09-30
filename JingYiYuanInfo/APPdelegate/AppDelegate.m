//
//  AppDelegate.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+YYAppService.h"
#import "YYTabBarViewController.h"
//#import "YYNewVersionViewController.h"
#import "JPFPSStatus.h"

//#import "IQKeyboardManager.h"
//#import <DateTools.h>

@interface AppDelegate ()<UITabBarControllerDelegate>

/** 点击的时间*/
@property (nonatomic, strong) NSDate *justNow;

@end

@implementation AppDelegate
{
    UIViewController *_lastViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    YYLogFunc;
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    YYLog(@"path------%@",path);
    //注册bugly
    [self registerBugly];
    //注册友盟
    [self registerUShare];
    [self registerUPushWithLaunchOptions:launchOptions];

//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [[IQKeyboardManager sharedManager] setEnableDebugging:YES];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    //初始化程序启动的根控制器tabbarcontroller
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    YYTabBarViewController *tabbar = [[YYTabBarViewController alloc] init];
    window.rootViewController = tabbar;
    tabbar.delegate = self;    
    
    window.rootViewController = tabbar;
    [window makeKeyAndVisible];
    
#warning 未开启新特性界面
    [self launchNewVersion];
    
    //主页在没有return YES之前是不会初始化的  所以  推送通知只能存储在APPdelegate的属性里
//    if (launchOptions) {//若果有launchOptions，说明有推送消息进来
//        NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (remoteNotification) {
//            [self handleRemoteNotification:remoteNotification];
//        }
//    }
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //打开帧数监听，在statusbar上显示
    [[JPFPSStatus sharedInstance] open];
    
    return YES;
    
}

- (void)handleRemoteNotification:(NSDictionary *)remoteNotice{
    YYLogFunc;
    if (kApplication.applicationState == UIApplicationStateActive) {//APP处于激活状态
        //APP在前台状态时，接收到信息，直接弹框提醒用户查看消息
        YYLog(@"UIApplicationStateActiveAPP在前台状态时");
        [self showAlert:@"StateActiveAPP在前台状态时"];
    }else if(kApplication.applicationState == UIApplicationStateInactive) {//调开通知栏，双击home键的任务栏状态，当前APP直接锁屏时的状态
        
        YYLog(@"UIApplicationStateInactive在未运行状态时");
        [self showAlert:@"StateInactive在未运行状态时"];
    }else if (kApplication.applicationState == UIApplicationStateBackground) {
        //APP处于后台状态，单击home键，唤起其他APP，被迫进入后台状态
    YYLog(@"UIApplicationStateBackground在后台状态时");
        [self showAlert:@"StateBackground在后台状态时"];
//        [kNotificationCenter postNotificationName:UIApplicationLaunchOptionsRemoteNotificationKey object:nil userInfo:remoteNotice];
        
    }
    
}

- (void)showAlert:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [kKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- tabbarcontroller  delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    YYLogFunc;
    NSDate *now = [NSDate date];
    if (_lastViewController && viewController == _lastViewController ) {
//        DTTimePeriod *period = [[DTTimePeriod alloc] initWithStartDate:_justNow endDate:now];
//        double duration = [period durationInSeconds];
        if (_justNow) {
           
            double duration = [now timeIntervalSinceDate:_justNow];
            if (duration <= 0.4) {
                
                //发送通知，两次点击了tabbar的同一个item
                [kNotificationCenter postNotificationName:YYTabbarItemDidRepeatClickNotification object:nil userInfo:nil];
            }
        }
    }
    _justNow = now;
    _lastViewController = viewController;
}



/**
 *  如果用户没有重载此函数的话，会导致微博（完整版）SDK通过Webview的回调而崩溃。 开发者需重载此方法接受系统回调
 */
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    YYLogFunc;
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}




#pragma mark ------------------------------------------------------------------
#pragma mark ---------------------  推送区域  -----------------------------------

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    YYLogFunc;
    //APP前台状态可直接接收
    //APP未杀死后台状态 可点击推送接收
    //APP已杀死  点击推送进入finishlaunch 接收到推送  然后进入此方法
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    [self handleRemoteNotification:userInfo];
    //APP未关闭时接收到远程消息
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    YYLog(@"DEVIVETOKEN-------%@",deviceTokenStr);
    [self firstConfigWithDeviceToken:deviceTokenStr];

}


/** APP即将失活状态*/
- (void)applicationWillResignActive:(UIApplication *)application {
    YYLogFunc;
}

/** APP已经进入后台*/
- (void)applicationDidEnterBackground:(UIApplication *)application {
    YYLogFunc;
}

/** APP即将进入前台*/
- (void)applicationWillEnterForeground:(UIApplication *)application {
    YYLogFunc;
}

/** APP得到活性*/
- (void)applicationDidBecomeActive:(UIApplication *)application {
    YYLogFunc;
}

/** APP即将shut down*/
- (void)applicationWillTerminate:(UIApplication *)application {
    YYLogFunc;
}

@end
