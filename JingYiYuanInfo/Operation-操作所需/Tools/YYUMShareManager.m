//
//  YYUMShareManager.m
//  分享面板定义
//
//  Created by VINCENT on 2017/7/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYUMShareManager.h"

@implementation YYUMShareManager


/**
 分享网页的接口
 
 @param weburl 网址
 @param title 标题
 @param desc 描述
 @param imageUrl 图片地址，没有回默认是logo
 @param umsocialType 分享的平台
 */

+ (void)shareWeburl:(NSString *)weburl title:(NSString *)title desc:(NSString *)desc thumbUrl:(NSString *)imageUrl platform:(UMSocialPlatformType)umsocialType {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:nil];
    if ([imageUrl isEqualToString:@"logo"]) {
        UIImage *image = [UIImage imageNamed:imageUrl];
        [shareObject setThumbImage:image];
    }else {
        [shareObject setThumbImage:imageUrl];
    }
    //设置网页地址
    shareObject.webpageUrl = weburl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:umsocialType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            YYLog(@"************ 分享网页错误 ************");
        }else{
            if ([result isKindOfClass:[UMSocialResponse class]]) {
                UMSocialShareResponse *response = result;
                YYLog(@"************ 友盟分享返回的信息 ：%@",response.message);
                YYLog(@"************ 第三方原始的返回信息 ：%@",response.originalResponse);
            }else{
                YYLog(@"************ 返回的全部数据 ： %@",result);
            }
        }
    }];
}



/**
 分享图片的接口
 
 @param imageUrl 图片名
 @param platformType 分享的平台
 */

+ (void)shareImage:(NSString *)imageUrl toPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    
    if ([imageUrl isEqualToString:@"logo"]) {
        UIImage *image = [UIImage imageNamed:imageUrl];
        [shareObject setShareImage:image];
    }else {
        [shareObject setShareImage:imageUrl];
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            YYLog(@"************ 分享图片错误 %@*********",error);
        }else{
            if ([result isKindOfClass:[UMSocialResponse class]]) {
                UMSocialShareResponse *response = result;
                YYLog(@"************ 友盟分享返回的信息 ：%@",response.message);
                YYLog(@"************ 第三方原始的返回信息 ：%@",response.originalResponse);
            }else{
                YYLog(@"************ 返回的全部数据 ： %@",result);
            }
        }
    }];

}



/**
 分享音乐的接口
 
 @param musicUrl 音乐链接
 @param title 标题
 @param desc 描述
 @param imageUrl 图片
 @param platformType 平台
 */
+ (void)shareMusic:(NSString *)musicUrl title:(NSString *)title desc:(NSString *)desc thumbUrl:(NSString *)imageUrl toPlatformType:(UMSocialPlatformType)platformType {
#warning    分享音乐啦啦啦啦啦啦啦啦
    YYLog(@"分享音乐啦啦啦啦啦啦啦啦");
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建音乐内容对象
    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:desc thumImage:nil];
    if ([imageUrl isEqualToString:@"logo"]) {
        UIImage *image = [UIImage imageNamed:imageUrl];
        [shareObject setThumbImage:image];
    }else {
        [shareObject setThumbImage:imageUrl];
    }
    
    //设置音乐网页播放地址
    shareObject.musicUrl = musicUrl;
    //这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持,微信、QQ微博都支持）
//    shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            YYLog(@"************ 分享音乐错误 %@*********",error);
        }else{
            if ([result isKindOfClass:[UMSocialResponse class]]) {
                UMSocialShareResponse *response = result;
                YYLog(@"************ 友盟分享返回的信息 ：%@",response.message);
                YYLog(@"************ 第三方原始的返回信息 ：%@",response.originalResponse);
            }else{
                YYLog(@"************ 返回的全部数据 ： %@",result);
            }        }
    }];
    
}



/**
 分享视频的接口
 
 @param videoUrl 视频地址
 @param title 标题
 @param desc 描述
 @param imageUrl 图片
 @param platformType 平台
 */
+ (void)shareVideo:(NSString *)videoUrl title:(NSString *)title desc:(NSString *)desc thumbUrl:(NSString *)imageUrl toPlatformType:(UMSocialPlatformType)platformType {
    
    YYLog(@"分享视频啦啦啦啦啦啦啦啦");
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:desc thumImage:nil];
    if ([imageUrl isEqualToString:@"logo"]) {
        UIImage *image = [UIImage imageNamed:imageUrl];
        [shareObject setThumbImage:image];
    }else {
        [shareObject setThumbImage:imageUrl];
    }
    
    //设置视频网页播放地址
    shareObject.videoUrl = videoUrl;
    
    //这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持,微信、QQ微博都支持）
//    shareObject.videoStreamUrl = @"";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            YYLog(@"************ 分享视频错误 %@*********",error);
        }else{
            if ([result isKindOfClass:[UMSocialResponse class]]) {
                UMSocialShareResponse *response = result;
                YYLog(@"************ 友盟分享返回的信息 ：%@",response.message);
                YYLog(@"************ 第三方原始的返回信息 ：%@",response.originalResponse);
            }else{
                YYLog(@"************ 返回的全部数据 ： %@",result);
            }        }
    }];
    
}

@end
