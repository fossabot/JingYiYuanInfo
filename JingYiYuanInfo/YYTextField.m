//
//  YYTextField.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/7/26.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "YYTextField.h"

static NSString * const YYPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation YYTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:YYPlacerholderColorKeyPath];
    return [super becomeFirstResponder];

}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:YYPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}


@end
