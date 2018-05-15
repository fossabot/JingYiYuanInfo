//
//  YYShowLikeModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYShowLikeModel : YYBaseModel

//"xh_arr" 喜欢的列表: [{
//   "id":         id         "301",
//   "actionname": 标题         "主课上午",
//   "palace":     地点         "北京天音",
//   "actiontime": 时间         "2017-09-06 11:40:22",
//   "indeximg":   图片         "uploads/image/20170906/1504671647.jpg",
//   "tag":                 null,
//   "price":      价格         "100元/张"}]


/** webUrl*/
@property (nonatomic, copy) NSString *webUrl;

/** id*/
@property (nonatomic, copy) NSString *likeId;

/** 标题*/
@property (nonatomic, copy) NSString *actionname;

/** 地点*/
@property (nonatomic, copy) NSString *palace;

/** 时间*/
@property (nonatomic, copy) NSString *actiontime;

/** tag*/
@property (nonatomic, copy) NSString *tag;

/** 图片*/
@property (nonatomic, copy) NSString *indeximg;

/** 价格*/
@property (nonatomic, copy) NSString *price;

@end
