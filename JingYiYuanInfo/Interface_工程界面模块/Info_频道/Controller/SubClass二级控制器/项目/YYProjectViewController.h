//
//  YYProjectViewController.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  项目控制器

#import "YPTabBarController.h"

@interface YYProjectViewController : YPTabBarController

/** datas*/
@property (nonatomic, strong) NSArray *datas;

/** fatherId*/
@property (nonatomic, assign) NSInteger fatherId;

@end
