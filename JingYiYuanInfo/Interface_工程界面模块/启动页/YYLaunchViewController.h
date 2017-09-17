//
//  YYLaunchViewController.h
//  壹元服务
//
//  Created by VINCENT on 2017/7/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.

//  在启动后用户最先看到的那个控制器界面添加这个控制器的View到keywindow上，默认是不会自动隐藏自己的，循环播放，3s后显示进入应用按钮，设置自动隐藏后，不会出现进入应用按钮，播放完毕，自动进入主页

#import "THBaseViewController.h"

typedef void(^EnterMainBlock)();

@interface YYLaunchViewController : THBaseViewController

/** enter main block*/
@property (nonatomic, copy) EnterMainBlock enterMainBlock;

/** 自动remove*/
@property (nonatomic, assign) BOOL autoRemoveSelf;


/**
 初始动画，播放本地的MP4文件

 @param url [nsbundle mainbundle] pathforresource:...]
 url = [nsurl fileurlforpath:.....]
 */
- (id)initWithVideoUrl:(NSURL *)url;


- (id)initWithGif:(NSString *)gifName;


- (id)initWithGifs:(NSArray *)gifNames;

@end
