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

/** 推送消息保存在APPdelegate的单例属性里  主页直接调用该属性，用完要置nil*/
@property (nonatomic, strong) NSDictionary *remoteNotice;

@end

