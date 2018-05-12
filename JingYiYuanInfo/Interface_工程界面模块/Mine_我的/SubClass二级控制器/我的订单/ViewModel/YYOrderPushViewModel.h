//
//  YYOrderPushViewModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/31.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseViewModel.h"

typedef void(^YanbaoBLock)(NSString *url);

typedef void(^RecordDetailBlock)(NSString *pushId);

@interface YYOrderPushViewModel : YYBaseViewModel

/** orderid*/
@property (nonatomic, copy) NSString *orderid;

/** block*/
@property (nonatomic, copy) YanbaoBLock yanbaoBlock;

@property (nonatomic, copy) RecordDetailBlock recordDetailBlock;

@end
