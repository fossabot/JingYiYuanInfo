//
//  YYMusicPlayerView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class YYBaseMusicModel;

@interface YYMusicPlayerView : UIView

/** musicModel*/
@property (nonatomic, strong) YYBaseMusicModel *musicModel;

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) AVPlayer *player;

//http://yyapp.1yuaninfo.com/app/houtai/uploads\/media\/20170906\/1504675826.mp3

/** 暂停音乐播放器*/
- (void)playerPause;

/** 强制改变音乐播放器的状态*/
- (void)forcePlayerPause;

@end
