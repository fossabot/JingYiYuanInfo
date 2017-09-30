//
//  YYThreeSeekBaseController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface YYThreeSeekBaseController : THBaseViewController

/** classid*/
@property (nonatomic, copy) NSString *classid;

/** fatherId*/
@property (nonatomic, assign) NSInteger fatherId;

/** 是否有banner （我们只认准国家认证的84家正规机构）*/
@property (nonatomic, assign) BOOL hasBanner;

@end
