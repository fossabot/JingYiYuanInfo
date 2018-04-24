//
//  YYNiuManController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/17.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YPTabBarController.h"
#import "YYNiuManModel.h"
#import "YYNiuSubscribeModel.h"

typedef void(^FocusChangedBlock)();

@interface YYNiuManController : YPTabBarController

/** niuManModel*/
@property (nonatomic, strong) YYNiuManModel *niuManModel;

/** niuManModel*/
@property (nonatomic, strong) YYNiuSubscribeModel *subscribleModel;

@property (nonatomic, copy) FocusChangedBlock focusChangedBlock;

@end
