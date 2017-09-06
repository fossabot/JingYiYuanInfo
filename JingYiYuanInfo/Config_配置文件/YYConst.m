//
//  YYConst.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 导航栏高度*/
CGFloat const YYNavgationBarH = 44.f;
/** 状态栏高度*/
CGFloat const YYStatusBarH = 20.f;
/** 底部tabbar高度*/
CGFloat const YYTabBarH = 49.0;
/** 顶部导航栏和状态栏的高度和*/
CGFloat const YYTopNaviHeight = 64.0;

/** 分页cell的tab高度*/
CGFloat const TabHeaderH = 40;


/** 新闻列表的第一个cell的标题字号*/
CGFloat const YYInfoCellTitleFont = 16;
/** 新闻列表的第一个cell的描述的字号*/
CGFloat const YYInfoCellDescFont = 14;
/** 新闻列表cell里面来源时间点击量的字号*/
CGFloat const YYInfoCellSubtitleFont = 12;


/** 新闻列表cell标题的高度*/
CGFloat const YYInfoCellTitleHeight = 30.f;
/** 新闻列表cell里面来源时间点击量的高度*/
CGFloat const YYInfoCellSubtitleHeight = 15.f;
/** 新闻列表cellimageView的高度*/
CGFloat const YYInfoCellBigImageViewHeight = 60.f;
/** 新闻列表小的cellimageView的高度*/
CGFloat const YYInfoCellMiniImageViewHeight = 30.f;
/** 新闻列表小的cellimageView的宽度*/
CGFloat const YYInfoCellMiniImageViewWidth = 45.f;


/** 新闻列表的通用间隙*/
CGFloat const YYInfoCellCommonMargin = 10.f;
/** 新闻列表副标题的文字间隔*/
CGFloat const YYInfoCellSubMargin = 5.f;


/** 音乐播放器的高度*/
CGFloat const YYInfoMusicPlayerHeight = 60.f;


/** 手机号长度*/
NSInteger const telephoneLength = 11;
/** 验证码长度*/
NSInteger const verificationLength = 6;


#pragma mark -----------------------  友盟分享的三方数据  -------------------------

/** 友盟APPKEY*/
NSString * const USHARE_APPKEY = @"595e0296b27b0a077f000674";

/** qq开放平台APPID 和 QQ互联的APPID一致*/
NSString * const QQ_APPID = @"1106083026";

/** qq开放平台APPKEY*/
NSString * const QQ_APPKEY = @"hL9J2bRjcsbTPpad";

/** 微信APPID*/
NSString * const WECHAT_APPID = @"wx11d19ee9062c616a";

/** 微信APPSECRET*/
NSString * const WECHAT_APPSECRET = @"f661786b2c7513137c04b8178b9d90ed";

/** 新浪APPID*/
NSString * const SINA_APPKEY = @"242133346";

/** 新浪APPSECRET*/
NSString * const SINA_APPSECRET = @"4f5fbcc22f6998670e806f3e87a7241a";


#pragma mark ------------------------  友盟推送   ----------------------------

/** 友盟推送 APPKEY*/
NSString * const UPUSH_APPKEY = @"595e0296b27b0a077f000674";

/** 友盟推送 APPSECRET*/
NSString * const UPUSH_APPSECRET = @"t6qxjcjxk2eug5p5loicscx2qztaidlp";


#pragma mark ----------------------  腾讯Bugly错误统计  --------------------------

/** 腾讯Bugly错误统计 APPID*/
NSString * const BUGLY_APPID = @"660117ce1d";

/** 腾讯Bugly错误统计 APPKEY*/
NSString * const BUGLY_APPKEY = @"937af888-4415-4931-9bee-ab4f2d8db41c";


#pragma mark ------------------------  钥匙串的Service ----------------------------

/** 保存密码的keychain Service*/
NSString * const KEYCHAIN_SERVICE_LOGIN = @"kerchain_service_login";


#pragma mark -----------------------------  网络变化的通知 -------------------

/** 网络变化*/
NSString * const kNetworkChangedNotification = @"kNetworkChangedNotification";


#pragma mark -----------------------------  常用的通知宏   -------------------------------

/** 重复点击tabbar的通知宏*/
NSString * const YYTabbarItemDidRepeatClickNotification = @"YYTabbarItemDidRepeatClickNotification";

/** 接收到远程消息的通知*/
NSString * const YYReceivedRemoteNotification = @"YYReceivedRemoteNotification";

/** 首页tableview上滑到顶部的通知*/
NSString * const YYMainVCGoTopNotificationName = @"YYMainVCGoTopNotificationName";

/** 首页tableview下滑离开顶部的通知*/
NSString * const YYMainVCLeaveTopNotificationName = @"YYMainVCLeaveTopNotificationName";

/** 用户单例类信息发生改变的通知  userInfo：{ @“loginStatus”:0 退出登录  1登录成功}*/
NSString * const YYUserInfoDidChangedNotification = @"YYUserInfoDidChangedNotification";

/** 首页刷新的通知  热搜榜和牛人榜接收通知刷新*/
NSString * const YYMainRefreshNotification = @"YYMainRefreshNotification";




