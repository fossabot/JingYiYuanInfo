//
//  UIView+YYViewInWindow.m
//  壹元服务
//
//  Created by VINCENT on 2017/5/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "UIView+YYViewInWindow.h"

@implementation UIView (YYViewInWindow)

/** 判断self和anotherView是否重叠 */
- (BOOL)yy_intersectsWithAnotherView:(UIView *)anotherView
{
    
    //如果anotherView为nil，那么就代表keyWindow
    if (anotherView == nil) anotherView = [UIApplication sharedApplication].keyWindow;
    
    
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    
    CGRect anotherRect = [anotherView convertRect:anotherView.bounds toView:nil];
    
    //CGRectIntersectsRect是否有交叉
    return CGRectIntersectsRect(selfRect, anotherRect);
}

@end
