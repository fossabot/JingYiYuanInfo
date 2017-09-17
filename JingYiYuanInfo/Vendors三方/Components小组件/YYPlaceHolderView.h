//
//  YYPlaceHolderView.h
//  壹元服务
//
//  Created by VINCENT on 2017/4/12.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  显示在View上 提醒无数据  点击图片可再次刷新，block回调刷新方法，刷新成功后获取数据再dismiss这个placeHolderView

#import <UIKit/UIKit.h>

@interface YYPlaceHolderView : UIView

/** 单例*/
+ (instancetype)sharedPlaceHolderView;


/**
 签到成功的提示跳转商城占位图

 @param integration 积分商城
 @param click 点击回调
 */
+ (void)showSignSuccessPlaceHolderWithIntegration:(NSString *)integration clickAction:(void (^)())click;



/**
 显示在View上，并且带有点击事件，block
 
 @param view 显示在View上
 @param imageName 图片名
 @param click 点击回调
 @param dismissAuto 是否自动点击回调后移除还是外部刷新后自己调用dismiss方法
 */
+ (void)showInView:(UIView *)view image:(NSString *)imageName clickAction:(void(^)())click dismissAutomatically:(BOOL)dismissAuto ;



@end
