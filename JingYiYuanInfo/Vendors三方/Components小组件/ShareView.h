//
//  ShareView.h
//  分享面板定义
//
//  Created by VINCENT on 2017/7/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///封装的控件包含的字控件
typedef NS_OPTIONS(NSUInteger, ShareViewType){
   
    ShareViewTypeWechat         = 1 << 0,         //微信
    ShareViewTypeWechatTimeline = 1 << 1,    //朋友圈
    ShareViewTypeQQ             = 1 << 2,    //QQ
    ShareViewTypeQQZone         = 1 << 3,    //QQ空间
    ShareViewTypeMicroBlog      = 1 << 4,    //新浪微博
    ShareViewTypeCopyLink       = 1 << 5,    //复制链接
    ShareViewTypeFavor          = 1 << 6,    //收藏
    ShareViewTypeFont           = 1 << 7,    //字体大小
    ShareViewTypeNone           = 1 << 8     // 空

    
};


///分享内容的属性
typedef NS_ENUM(NSUInteger, ShareContentType) {
    
    ShareContentTypeWeb,                     //普通web链接
    ShareContentTypeMusic,                   //分享音乐
    ShareContentTypeImage,                   //分享图片
    ShareContentTypeVideo                    //分享视频
    
};


typedef void(^FinishedBlock)(ShareViewType shareViewType, BOOL isFavor);

@interface ShareView : UIView

/** 完成回调*/
@property (nonatomic, copy) FinishedBlock finishedBlock;


/**
 分享接口

 @param title 分享标题
 @param subTitle 分享描述
 @param webUrl 分享链接
 @param imageUrl 分享图片（无图片默认是logo）
 @param isCollected 收藏的状态
 @param shareViewType 分享的类型（网页、音乐、视频、图片）
 @param shareContentType 分享的平台（QQ、微信、微博、复制链接、收藏、更改字体、空（默认平台））
 @param finished 回调 （分享的平台ShareViewType，button的选中状态）
 */
+ (void)shareWithTitle:(NSString *)title subTitle:(NSString *)subTitle webUrl:(NSString *)webUrl imageUrl:(NSString *)imageUrl isCollected:(BOOL)isCollected shareViewContain:(ShareViewType)shareViewType shareContentType:(ShareContentType)shareContentType finished:(FinishedBlock)finished;


@end



@interface ShareModel : NSObject


@end










