//
//  YYConst.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>


/** 一年365会员的产品id*/
UIKIT_EXTERN NSString * const Production_VIP_1;




/** 导航栏高度*/
//UIKIT_EXTERN CGFloat const YYNavgationBarH;

/** 底部tabbar高度*/
//UIKIT_EXTERN CGFloat const YYTabBarH;
/** 顶部导航栏和状态栏的高度和*/
//UIKIT_EXTERN CGFloat const YYTopNaviHeight;

/** 分页cell的tab高度*/
UIKIT_EXTERN CGFloat const TabHeaderH;

/** 分页cell的tab高度*/
UIKIT_EXTERN CGFloat const ToolBarHeight;

/** 新闻列表的第一个cell的标题字号*/
UIKIT_EXTERN CGFloat const YYInfoCellTitleFont;
/** 新闻列表的第一个cell的描述的字号*/
UIKIT_EXTERN CGFloat const YYInfoCellDescFont;
/** 新闻列表cell里面来源时间点击量的字号*/
UIKIT_EXTERN CGFloat const YYInfoCellSubtitleFont;

/** 新闻列表cell标题的高度*/
UIKIT_EXTERN CGFloat const YYInfoCellTitleHeight;
/** 新闻列表cell里面来源时间点击量的高度*/
UIKIT_EXTERN CGFloat const YYInfoCellSubtitleHeight;
/** 新闻列表大的cellimageView的高度*/
UIKIT_EXTERN CGFloat const YYInfoCellBigImageViewHeight;
/** 新闻列表小的cellimageView的高度*/
UIKIT_EXTERN CGFloat const YYInfoCellMiniImageViewHeight;
/** 新闻列表小的cellimageView的宽度*/
UIKIT_EXTERN CGFloat const YYInfoCellMiniImageViewWidth;


/** 系统的cell左边分隔线的间距*/
UIKIT_EXTERN CGFloat const YYCommonCellLeftMargin;

UIKIT_EXTERN CGFloat const YYCommonCellRightMargin;

UIKIT_EXTERN CGFloat const YYCommonCellTopMargin;

UIKIT_EXTERN CGFloat const YYCommonCellBottomMargin;

/** 新闻列表的通用间隙*/
UIKIT_EXTERN CGFloat const YYInfoCellCommonMargin;
/** 新闻列表副标题的文字间隔*/
UIKIT_EXTERN CGFloat const YYInfoCellSubMargin;


/** 音乐播放器的高度*/
UIKIT_EXTERN CGFloat const YYInfoMusicPlayerHeight;

/** 手机号长度*/
UIKIT_EXTERN NSInteger const telephoneLength;
/** 验证码长度*/
UIKIT_EXTERN NSInteger const verificationLength;


#pragma mark -----------------------  友盟分享的三方数据  -------------------------

/** 友盟APPKEY*/
UIKIT_EXTERN NSString * const USHARE_APPKEY;

/** qq开放平台APPID 和 QQ互联的APPID一致*/
UIKIT_EXTERN NSString * const QQ_APPID;

/** qq开放平台APPKEY*/
UIKIT_EXTERN NSString * const QQ_APPKEY;

/** 微信APPID*/
UIKIT_EXTERN NSString * const WECHAT_APPID;

/** 微信APPSECRET*/
UIKIT_EXTERN NSString * const WECHAT_APPSECRET;

/** 新浪APPID*/
UIKIT_EXTERN NSString * const SINA_APPKEY;

/** 新浪APPSECRET*/
UIKIT_EXTERN NSString * const SINA_APPSECRET;


#pragma mark ------------------------  友盟推送   ----------------------------

/** 友盟推送 APPKEY*/
UIKIT_EXTERN NSString * const UPUSH_APPKEY;

/** 友盟推送 APPSECRET*/
UIKIT_EXTERN NSString * const UPUSH_APPSECRET;


#pragma mark ----------------------  腾讯Bugly错误统计  --------------------------

/** 腾讯Bugly错误统计 APPID*/
UIKIT_EXTERN NSString * const BUGLY_APPID;

/** 腾讯Bugly错误统计 APPKEY*/
UIKIT_EXTERN NSString * const BUGLY_APPKEY;

