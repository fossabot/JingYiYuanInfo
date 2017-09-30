//
//  YYUserIconCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYUserIconCell.h"
#import "UIView+YYCategory.h"

@implementation YYUserIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.icon cutRoundView];
//    [self cutRoundView:self.icon.imageView];
}

// 切圆角
- (void)cutRoundView:(UIImageView *)imageView
{
    CGFloat corner = imageView.frame.size.width / 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}


/** 修改个人头像*/
- (IBAction)changeIcon:(UIButton *)sender {
    
    if (self.iconBlock) {
        self.iconBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
