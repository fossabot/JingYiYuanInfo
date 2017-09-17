//
//  YYBaseMusicModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYBaseMusicModel : NSObject

//返回值: "m_arr":音乐数组 { "id": "254",
//"picurl":  音乐图片 "uploads/image/20170906/1504667396.jpg",
//"hits": 音乐点击量 "180",
//"sname": 歌曲名 "33",
//"singer": 歌手名 "444",
//"URL": 音乐地址  "uploads/media/20170906/1504675826.mp3",
//"posttime": 时间 "2017-09-06 11:01:49",
//"delstate": "false",
//"deltime": ""}
//lastid : 加载更多时的id

/** id*/
@property (nonatomic, copy) NSString *musicId;

/** picurl音乐图片*/
@property (nonatomic, copy) NSString *picurl;

/** hits音乐点击量*/
@property (nonatomic, copy) NSString *hits;

/** sname歌曲名 */
@property (nonatomic, copy) NSString *sname;

/** singer歌手名*/
@property (nonatomic, copy) NSString *singer;

/** URL音乐地址 需拼接*/
@property (nonatomic, copy) NSString *URL;

/** posttime时间*/
@property (nonatomic, copy) NSString *posttime;



@end
