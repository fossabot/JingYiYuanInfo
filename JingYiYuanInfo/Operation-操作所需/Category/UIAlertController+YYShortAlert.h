//
//  UIAlertController+YYShortAlert.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/3/1.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (YYShortAlert)


/**
 快捷的alert提示方法

 @param title 主标题
 @param subtitle 副标题
 @param cancelTitle 取消文字
 @param confirmTitle 确定文字
 @param cancel 取消回调
 @param confirm 确认回调
 @return 返回实例
 */
+ (instancetype)showAlertWithTitle:(NSString*)title subtitle:(NSString *)subtitle cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancel:(void(^)())cancel confirm:(void(^)())confirm;




@end
