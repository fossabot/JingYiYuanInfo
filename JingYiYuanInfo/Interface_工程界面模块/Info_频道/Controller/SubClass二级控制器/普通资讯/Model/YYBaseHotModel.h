//
//  YYBaseHotModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  频道普通资讯的排行模型

#import "YYBaseModel.h"

@interface YYBaseHotModel : YYBaseModel

//"id": "2",
//"self_name": "股市3",
//"self_link": "http://www.baidu.com",
//"pop_value": "321"


/** id*/
@property (nonatomic, copy) NSString *hotId;

/** 标题*/
@property (nonatomic, copy) NSString *self_name;

/** 网址*/
@property (nonatomic, copy) NSString *self_link;

/** 人气值*/
@property (nonatomic, copy) NSString *pop_value;


@end
