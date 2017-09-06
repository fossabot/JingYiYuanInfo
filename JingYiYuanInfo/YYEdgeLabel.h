//
//  YYEdgeLabel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYEdgeLabel : UILabel

/** 内边距*/
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

+ (instancetype)edgeInsetLabelWithTitle:(NSString *)title
                             titleColor:(UIColor *)titleColor
                             edgeInsets:(UIEdgeInsets)edgeInsets
                            borderColor:(UIColor *)borderColor
                            borderWidth:(CGFloat)borderWidth
                               fontSize:(CGFloat)fontSize
                           maskToBounds:(BOOL)maskToBounds
                           cornerRadius:(CGFloat)cornerRadius;



@end
