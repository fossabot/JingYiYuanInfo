//
//  YYBaseMusicListModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYBaseMusicModel;

@interface YYBaseMusicListModel : NSObject

/** 音乐数组*/
@property (nonatomic, strong) NSArray<YYBaseMusicModel *> *m_arr;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
