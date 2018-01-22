//
//  UITextField+LeftView.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "UITextField+LeftView.h"

@implementation UITextField (LeftView)


- (void)setLeftViewWithImage:(NSString *)imageName {
    UIImage *image = imageNamed(imageName);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 40, 30);
    self.leftViewMode = UITextFieldViewModeAlways;
    [self setLeftView:imageView];
}

- (void)setLeftTitle:(NSString *)title {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [title stringByAppendingString:@": "];
    titleLabel.font = TitleFont;
    titleLabel.textColor = BlackColor;
    titleLabel.textAlignment = NSTextAlignmentRight;
    [titleLabel sizeToFit];
    self.leftViewMode = UITextFieldViewModeAlways;
    [self setLeftView:titleLabel];
}


@end
