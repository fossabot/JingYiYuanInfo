//
//  YYBaseInfoModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYHotInfoModel;
@class YYBaseHotModel;

@interface YYBaseInfoModel : NSObject

/** 资讯数组模型*/
@property (nonatomic, strong) NSArray<YYHotInfoModel *> *hangqing;

/** 排行数组*/
@property (nonatomic, strong) NSArray<YYBaseHotModel *> *rank_arr;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
