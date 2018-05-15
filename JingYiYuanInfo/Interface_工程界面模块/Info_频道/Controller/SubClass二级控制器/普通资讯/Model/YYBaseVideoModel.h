//
//  YYBaseVideoModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYBaseVideoModel : YYBaseModel

//返回值: "v_arr":视频数组 { id: "1341", "v_name": 视频标题, "v_picture": 视频图片拼接, "v_hits": "点击量, "v_time": 时长, "v_url": 视频地址需拼接"uploads/media/20170906/1504696315.mp4", "v_tag": 视频标签空格隔开, "v_source": 视频来源, "v_modtime": 视频添加时间"2017-09-06 17:21:51", "v_sharUrl": 分享视频的地址, "delstate": "false", "deltime": ""}    lastid : 加载更多时的id

/** id*/
@property (nonatomic, copy) NSString *videoId;

/** 视频标题*/
@property (nonatomic, copy) NSString *v_name;

/** 视频图片*/
@property (nonatomic, copy) NSString *v_picture;

/** 点击量*/
@property (nonatomic, copy) NSString *v_hits;

/** 时长*/
@property (nonatomic, copy) NSString *v_time;

/** 视频地址需拼接*/
@property (nonatomic, copy) NSString *v_url;

/** 视频标签空格隔开*/
@property (nonatomic, copy) NSString *v_tag;

/** 视频来源*/
@property (nonatomic, copy) NSString *v_source;

/** 视频添加时间*/
@property (nonatomic, copy) NSString *v_modtime;

/** 分享视频的地址*/
@property (nonatomic, copy) NSString *v_sharUrl;


@end
