//
//  YYBaseInfoDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  普通新闻资讯的详情页

#import "YYBaseInfoDetailController.h"
#import "ShareView.h"
#import "YYDetailToolBar.h"

@interface YYBaseInfoDetailController ()

@end

@implementation YYBaseInfoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)share {
    
    [ShareView shareWithTitle:self.navigationItem.title subTitle:@"" webUrl:self.url imageUrl:self.shareImgUrl isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog | ShareViewTypeFont | ShareViewTypeCopyLink shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}

#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    [SVProgressHUD dismiss];
    
    YYDetailToolBar *toolBar = [[YYDetailToolBar alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT-40, kSCREENWIDTH, 40)];
    toolBar.toolBarType = DetailToolBarTypeWriteComment | DetailToolBarTypeComment | DetailToolBarTypeFavor | DetailToolBarTypeShare;
    [self.view addSubview:toolBar];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismiss];
}

@end
