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
#import "NSString+Base64.h"
#import "YYDataBaseTool.h"
#import "YYIapModel.h"

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
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    YYLog(@"path------%@",path);
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

    //刷新个人信息
    [self refreshUserInfo];
    
    [self launchNewVersion];
    
    //主页在没有return YES之前是不会初始化的  所以  推送通知只能存储在APPdelegate的属性里
    if (launchOptions) {//若果有launchOptions，说明有推送消息进来
        NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification) {
            self.remoteNotice = remoteNotification;
//            [self handleRemoteNotification:remoteNotification];
        }
    }
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //打开帧数监听，在statusbar上显示
//    [[JPFPSStatus sharedInstance] open];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    //打开监听Apple内购返回的receipt数据回调
    [self checkAllUnCompleteReceipt];

    YYUser *user = [YYUser shareUser];
    if (user.isLogin) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return YES;
    
}

- (void)handleRemoteNotification:(NSDictionary *)remoteNotice{
   
    YYLogFunc;
    if (kApplication.applicationState == UIApplicationStateActive) {//APP处于激活状态
        //APP在前台状态时，接收到信息，直接弹框提醒用户查看消息
        YYLog(@"UIApplicationStateActiveAPP在前台状态时");
        [kNotificationCenter postNotificationName:YYReceivedRemoteNotification object:nil userInfo:remoteNotice];
    }else if(kApplication.applicationState == UIApplicationStateInactive) {//调开通知栏，双击home键的任务栏状态，当前APP直接锁屏时的状态,  APP处于后台状态时 ，这里该直接跳转界面
        
        YYLog(@"UIApplicationStateInactive在未运行状态时");
        self.remoteNotice = remoteNotice;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [kNotificationCenter postNotificationName:YYReceivedRemoteNotification object:nil userInfo:remoteNotice];
        });
        
    }else if (kApplication.applicationState == UIApplicationStateBackground) {
        
        //APP处于后台状态，单击home键，唤起其他APP，被迫进入后台状态
        YYLog(@"UIApplicationStateBackground在后台状态时");
        [kNotificationCenter postNotificationName:YYReceivedRemoteNotification object:nil userInfo:remoteNotice];
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
    [UMessage setBadgeClear:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
//    self.remoteNotice = userInfo;
    [self handleRemoteNotification:userInfo];
    //APP未关闭时接收到远程消息
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    YYLog(@"DEVICETOKEN-------%@",deviceTokenStr);
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
    
    [YYLoginManager checkLogInOtherDevice];
    [YYLoginManager getUserInfo];
}

/** APP即将shut down*/
- (void)applicationWillTerminate:(UIApplication *)application {
    YYLogFunc;
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    
    YYUser *user = [YYUser shareUser];
    for (SKPaymentTransaction *trans in transactions) {
        
        switch (trans.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
            {
                YYLog(@"走了APPdelegate的支付成功回调");
                //支付完成，取消支付，数据库的的支付订单状态不改变，然后将receipt和其他数据发送给后台
                 NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                 NSString *receiptBase64 = [NSString base64StringFromData:receiptData length:[receiptData length]];
                //这里已完成交易，我必须存储交易凭证，并标记为与后台同步的状态，即未完成状态0，然后和后台同步信息
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = yyyyMMddHHmmss;
                NSString *now = [formatter stringFromDate:[NSDate date]];
                
                [[YYDataBaseTool sharedDataBaseTool] saveIapDataWithTransactionIdentifier:trans.transactionIdentifier productIdentifier:trans.payment.productIdentifier userid:user.userid receipt:receiptBase64 good_type:@"1" transactionDate:now rechargeDate:now state:0];
                [self sendReceiptToServer:receiptBase64 paymentTransaction:trans];
                
//                [[SKPaymentQueue defaultQueue] finishTransaction:trans];
                
            }
                break;
                
            case SKPaymentTransactionStatePurchasing:
            {
                //正在支付
                YYLog(@"正在支付");
            }
                break;
                
            case SKPaymentTransactionStateFailed:
            {
                //支付失败，取消支付，数据库无订单，因为没有在之前的交易中拿到receipt  不存储订单，存储订单是为了
                YYLog(@"支付失败，取消支付，将数据库的的支付订单删除掉");
                [self failedTransaction:trans];
            }
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                YYLog(@"已经购买过该商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:trans];//消耗型不支持恢复
                break;
                
            case SKPaymentTransactionStateDeferred:
            {
                //犹豫不决，未确定支付
                YYLog(@"犹豫不决，未确定支付");
            }
                break;
                
            default:
                break;
        }
    }
}


//交易成功的方法。交易成功跟后台验证，验证成功才能交这个交易在数据库中删除或者状态变为未完成 ，现在先验证transaction_id,查看后台是否有这条数据，返回 1已经完成订单 0未完成 继续下一步验证，第二步验证receipt，验证支付结果的有效性，
- (void)sendReceiptToServer:(NSString *)base64Str paymentTransaction:(SKPaymentTransaction *)paymentTransaction {
    
    BOOL dealState = [[YYDataBaseTool sharedDataBaseTool] checkTransactionDealState:paymentTransaction.transactionIdentifier];
    if (dealState) {
        YYLog(@"该transactionIdentifier交易单号已验证");
        [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
        return;
    }
    
    
    YYUser *user = [YYUser shareUser];
    /* 预验证，验证transactionID，交易订单号是否存在*/
    
    NSDictionary *checkPara = [NSDictionary dictionaryWithObjectsAndKeys:paymentTransaction.transactionIdentifier,@"transaction_id",user.userid,USERID, nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:preCheckTransactionIdUrl parameters:checkPara success:^(id response) {
        
        if (response) {
            if ([response[STATE] isEqualToString:@"1"]) {
                
                YYLog(@"订单已完成，为了应付重复验证");
                [[YYDataBaseTool sharedDataBaseTool] changeTransactionIdentifierState:paymentTransaction.transactionIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
            }else{
                
                [self checkReceipt:base64Str trans:paymentTransaction];
                YYLog(@"订单未完成，继续验证");
            }
        }
    } failure:^(NSError *error) {
        
        YYLog(@"error-------%@",error);
    } showSuccessMsg:nil];
    
    
}

/* 第二步验证  验证回执*/
- (void)checkReceipt:(NSString *)receipt trans:(SKPaymentTransaction *)paymentTransaction {
    
    YYUser *user = [YYUser shareUser];
    //    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:base64Str,@"name", nil];
    [YYHttpNetworkTool POSTRequestWithUrlstring:IAPReceiptUrl parameters:@{@"productid":paymentTransaction.payment.productIdentifier,USERID:user.userid,@"apple_receipt":receipt} success:^(id response) {
        
        if ([response[@"state"] isEqualToString:@"1"]) {
            YYLog(@"购买成功，并给后台同步返回成功验证");
            [[YYDataBaseTool sharedDataBaseTool] changeTransactionIdentifierState:paymentTransaction.transactionIdentifier];
            [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
        }
        
        [kNotificationCenter postNotificationName:YYIapSucceedNotification object:nil];
        YYLog(@"IAP收据验证%@",response);
    } failure:^(NSError *erro) {
        
//        [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
        YYLog(@"error : %@",erro);
    } showSuccessMsg:nil];
}




//交易失败的方法，结束交易
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if(transaction.error.code != SKErrorPaymentCancelled) {
        YYLog(@"购买失败");
    } else {
        YYLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}






//检查所有支付之后未同步的订单，并与后台同步
- (void)checkAllUnCompleteReceipt {
    
    NSMutableArray *allIapModels = [[YYDataBaseTool sharedDataBaseTool] getAllUnCompleteIap];
   
    if (allIapModels.count) {
        
        for (YYIapModel *model in allIapModels) {
            
            YYUser *user = [YYUser shareUser];
            /* 预验证，验证transactionID，交易订单号是否存在*/
            
            NSDictionary *checkPara = [NSDictionary dictionaryWithObjectsAndKeys:model.transactionIdentifier,@"transaction_id",user.userid,USERID, nil];
            
            [YYHttpNetworkTool GETRequestWithUrlstring:preCheckTransactionIdUrl parameters:checkPara success:^(id response) {
                
                if (response) {
                    if ([response[STATE] isEqualToString:@"1"]) {
                        
                        YYLog(@"订单已完成，为了应付重复验证");
                        [[YYDataBaseTool sharedDataBaseTool] changeTransactionIdentifierState:model.transactionIdentifier];
                    }else{
                        
                        
                        [YYHttpNetworkTool POSTRequestWithUrlstring:IAPReceiptUrl parameters:@{@"produtid":model.productIdentifier,USERID:model.userid,@"apple_receipt":model.receipt} success:^(id response) {
                            
                            if ([response[@"state"] isEqualToString:@"0"]) {
                                YYLog(@"购买成功，并给后台同步返回成功验证");
                                [[YYDataBaseTool sharedDataBaseTool] changeTransactionIdentifierState:model.transactionIdentifier];
                                [YYLoginManager getUserInfo];
                            }
                            
                            YYLog(@"IAP收据验证%@",response);
                        } failure:^(NSError *erro) {
                            
                            YYLog(@"error : %@",erro);
                        } showSuccessMsg:nil];
                        
                        YYLog(@"订单未完成，继续验证");
                        
                    }
                }
            } failure:^(NSError *error) {
                
            } showSuccessMsg:nil];

        }
    }else {
        YYLog(@"没有未同步的订单");
    }
}


@end
