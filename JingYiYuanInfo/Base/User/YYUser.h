//
//  YYUser.h
//  壹元服务
//
//  Created by VINCENT on 2017/7/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  个人信息单例

#import <Foundation/Foundation.h>
#define setUpInfo @"setUpInfo"

@interface YYUser : NSObject

YYSingletonH(User)

/** userid用户id*/
@property (nonatomic, copy) NSString *userid;

/** 昵称*/
@property (nonatomic, copy) NSString *username;

/** 头像*/
@property (nonatomic, copy) NSString *avatar;

/** 手机也是登录账号*/
@property (nonatomic, copy) NSString *mobile;

/** 股龄*/
@property (nonatomic, copy) NSString *guling;

/** 资金*/
@property (nonatomic, copy) NSString *capital;

/** 邮箱*/
@property (nonatomic, copy) NSString *email;

/** QQ号绑定*/
@property (nonatomic, copy) NSString *qqnum;

/** 微信号绑定*/
@property (nonatomic, copy) NSString *weixin;

/** 微博号绑定*/
@property (nonatomic, copy) NSString *weibo;

/** 会员等级 会员级别 1未注册  2注册 3会员用户  3,4会员用户，并且买了其他特色服务（3之后可以跟好多数字，代表买的服务越多）*/
@property (nonatomic, copy) NSString *groupid;

/** 到期时间 */
@property (nonatomic, copy) NSString *expiretime;

/** 积分*/
@property (nonatomic, copy) NSString *integral;


#pragma mark ------------------    自定义的用户信息  ----------------------------


/** 登录状态isLogin*/
@property (nonatomic, assign) BOOL isLogin;

/** 字体大小*/
@property (nonatomic, assign) CGFloat webfont;

/** 字体大小（标准，大，超级大）*/
@property (nonatomic, copy) NSString *webFontStr;

/** wifi下播放*/
@property (nonatomic, assign) BOOL onlyWIFIPlay;

/** 签到天数  今天已签到返回真实签到天数  未签到返回0 则签到按钮状态自动变化*/
@property (nonatomic, assign) NSInteger signDays;

/** setUp*/
@property (nonatomic, copy) NSString *setUp;

/** deviceToken*/
@property (nonatomic, copy) NSString *deviceToken;

/**
 填充个人信息
 */
+ (void)configUserInfoWithDic:(NSDictionary *)infoDic;

/**
 用户登出，删除所有用户信息
 */
+ (void)logOut;

- (NSInteger)currentPoint;

@end
