//
//  YYSearchList.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYSearchModel;

@interface YYSearchList : NSObject

/** class*/
@property (nonatomic, copy) NSString *className;

/** classArr*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *subClasses;

/**
     [
         {
             "className": "房产",
             "subClasses": [
                             {
                                 "title": "第一条搜索标题",
                                 "desc": "第一条搜索的描述"
                             },
                             {
                                 "title": "第一条搜索标题",
                                 "desc": "第一条搜索的描述"
                             }
             ]
         },
         {
             "className": "房产",
             "subClasses": [
                             {
                                 "title": "第一条搜索标题",
                                 "desc": "第一条搜索的描述"
                             },
                             {
                                 "title": "第一条搜索标题",
                                 "desc": "第一条搜索的描述"
                             }
             ]
         }
     ]
 */

@end
