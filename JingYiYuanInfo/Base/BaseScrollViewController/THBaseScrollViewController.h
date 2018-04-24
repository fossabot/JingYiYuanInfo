//
//  THBaseScrollViewController.h
//  基类封装
//
//  Created by VINCENT on 2017/6/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface THBaseScrollViewController : THBaseViewController

/** scrollView*/
@property (nonatomic, strong) UIScrollView *baseScrollView;

/** 固定scrollView的宽度*/
@property (nonatomic, assign) CGFloat stableWidth;

@end
