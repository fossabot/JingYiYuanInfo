//
//  YYHotHotModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  热搜榜 排行 模型

#import "YYBaseModel.h"
#import "MJExtension.h"

@interface YYHotHotModel : YYBaseModel
/**
 *   "rname": "壹元服务一块钱",
 *   "rlink": "http://www.1yuaninfo.com",
 *   "pop_num": "1111"
 */

/** 热搜词条名称*/
@property (nonatomic, copy) NSString *rname;

/** 热搜词条链接*/
@property (nonatomic, copy) NSString *rlink;

/** 热搜词条人气值*/
@property (nonatomic, copy) NSString *pop_num;


@end
