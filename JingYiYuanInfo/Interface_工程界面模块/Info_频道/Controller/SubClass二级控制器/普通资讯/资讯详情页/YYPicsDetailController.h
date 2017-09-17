//
//  YYPicsDetailController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@class YYHotPicsModel;

@interface YYPicsDetailController : THBaseViewController

/** hotpicsModel*/
@property (nonatomic, strong) NSArray<YYHotPicsModel *> *picsModels;

@end
