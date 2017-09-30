//
//  YYShowOtherDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  演出其他推荐和banner的详情页

#import "YYShowOtherDetailController.h"

@interface YYShowOtherDetailController ()

@end

@implementation YYShowOtherDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}



- (void)share {
    
    [ShareView shareWithTitle:self.title subTitle:@"" webUrl:self.url imageUrl:self.shareImgUrl isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog | ShareViewTypeFont | ShareViewTypeCopyLink shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
        
    }];
}




#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    YYWeakSelf
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        weakSelf.navigationItem.title = title;
    }];
    [SVProgressHUD dismiss];
//    self.toolBar.hidden = NO;
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
//    YYWeakSelf
//    [YYPlaceHolderView showInView:self.view image:@"yyfw_push_empty_112x94_" clickAction:^{
//        
//        [weakSelf.wkWebview reload];
//    } dismissAutomatically:YES];
    
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismissWithDelay:1];
    
}


@end
