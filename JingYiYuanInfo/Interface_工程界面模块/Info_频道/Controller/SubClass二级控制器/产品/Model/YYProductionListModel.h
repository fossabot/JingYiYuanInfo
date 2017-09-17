//
//  YYProductionListModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYProductionVIPModel;
@class YYProductionCommonModel;

@interface YYProductionListModel : NSObject

/** pro_arr*/
@property (nonatomic, strong) NSArray<YYProductionCommonModel *> *pro_arr;

/** vip*/
@property (nonatomic, strong) YYProductionVIPModel *vip;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