#pragma mark -----------------------------  钥匙串的Service -------------------

/** 保存密码的keychain Service*/
UIKIT_EXTERN NSString * const KEYCHAIN_SERVICE_LOGIN;

#pragma mark -----------------------------  网络变化的通知 -------------------

/** 网络变化*/
UIKIT_EXTERN NSString * const kNetworkChangedNotification;


#pragma mark ---------------------------  常用的通知宏  ----------------------



/** 重复点击tabbar的通知宏*/
UIKIT_EXTERN NSString * const YYTabbarItemDidRepeatClickNotification;

/** 接收到远程消息的通知*/
UIKIT_EXTERN NSString * const YYReceivedRemoteNotification;

/** 首页tableview上滑到顶部的通知*/
UIKIT_EXTERN NSString * const YYMainVCGoTopNotificationName;

/** 首页tableview下滑离开顶部的通知*/
UIKIT_EXTERN NSString * const YYMainVCLeaveTopNotificationName;

/** 用户单例类信息发生改变的通知*/
UIKIT_EXTERN NSString * const YYUserInfoDidChangedNotification;

/** 首页刷新的通知  热搜榜和牛人榜接收通知刷新*/
UIKIT_EXTERN NSString * const YYMainRefreshNotification;

/** 资讯视频播放控制器 划出当前窗口，重置player*/
UIKIT_EXTERN NSString * const YYInfoVideoResetPlayerNotification;

/** 资讯音乐播放控制器 划出当前窗口，重置player,停止播放*/
UIKIT_EXTERN NSString * const YYInfoMusicResetPlayerNotification;

/** 支付完成 返回上一界面的通知*/
UIKIT_EXTERN NSString * const YYIapSucceedNotification;


/** 资讯controller的类型枚举，不同类型请求数据参数不一致*/
typedef NS_ENUM(NSUInteger, YYInfoViewControllerType){
    
    YYInfoViewControllerTypeJijin      = 2,    //基金
    YYInfoViewControllerTypeGushi      = 3,    //股市
    YYInfoViewControllerTypeZhaiquan   = 4,    //债券
    YYInfoViewControllerTypeWaihui     = 5,    //外汇
    YYInfoViewControllerTypeQihuo      = 6,    //期货
    YYInfoViewControllerTypeDazong     = 7,    //大宗
    YYInfoViewControllerTypeHuangjin   = 8,    //黄金
    YYInfoViewControllerTypeBitecoin   = 9,    //比特币
    YYInfoViewControllerTypeYaowen     = 11,   //要闻
    YYInfoViewControllerTypeShizheng   = 12,   //时政
    YYInfoViewControllerTypeShehui     = 13,   //社会
    YYInfoViewControllerTypeGuoji      = 14,   //国际
    YYInfoViewControllerTypeJunshi     = 15,   //军事
    YYInfoViewControllerTypeJiaoyu     = 16,   //教育
    YYInfoViewControllerTypeKeji       = 17,   //科技
    YYInfoViewControllerTypeTiyu       = 18,   //体育
    YYInfoViewControllerTypeShipin     = 20,   //视频
    YYInfoViewControllerTypeDianying   = 21,   //电影
    YYInfoViewControllerTypeYinyue     = 22,   //音乐
    YYInfoViewControllerTypeYanchu     = 23,   //演出
    YYInfoViewControllerTypeYouxi      = 24,   //游戏
    YYInfoViewControllerTypeDuanzi     = 25,   //段子
    YYInfoViewControllerTypeShishang   = 26,   //时尚
    YYInfoViewControllerTypeMeishi     = 28,   //美食
    YYInfoViewControllerTypeJiankang   = 29,   //健康
    YYInfoViewControllerTypeJiaju      = 30,   //家居
    YYInfoViewControllerTypeGouwu      = 31,   //购物
    YYInfoViewControllerTypeLiren      = 32,   //丽人
    YYInfoViewControllerTypeQiche      = 33,   //汽车
    YYInfoViewControllerTypeLvyou      = 34,   //旅游
    YYInfoViewControllerTypeQinggan    = 35    //情感
    
};

