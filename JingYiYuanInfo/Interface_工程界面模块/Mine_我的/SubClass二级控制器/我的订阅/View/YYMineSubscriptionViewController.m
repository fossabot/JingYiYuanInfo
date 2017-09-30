//
//  YYMineSubscriptionViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/6/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineSubscriptionViewController.h"

@interface YYMineSubscriptionViewController ()

@end

@implementation YYMineSubscriptionViewController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

@end
