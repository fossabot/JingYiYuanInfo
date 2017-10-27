//
//  THBaseViewController.m
//  基类封装
//
//  Created by VINCENT on 2017/6/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "UIImage+Category.h"

@interface THBaseViewController ()

@end

@implementation THBaseViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置controller的主题色，未设置时默认白色
    self.view.backgroundColor = GrayBackGroundColor;
    
    //设置navigation的背景色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:ThemeColor] forBarMetrics:UIBarMetricsDefault];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
