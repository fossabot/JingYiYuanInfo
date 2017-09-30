//
//  UIView+YYCategory.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "UIView+YYCategory.h"

@implementation UIView (YYCategory)

/// 切圆角 必须等View确定尺寸后才能切割  否则视图空白
- (void)cutRoundView {
    CGFloat corner = self.frame.size.width / 2;
    [self cutRoundViewRadius:corner];
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
//    shapeLayer.path = path.CGPath;
//    imageView.layer.mask = shapeLayer;
}


- (void)cutRoundViewRadius:(CGFloat)radius {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

@end
