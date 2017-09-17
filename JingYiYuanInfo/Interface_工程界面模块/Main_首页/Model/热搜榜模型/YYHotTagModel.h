//
//  YYHotTagModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  热搜中标签的模型 

#import <Foundation/Foundation.h>

@interface YYHotTagModel : NSObject

/** 
 "id": "28",
 "classname": "美食"
 */

/** 标签的id*/
@property (nonatomic, copy) NSString *tagid;

/** 标签类名称*/
@property (nonatomic, copy) NSString *classname;


@end
