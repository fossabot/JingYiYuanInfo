//
//  YYProjectListModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYProjectModel;

@interface YYProjectListModel : NSObject

/** recommend*/
@property (nonatomic, strong) NSArray<YYProjectModel *> *recommend;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
