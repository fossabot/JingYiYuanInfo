//
//  YYNiuManIntroduceController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/17.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseScrollViewController.h"
//#import "THBaseViewController.h"
#import "YYNiuManModel.h"

@interface YYNiuManIntroduceController : THBaseScrollViewController

/** 牛人名称*/
@property (nonatomic, copy) NSString *niu_name;

/** 牛人介绍*/
@property (nonatomic, copy) NSString *niu_introduce;

/** 牛人图片*/
@property (nonatomic, copy) NSString *niu_img;

/** 牛人人气值*/
@property (nonatomic, copy) NSString *niu_pop;


@end
