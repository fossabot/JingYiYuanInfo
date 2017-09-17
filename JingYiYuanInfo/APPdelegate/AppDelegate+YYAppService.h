//
//  AppDelegate+YYAppService.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.


//用来给APPdelegate的服务管理（注册各种东西，友盟，极光，bugly等等），都可以直接在这里提供一个类方法，直接调用


#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMessage.h"

#import <Bugly/Bugly.h>
#import <SAMKeychain/SAMKeychain.h>

#import "YYUser.h"
#import "YYLoginManager.h"
#import "YYNewVersionViewController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (YYAppService)
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
<UNUserNotificationCenterDelegate>
#endif

/**
 *  注册腾讯Bugly错误统计
 */
- (void)registerBugly;

/**
 *  友盟分享注册
 */
- (void)registerUShare;


/**
 *  友盟推送注册
 */
- (void)registerUPushWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 *  检查更新
 */
- (void)checkAppUpDate;

/**
 *  检查登录密码是否更改了
 */
- (void)checkUserPassword;

/**
 *  加载新版本特性
 */
- (void)launchNewVersion;






@end
