//
//  UIView+YYViewFrame.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YYViewFrame)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat yy_x;

@property (nonatomic, assign) CGFloat yy_y;

@property (nonatomic, assign) CGFloat yy_width;

@property (nonatomic, assign) CGFloat yy_height;

@property (nonatomic, assign) CGPoint yy_origin;

@property (nonatomic, assign) CGSize yy_size;

@property (nonatomic, assign) CGPoint yy_center;

@property (nonatomic, assign) CGFloat yy_centerX;

@property (nonatomic, assign) CGFloat yy_centerY;

/** 当View从xib边加载的时候，直接调用该方法可直接返回实力对象*/
+ (instancetype)viewFromXib;

@end
