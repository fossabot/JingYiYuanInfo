//
//  YYBackOrderController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/26.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseScrollViewController.h"

typedef void(^BackOrderSucceedBlock)(NSString *orderId);

@interface YYBackOrderController : THBaseScrollViewController

/** 发送终止服务的请求成功*/
@property (nonatomic, copy) BackOrderSucceedBlock backSucceedBlock;

/** orderId*/
@property (nonatomic, copy) NSString *orderId;

/** isNeverCommited 从未进行过申请退单，根据退单状态判断*/
@property (nonatomic, assign) BOOL isNeverCommited;

@end
