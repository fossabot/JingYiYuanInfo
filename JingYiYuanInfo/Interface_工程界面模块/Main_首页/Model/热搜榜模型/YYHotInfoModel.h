//
//  YYHotInfoModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  热搜榜的资讯模型

#import <UIKit/UIKit.h>

@class YYHotPicsModel;

@interface YYHotInfoModel : NSObject

/** 
 "id": "17550",
 "title": "照烧汁香煎肉肠",
 "source": "壹元服务",
 "description": "",
 "picurl": "uploads/image/20170601/1496286466.png",
 "picarr": [],
 "posttime": "2017-06-01 09:29:46",
 "keywords": "1个标签",
 "picstate": "1"
 */


/** 资讯的id*/
@property (nonatomic, copy) NSString *infoid;

/** 资讯标题*/
@property (nonatomic, copy) NSString *title;

/** 资讯来源*/
@property (nonatomic, copy) NSString *source;

/** 资讯描述*/
@property (nonatomic, copy) NSString *infodescription;

/** 资讯图片地址*/
@property (nonatomic, copy) NSString *picurl;

/** 资讯图集*/
@property (nonatomic, strong) NSArray<YYHotPicsModel *> *picarr;

/** 资讯时间*/
@property (nonatomic, copy) NSString *posttime;

/** 资讯的一个标签*/
@property (nonatomic, copy) NSString *keywords;

/** 资讯的类型  1为左图，2为大图，3为三图，4为图集*/
@property (nonatomic, assign) NSInteger picstate;

/** 新闻详情页 webUrl*/
@property (nonatomic, copy) NSString *webUrl;

/** shareUrl*/
@property (nonatomic, copy) NSString *shareUrl;

/** cellHeight*/
@property (nonatomic, assign) CGFloat cellHeight;


@end
