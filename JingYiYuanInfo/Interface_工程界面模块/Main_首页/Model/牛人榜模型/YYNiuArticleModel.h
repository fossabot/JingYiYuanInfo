//
//  YYNiuArticleModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  牛人文章模型

#import <Foundation/Foundation.h>

@interface YYNiuArticleModel : NSObject

/** 
 "id": "6",
 "niu_id": null,
 "title": "宝兰高铁通车运营 中国高铁实现",
 "source": "壹元服务",
 "author": "admin",
 "keywords": "西藏 拉萨",
 "description": "今天，从陕西宝鸡到甘肃兰州的宝兰高铁将正式通车运营。",
 "picurl": "uploads/image/20170710/1499655302.png",
 "posttime": "1499650846"
 */

/** 牛人文章id*/
@property (nonatomic, copy) NSString *art_id;

/** 牛人id*/
@property (nonatomic, copy) NSString *niu_id;

/** 牛人文章标题*/
@property (nonatomic, copy) NSString *title;

/** 牛人文章来源*/
@property (nonatomic, copy) NSString *source;

/** 牛人文章作者*/
@property (nonatomic, copy) NSString *author;

/** 牛人文章 标签 空格隔开*/
@property (nonatomic, copy) NSString *keywords;

/** 牛人文章描述*/
@property (nonatomic, copy) NSString *art_description;

/** 牛人文章图片*/
@property (nonatomic, copy) NSString *picurl;

/** 牛人文章添加时间*/
@property (nonatomic, copy) NSString *posttime;


@end
