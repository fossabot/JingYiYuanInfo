//
//  YYIntegrationRulesDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/26.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYIntegrationRulesDetailController.h"

@interface YYIntegrationRulesDetailController ()

@end

@implementation YYIntegrationRulesDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"积分规则";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

- (void)share {
    
    YYWeakSelf
    [ShareView shareWithTitle:self.navigationItem.title subTitle:@"" webUrl:self.url imageUrl:self.shareImgUrl isCollected:NO shareViewContain:nil shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
        switch (shareViewType) {
            case ShareViewTypeFont:{
                
                YYUser *user = [YYUser shareUser];
                [PageSlider showPageSliderWithCurrentPoint:user.currentPoint fontChanged:^(CGFloat rate) {
                    
                    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)(100*rate)];
                    [weakSelf.wkWebview evaluateJavaScript:js completionHandler:nil];
                }];
            }
                break;
                
            default:
                break;
        }

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
    YYUser *user = [YYUser shareUser];
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)user.webfont*100];
    [webView evaluateJavaScript:js completionHandler:nil];
    [SVProgressHUD dismiss];
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self showPlaceHolder];
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismiss];
}
@end
