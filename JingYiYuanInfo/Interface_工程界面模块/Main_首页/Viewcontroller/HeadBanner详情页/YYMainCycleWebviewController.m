//
//  YYMainCycleWebviewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainCycleWebviewController.h"

@interface YYMainCycleWebviewController ()<WKNavigationDelegate,WKUIDelegate>

/** title*/
@property (nonatomic, copy) NSString *urlTitle;

@end

@implementation YYMainCycleWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configWebview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)configWebview {
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    // 自适应屏幕宽度js
    
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    // 添加自适应屏幕宽度js调用的方法
    WKUserContentController *wkController = [[WKUserContentController alloc] init];
    [wkController addUserScript:wkUserScript];
    wkWebConfig.userContentController = wkController;
    
    
}

/**
 *  分享按钮
 */
- (void)share {
    
    [ShareView shareWithTitle:self.urlTitle subTitle:@"" webUrl:self.url imageUrl:self.imgUrl isCollected:NO shareViewContain:ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeMicroBlog shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
        
    }];
}


#pragma mark ------- wkwebview 代理区域 -------------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    [SVProgressHUD dismiss];
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismiss];
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------


@end
