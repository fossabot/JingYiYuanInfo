//
//  YYMessageSectionModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYMessageModel;

@interface YYMessageSectionModel : NSObject
/*
    返回值 [{"date":日期 "04月10日",
        //"info":相应日期的快讯数组 [{"id":快讯的id,拼接成链接 "5", "title":快讯的标题 "文字公告", "addtime":快讯添加的时间 "2017-04-10"}]}]
*/

/** 组日期*/
@property (nonatomic, copy) NSString *date;

/** 组列表数组*/
@property (nonatomic, strong) NSArray<YYMessageModel *> *info;

@end
