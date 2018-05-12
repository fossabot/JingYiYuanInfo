//
//  YYPushRereadController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/5/8.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPushRereadController.h"
#import <WebKit/WebKit.h>
#import "YYUser.h"

@interface YYPushRereadController ()<WKUIDelegate,WKNavigationDelegate>

/** wkWebview*/
@property (nonatomic, strong) WKWebView *wkWebview;

@end

@implementation YYPushRereadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.wkWebview];
    [self.wkWebview makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    NSURL *url = [NSURL URLWithString:self.url];
    [self.wkWebview loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    self.wkWebview.frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight);
    
//    YYWeakSelf
//    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
//        weakSelf.navigationItem.title = title;
//    }];
    YYUser *user = [YYUser shareUser];
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)user.webfont*100];
    [webView evaluateJavaScript:js completionHandler:nil];
    [SVProgressHUD dismiss];
    
}


-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
//    [self showPlaceHolder];
    
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismissWithDelay:1];
    
}

#pragma mark -------  getter

- (WKWebView *)wkWebview {
    
    if (!_wkWebview) {
        _wkWebview = [[WKWebView alloc] init];
//                      WithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-64-40)];
        _wkWebview.navigationDelegate = self;
        _wkWebview.UIDelegate = self;
    }
    return _wkWebview;
}

@end
