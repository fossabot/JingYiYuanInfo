//
//  YYVideoViewController.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface YYVideoDetailController : THBaseViewController


/** videoId*/
@property (nonatomic, copy) NSString *videoId;

/** videoURL*/
@property (nonatomic, strong) NSURL *videoURL;

/** 视频标题*/
@property (nonatomic, copy) NSString *videoTitle;

/** 视频图片占位图*/
@property (nonatomic, copy) NSString *placeHolderImageUrl;

/** seekTime*/
@property (nonatomic, assign) NSInteger seekTime;


@end
