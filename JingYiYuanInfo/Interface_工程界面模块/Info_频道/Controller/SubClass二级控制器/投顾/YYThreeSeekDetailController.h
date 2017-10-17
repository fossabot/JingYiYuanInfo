//
//  YYThreeSeekDetailController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@class YYCompanyModel;

@interface YYThreeSeekDetailController : THBaseViewController

/** comid公司的id*/
@property (nonatomic, copy) NSString *comid;

/** isScrollToProduct*/
@property (nonatomic, assign) BOOL isScrollToProduct;

@end
