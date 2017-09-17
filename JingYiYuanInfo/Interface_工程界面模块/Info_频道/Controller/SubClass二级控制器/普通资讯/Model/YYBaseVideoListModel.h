//
//  YYBaseVideoListModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  视频列表的模型

#import <Foundation/Foundation.h>

@class YYBaseVideoModel;

@interface YYBaseVideoListModel : NSObject

/** v_arr*/
@property (nonatomic, strong) NSArray<YYBaseVideoModel *> *v_arr;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
