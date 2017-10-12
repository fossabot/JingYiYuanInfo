//
//  YYSearchSecModel.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYSearchModel;

@interface YYSearchSecModel : NSObject

//组头的名字
@property (nonatomic, copy) NSString *className;

//自定义搜索出来数据类型 1普通资讯文章  2资讯视频  3演出  4牛人观点  5项目  6三找
@property (nonatomic, assign) NSInteger classId;

/** 组数据的数组*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *models;



@end
