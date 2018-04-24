//
//  UIAlertController+YYShortAlert.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/3/1.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "UIAlertController+YYShortAlert.h"

@implementation UIAlertController (YYShortAlert)


+ (instancetype)showAlertWithTitle:(NSString *)title subtitle:(NSString *)subtitle cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancel:(void (^)())cancel confirm:(void (^)())confirm {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subtitle preferredStyle:UIAlertControllerStyleAlert];

    if (confirmTitle.length) {
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            confirm();
        }];
        [alert addAction:confirmAction];
    }
    if (cancelTitle.length) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancel();
        }];
        [alert addAction:cancelAction];
    }
    
    return alert;
}

@end
