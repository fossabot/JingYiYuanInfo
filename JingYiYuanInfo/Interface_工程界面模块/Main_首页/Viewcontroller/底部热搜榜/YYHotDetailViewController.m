//
//  YYHotDetailViewController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/15.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotDetailViewController.h"

@interface YYHotDetailViewController ()

@end

@implementation YYHotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (void)share {
    
    YYWeakSelf
    [ShareView shareWithTitle:self.navigationItem.title subTitle:@"" webUrl:self.url imageUrl:self.shareImgUrl isCollected:NO shareViewContain:ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeMicroBlog shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
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


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    YYWeakSelf
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        weakSelf.navigationItem.title = title;
    }];
    YYUser *user = [YYUser shareUser];
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)user.webfont*100];
    [webView evaluateJavaScript:js completionHandler:nil];
    [SVProgressHUD dismiss];
    
    ZWHTMLOption *option = [[ZWHTMLOption alloc] init];
    option.filterURL = @[@"http://yyapp.1yuaninfo.com/app/yyfwapp/img/dianzan.png",@"http://yyapp.1yuaninfo.com/app/yyfwapp/img/shanchu.png"];
    option.getAllImageCoreJS = OPTION_DefaultCoreJS;
    self.htmlSDK = [ZWHTMLSDK zw_loadBridgeJSWebview:webView withOption:option];
    
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
    [self.htmlSDK zw_handlePreviewImageRequest:navigationAction.request];
    
}



-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self showPlaceHolder];
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismiss];
}





@end
