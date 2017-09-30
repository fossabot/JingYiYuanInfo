//
//  YYMainScrollPicDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainScrollPicDetailController.h"
#import "YYDetailToolBar.h"
@interface YYMainScrollPicDetailController ()

@end

@implementation YYMainScrollPicDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

/**
 *  分享
 */
- (void)share {
    
    [ShareView shareWithTitle:self.navigationItem.title subTitle:@"" webUrl:self.url imageUrl:nil isCollected:NO shareViewContain:nil shareContentType:nil finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
    
}



#pragma mark -------  webview  代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    [SVProgressHUD dismiss];
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self showPlaceHolder];
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismiss];
}



@end
