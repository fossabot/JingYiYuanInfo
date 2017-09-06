//
//  UIView+YYParentController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "UIView+YYParentController.h"

@implementation UIView (YYParentController)

- (UIViewController *)parentViewController {
    
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}


- (UINavigationController *)parentNavigationController {
    
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
