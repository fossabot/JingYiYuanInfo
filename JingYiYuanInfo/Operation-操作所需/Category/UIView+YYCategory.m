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
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(5.0f, 5.0f)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
}


- (void)cutRoundViewRadius:(CGFloat)radius {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}



/**
 cut一个已知约束的控件的圆角

 @param rect 控件的frame
 @param radius 圆角半径
 */
- (void)cutCornerRect:(CGRect)rect radius:(CGFloat)radius {
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    maskLayer.path = bezierPath.CGPath;
    [self.layer setMask:maskLayer];
}

@end
