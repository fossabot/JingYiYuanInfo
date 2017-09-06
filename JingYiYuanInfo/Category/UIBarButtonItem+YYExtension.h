//
//  UIBarButtonItem+YYExtension.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
// 导航栏的耳目分类

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YYExtension)


/**
 设置导航栏的背景图片

 @param imageName 图片名
 @param target 控制器
 @param selector 执行方法
 @return  返回值
 */
+ (instancetype)setNavigationBarBackGroundImgName:(NSString*)imageName target:(UIViewController *)target selector:(SEL)selector;



/**
 设置耳目的图片及相关点击事件

 @param image 普通状态下的图片
 @param highImage 高亮状态下的图片
 @param target 监听器
 @param action 方法
 @return 返回这个耳目
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
