//
//  YYProductionDetailController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseDetailController.h"

@interface YYProductionDetailController : YYBaseDetailController

@property (nonatomic, copy) NSString *productionId;
 
/** tip提示语*/
@property (nonatomic, copy) NSString *tip;

/** mobile*/
@property (nonatomic, copy) NSString *mobile;

@end
