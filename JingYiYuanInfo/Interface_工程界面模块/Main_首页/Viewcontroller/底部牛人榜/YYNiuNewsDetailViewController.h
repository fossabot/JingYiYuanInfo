//
//  YYNiuNewsDetailViewController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseDetailController.h"

@interface YYNiuNewsDetailViewController : YYBaseDetailController

/** niuNewsId*/
@property (nonatomic, copy) NSString *niuNewsId;

/* 牛人的id*/
@property (nonatomic, copy) NSString *niuId;

@property (nonatomic, copy) NSString *newsTitle;

@end
