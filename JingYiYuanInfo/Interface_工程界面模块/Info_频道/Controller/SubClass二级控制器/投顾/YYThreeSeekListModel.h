//
//  YYThreeSeekListModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYCompanyModel;

@interface YYThreeSeekListModel : NSObject

/** recommend推荐数组*/
@property (nonatomic, strong) NSMutableArray<YYCompanyModel *> *recommend;

/** other其他数组*/
@property (nonatomic, strong) NSMutableArray<YYCompanyModel *> *other;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
