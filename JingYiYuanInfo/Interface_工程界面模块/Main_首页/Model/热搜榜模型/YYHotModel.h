//
//  YYHotModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  热搜榜模型

#import "YYBaseModel.h"

@class YYHotTagModel;
@class YYHotHotModel;
@class YYHotInfoModel;

@interface YYHotModel : YYBaseModel

/** 标签数组模型*/
@property (nonatomic, strong) NSArray<YYHotTagModel *> *tag_arr;

/** 热搜排行数组模型*/
@property (nonatomic, strong) NSArray<YYHotHotModel *> *hot_arr;

/** 新闻资讯数组模型*/
@property (nonatomic, strong) NSArray<YYHotInfoModel *> *info_arr;

/** 请求更多数据时的参数lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
