//
//  YYPicsDetailController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

#define replaceUrl @"yyapp.YYHotPicsModel.com?id="

@class YYHotPicsModel;

@interface YYPicsDetailController : THBaseViewController

/** hotpicsModel*/
@property (nonatomic, strong) NSArray<YYHotPicsModel *> *picsModels;

/** shareUrl*/
@property (nonatomic, copy) NSString *shareUrl;

/** shareTitle*/
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareSubTitle;

/** shareImageUrl*/
@property (nonatomic, copy) NSString *shareImageUrl;

/** picsId*/
@property (nonatomic, copy) NSString *picsId;

@end
