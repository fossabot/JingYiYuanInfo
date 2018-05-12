//
//  YYMineCollectionModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMineCollectionModel : NSObject

/** 
 "usercollect": [
 {
 "id": "62",
 "col_uid": "1499064765j6qavy",
 "col_img": "http://yyapp.1yuaninfo.com/app/houtai/uploads/image/20170920/1505894513.jpg",
 "col_title": "北京小户型新房价格上月重现涨势1",
 "col_id": "16426",
 "col_type": "1",
 "col_time": "2017-09-28 14:30:11",
 "col_state": "0",
 "col_deltime": null
 },
 */

/** collectionId 文章在收藏表的id*/
@property (nonatomic, copy) NSString *collectionId;

/** col_uid用户id*/
@property (nonatomic, copy) NSString *col_uid;

/** col_img标题图片*/
@property (nonatomic, copy) NSString *col_img;

/** col_title标题*/
@property (nonatomic, copy) NSString *col_title;

/** col_id 资讯的原始id*/
@property (nonatomic, copy) NSString *col_id;

/** col_type 类型:1资讯文章,2资讯视频 3牛人文章 4公社视频 5项目*/
@property (nonatomic, copy) NSString *col_type;

/** col_time*/
@property (nonatomic, copy) NSString *col_time;

/** webUrl*/
@property (nonatomic, copy) NSString *webUrl;

/** shareUrl*/
@property (nonatomic, copy) NSString *shareUrl;

/** newsType*/
@property (nonatomic, assign) NSInteger newsType;

@end
