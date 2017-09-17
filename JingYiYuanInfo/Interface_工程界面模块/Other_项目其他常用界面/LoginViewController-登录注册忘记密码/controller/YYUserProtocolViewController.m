//
//  YYUserProtocolViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYUserProtocolViewController.h"

@interface YYUserProtocolViewController ()

/** webView*/
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YYUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 64)];
    header.backgroundColor = ThemeColor;
    [self.view addSubview:header];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeCustom];
    [exit setImage:imageNamed(@"login_close_32x32") forState:UIControlStateNormal];
    exit.frame = CGRectMake(10, 27, 30, 30);
    [exit addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:exit];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, kSCREENWIDTH-120, 44)];
    title.text = @"用户协议";
    title.font = sysFont(15);
    title.textColor = [UIColor whiteColor];
    [header addSubview:title];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kSCREENWIDTH, kSCREENHEIGHT-64)];
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:userProtocolUrl]];
    [self.webView loadRequest:request];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
