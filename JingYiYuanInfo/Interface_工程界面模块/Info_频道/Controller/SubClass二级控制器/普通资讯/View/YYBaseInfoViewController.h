//
//  YYBaseInfoViewController.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  行情热点娱乐生活的基类

#import "THBaseViewController.h"
#import "YPTabBarController.h"

@interface YYBaseInfoViewController : THBaseViewController

/** classid*/
@property (nonatomic, copy) NSString *classid;

/** isHasBanner*/
@property (nonatomic, assign) BOOL isHasBanner;

@end


/// 资讯类包括一个头部（是否有Header--轮播，有的话还得有轮播的请求地址url，那么就还得有轮播的模型数组等等）、标题（title）、请求参数字典（para）、分类id（拼接在URL后面，请求相应的列表信息）、
