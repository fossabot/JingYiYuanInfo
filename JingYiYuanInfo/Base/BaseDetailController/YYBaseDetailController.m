//
//  YYBaseDetailController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseDetailController.h"
#import "UIBarButtonItem+YYExtension.h"

@interface YYBaseDetailController ()

@end

@implementation YYBaseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *share = [UIBarButtonItem itemWithImage:@"share_32x32" highImage:@"share_32x32" target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = share;
    
    [self.view addSubview:self.wkWebview];
    
    if (_url) {
        
        NSURL *url = [NSURL URLWithString:self.url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.wkWebview loadRequest:request];
    }
}


- (WKWebView *)wkWebview {
    
    if (!_wkWebview) {
        _wkWebview = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebview.navigationDelegate = self;
        _wkWebview.UIDelegate = self;
    }
    return _wkWebview;
}


- (void)share {
    
}

@end
