//
//  AppDelegate.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,SKPaymentTransactionObserver>

@property (strong, nonatomic) UIWindow *window;

/** 推送消息保存在APPdelegate的单例属性里  主页直接调用该属性，用完要置nil 这个属性用来区分是前台状态时（弹框）还是其他状态（不弹框）  ps：只针对普通新闻详情*/
@property (nonatomic, strong) NSDictionary *remoteNotice;

@end

