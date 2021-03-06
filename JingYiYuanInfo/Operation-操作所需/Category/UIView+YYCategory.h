//
//  UIView+YYCategory.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YYCategory)

/// 切成圆形 必须等View确定尺寸后才能切割  否则视图空白
- (void)cutRoundView;

/// 切圆角 必须等View确定尺寸后才能切割  否则视图空白
- (void)cutRoundViewRadius:(CGFloat)radius;

/**
 cut一个已知约束的控件的圆角
 
 @param rect 控件的frame
 @param radius 圆角半径
 */
- (void)cutCornerRect:(CGRect)rect radius:(CGFloat)radius;


@end

