//
//  YYUMShareManager.h
//  分享面板定义
//
//  Created by VINCENT on 2017/7/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>


@interface YYUMShareManager : NSObject



/**
 分享网页的接口

 @param weburl 网址
 @param title 标题
 @param desc 描述
 @param imageUrl 图片地址，没有回默认是logo
 @param umsocialType 分享的平台
 */
+ (void)shareWeburl:(NSString *)weburl title:(NSString *)title desc:(NSString *)desc thumbUrl:(NSString *)imageUrl platform:(UMSocialPlatformType)umsocialType completion:(void(^)(BOOL complete))complettion;

/**
 分享图片的接口

 @param imageName 图片名
 @param platformType 分享的平台
 */
+ (void)shareImage:(NSString *)imageName toPlatformType:(UMSocialPlatformType)platformType;



/**
 分享音乐的接口

 @param musicUrl 音乐链接
 @param title 标题
 @param desc 描述
 @param imageUrl 图片
 @param platformType 平台
 */
+ (void)shareMusic:(NSString *)musicUrl title:(NSString *)title desc:(NSString *)desc thumbUrl:(NSString *)imageUrl toPlatformType:(UMSocialPlatformType)platformType;



/**
 分享视频的接口

 @param videoUrl 视频地址
 @param title 标题
 @param desc 描述
 @param imageUrl 图片
 @param platformType 平台
 */
+ (void)shareVideo:(NSString *)videoUrl title:(NSString *)title desc:(NSString *)desc thumbUrl:(NSString *)imageUrl toPlatformType:(UMSocialPlatformType)platformType;

@end
