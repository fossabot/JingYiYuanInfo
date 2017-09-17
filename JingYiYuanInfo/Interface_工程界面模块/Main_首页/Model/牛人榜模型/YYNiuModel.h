//
//  YYNiuModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  牛人榜模型

#import <Foundation/Foundation.h>

@class YYNiuManModel;
@class YYNiuArticleModel;

@interface YYNiuModel : NSObject

/** 牛人列表*/
@property (nonatomic, strong) NSArray<YYNiuManModel *> *niu_arr;

/** 牛人文章列表*/
@property (nonatomic, strong) NSArray<YYNiuArticleModel *> *niuart_arr;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
