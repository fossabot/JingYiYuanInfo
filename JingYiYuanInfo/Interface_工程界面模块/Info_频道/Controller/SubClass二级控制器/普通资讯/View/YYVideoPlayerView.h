//
//  YYVideoPlayerView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Back)();

typedef void(^Share)();

@interface YYVideoPlayerView : UIView

/** videoURL*/
@property (nonatomic, strong) NSURL *videoURL;

/** 视频标题*/
@property (nonatomic, copy) NSString *videoTitle;

/** 视频图片占位图*/
@property (nonatomic, copy) NSString *placeHolderImageUrl;

/** seekTime*/
@property (nonatomic, assign) NSInteger seekTime;

/** back*/
@property (nonatomic, copy) Back backBlock;

/** 分享*/
@property (nonatomic, copy) Share shareBlock;

/** 当控制器推出其他界面，调用此方法暂停播放*/
- (void)pauseWhenPushOrPresent;

/** 当控制器从其他界面pop回来，调用此方法播放*/
- (void)playWhenPop;

/**
 *  播放视频
 */
- (void)play;


/**
 *  切换视频
 */
- (void)changePlayItem;


@end
