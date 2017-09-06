//
//  UIView+YYParentController.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YYParentController)

/**
 *  获取下一个控制器
 */
- (UIViewController *)parentViewController;

/**
 *  获取导航控制器
 */
- (UINavigationController *)parentNavigationController;

@end
