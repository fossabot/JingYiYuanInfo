//
//  AppDelegate+YYAppService.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "AppDelegate+YYAppService.h"



static NSString * const appleid = @"1266188538";
static NSString *versionUrl = @"https://itunes.apple.com/cn/lookup?id=1266188538";
static YYNewVersionViewController *new;

@implementation AppDelegate (YYAppService)


- (void)firstConfigWithDeviceToken:(NSString *)deviceToken {
    
    YYUser *user = [YYUser shareUser];
    [user setDeviceToken:deviceToken];
    if (!user.setUp || user.setUp.length == 0) {
        
        user.setUp = @"setUp";
        [kUserDefaults synchronize];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"setup",@"act",deviceToken,@"devicetoken",@"1",@"mobiletype", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:firstConfigUrl parameters:para success:^(id response) {
            
            if (response) {
                YYLog(@"第一次初始化APP成功");
            }
        } failure:^(NSError *error) {
            YYLog(@"第一次初始化APP  失败了--- ");
            [kUserDefaults removeObjectForKey:setUpInfo];
            [kUserDefaults synchronize];
        } showSuccessMsg:nil];
    }
    
}

/**
 *  注册腾讯Bugly错误统计
 */
- (void)registerBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.blockMonitorEnable = YES;
    config.debugMode = YES;
    [Bugly startWithAppId:BUGLY_APPID config:config];
}


/**
 *  友盟分享注册
 */
- (void)registerUShare {
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    
    //关闭强制https，可以分享http的图片
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;

    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WECHAT_APPID appSecret:WECHAT_APPSECRET redirectURL:nil];
    
    /* 移除相应平台的分享，如微信收藏 */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINA_APPKEY  appSecret:SINA_APPSECRET redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    
}

/** 
 *  友盟推送注册
 */
- (void)registerUPushWithLaunchOptions:(NSDictionary *)launchOptions {
    
    [UMessage startWithAppkey:UPUSH_APPKEY launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
#endif 
    
    [UMessage setLogEnabled:YES];

}




/**
 *  检查更新
 */
- (void)checkAppUpDate {
    
    //App内info.plist文件里面版本号
    NSString *appVersion = kAppVersion;

    //两种请求appStore最新版本app信息 通过bundleId与appleId判断
    //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleid=%@", bundleId]
    //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", appleid]
    
    [PPNetworkHelper GET:versionUrl parameters:nil success:^(id response) {
        
        NSDictionary * results = [response[@"results"] lastObject];
        //版本号
        NSString * verCode = results[@"version"];
        NSString * releaseNotes = results[@"releaseNotes"];
        //APP地址
        NSString * trackViewUrl = results[@"trackViewUrl"];
        YYLog(@"版本dic:%@",response);
        
        if ([appVersion compare:verCode options:NSNumericSearch] == NSOrderedAscending) {
            //有新版本
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"版本更新%@",verCode] message:releaseNotes preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //@"itms-apps://itunes.apple.com/cn/app/wang-yi-xin-wen-zui-you-tai/id425349261?mt=8"
                //@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=587767923"
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:trackViewUrl]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                }
            }]];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }

    } failure:^(NSError *error) {
        
        
    }];
    
    
}


/**
 *  检查登录密码是否更改了
 */
- (void)checkUserPassword {
    
    YYUser *user = [YYUser shareUser];
    if (user.isLogin) {//登录了再检测密码
        NSString *password = [SAMKeychain passwordForService:KEYCHAIN_SERVICE_LOGIN account:user.mobile];
        [YYLoginManager loginSucceedWithAccount:user.mobile password:password responseMsg:^(BOOL success) {
            if (success) {
                //登录成功,提醒操作，存储个人信息已在方法内部实现，这里只需要实现跳转登录界面等操作
                
            }else{
                
            }
        }];
    }
    
    
}


/**
 *  加载新版本特性
 */
- (void)launchNewVersion {
    
    YYLogFunc;
    NSString *appVersion = kAppVersion;
    NSString *lastAppVersion = [kUserDefaults objectForKey:LASTAPPVERSION];
    if (![appVersion isEqualToString:lastAppVersion]) {//比较两次的版本号不同
    
        //将最新版本的版本号写入用户偏好设置里
        [kUserDefaults setObject:appVersion forKey:LASTAPPVERSION];
        [kUserDefaults synchronize];
        //这是第一次启动APP
        new = [[YYNewVersionViewController alloc] init];
        new.view.frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT);
        [[[UIApplication sharedApplication].windows firstObject] addSubview:new.view];
        
    }

}


/**
 *  打开APP 刷新个人信息
 */
- (void)refreshUserInfo {
    
    YYUser *user = [YYUser shareUser];
    if (user.isLogin) {//登录了再刷新个人信息
        
        [YYLoginManager getUserInfo];
    }
}



@end
