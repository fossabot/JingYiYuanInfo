//
//  YYMineLogOutHeaderView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

//#import "RTRootNavigationController.h"
#import "YYMineLogOutHeaderView.h"
#import "YYLoginViewController.h"
#import "YYSettingViewController.h"

#import "UIView+YYParentController.h"

@interface YYMineLogOutHeaderView()


@end

@implementation YYMineLogOutHeaderView

+ (instancetype)headerView {
    
    YYMineLogOutHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"YYMineLogOutHeaderXibView" owner:nil options:nil].firstObject;
    
    return headerView;
}



/** 登录方法  登录成功后换头部*/
- (IBAction)logIn:(id)sender {
   
    YYLoginViewController *logInVC = [[YYLoginViewController alloc] init];
    [[self parentViewController] presentViewController:logInVC animated:YES completion:nil];
}


/** 设置按钮,有些内容要判断登录状态才能进入*/
- (IBAction)setting:(id)sender {

    YYSettingViewController *setting = [[YYSettingViewController alloc] init];
    [[self parentNavigationController] pushViewController:setting animated:YES];
    
}

@end
