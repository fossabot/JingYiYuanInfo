//
//  YYCommunityMediaModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCommunityMediaModel : NSObject

/** 
 "id": "1328",
 "v_parid": null,
 "v_name": "大热天的就别再爆炒花蛤了，交给微波炉体验下最简单的极致美味",
 "v_picture": "uploads/image/20170725/1500947102.jpg",
 "v_hits": "69581",
 "v_time": "1:30",
 "v_url": "uploads/media/20170911/1505125821.flv",
 "v_tag": "热门",
 "v_source": " 罐头视频 ",
 "v_modtime": "2017-07-25 09:18:58",
 "v_sharUrl": null,
 "delstate": "false",
 "deltime": ""
 */


/** id*/
@property (nonatomic, copy) NSString *mediaId;

/** v_parid自媒体人id*/
@property (nonatomic, copy) NSString *v_parid;

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
