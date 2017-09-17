//
//  YYDetailViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYDetailViewController.h"

#import "YYPlaceHolderView.h"
#import "ShareView.h"

#import <WebKit/WebKit.h>

@interface YYDetailViewController ()<WKNavigationDelegate,UIScrollViewDelegate>

/** webview*/
@property (nonatomic,strong)  WKWebView *webview;

@end

static NSString * const YY_Net = @"www.yyinfo.com";

@implementation YYDetailViewController

#pragma mark -- lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    
    self.navigationItem.rightBarButtonItem = right;
    

    //
//    [self configShareUtils];
    //
    [self configWebview];
    [self.view addSubview:self.webview];
    
}

-(void)dealloc {
    //移除webview的加载进度监听
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark -- mannulMethods

/** 配置分享的按钮及相关方法*/
- (void)configShareUtils{
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:imageNamed(@"share_32x32") forState:UIControlStateNormal];
    [shareButton setImage:imageNamed(@"share_32x32") forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/** 配置WKWebview*/
- (void)configWebview {
    
    self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webview.navigationDelegate = self;
    self.webview.scrollView.delegate = self;
    self.webview.allowsBackForwardNavigationGestures = YES;
    
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
  

    // 使用KVO监听网页加载进度
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webview loadRequest:request];
    [self.view addSubview:self.webview];
    
}

/** 集成友盟分享*/
- (void)share{
    
    [ShareView shareWithTitle:@"壹元服务" subTitle:@"壹元服务为你服务" webUrl:@"www.baidu.com" imageUrl:nil isCollected:YES shareViewContain:ShareViewTypeQQ | ShareViewTypeFavor | ShareViewTypeWechat shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}


#pragma mark -- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        //用hud来显示进度条加载
        [SVProgressHUD showProgress:progress status:@"正在加载。。。"];
        if (progress == 1.0) {
            
            [SVProgressHUD dismiss];
        }
    }
}

#pragma mark -- WKWebviewDelegate

/**
 *  每当加载一个请求之前会调用该方法，通过该方法决定是否允许或取消请求的发送
 *
 *  @param navigationAction 导航动作对象
 *  @param decisionHandler  请求处理的决定
 */
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    // 获得协议头(可以自定义协议头，根据协议头判断是否要执行跳转)
    NSString *scheme = navigationAction.request.URL.scheme;
    if ([scheme isEqualToString:@"itheima"]) {
        // decisionHandler 对请求处理回调
        //WKNavigationActionPolicyCancel:取消请求
        //WKNavigationActionPolicyAllow:允许请求
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
//    if(webView != self.webview) {
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
//    UIApplication *app = [UIApplication sharedApplication];
//    NSURL *url = navigationAction.request.URL;
//    if ([url.scheme isEqualToString:@"tel"])
//    {
//        if ([app canOpenURL:url])
//        {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
//    if ([url.absoluteString containsString:@"ituns.apple.com"])
//    {
//        if ([app canOpenURL:url])
//        {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
    //新的本域名内的网页，直接跳转新的控制器，非本域名下的其他网页，则直接加载
    if ([navigationAction.request.URL.absoluteString containsString:YY_Net]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        //重新定向，push一个新的页面
        YYDetailViewController *detail = [[YYDetailViewController alloc] init];
        detail.url = navigationAction.request.URL.absoluteString;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

/**
 *  当开始发送请求时调用
 */
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    YYLog(@"开始加载网页--%s", __FUNCTION__);
    
    
}
/**
 *  当请求过程中出现错误时调用
 */
- (void)webView:(WKWebView*)webView didFailNavigation:(WKNavigation*)navigation withError:(NSError *)error {
    YYLog(@"加载网页失败---%@= %s",error, __FUNCTION__);
    [SVProgressHUD dismiss];
    //自定义的占位图片加载失败时展示，并且点击可重新加载网页
    [YYPlaceHolderView showInView:self.view image:@"" clickAction:^{
        [webView reload];
    } dismissAutomatically:YES];
    
}


/**
 *  当开始发送请求时出错调用
 */
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError *)error {
    YYLog(@"%@= %s",error, __FUNCTION__);
}


/**
 *  每当接收到服务器返回的数据时调用，通过该方法可以决定是否允许或取消导航
 */
- (void)webView:(WKWebView*)webView decidePolicyForNavigationResponse:(WKNavigationResponse*)navigationResponse decisionHandler:(void(^)(WKNavigationResponsePolicy))decisionHandler{
    //decisionHandler 对响应的处理
    //WKNavigationActionPolicyCancel:取消响应
    //WKNavigationActionPolicyAllow:允许响应
    decisionHandler(WKNavigationResponsePolicyAllow);
}


/**
 *  当收到服务器返回的受保护空间(证书)时调用
 *  @param challenge         安全质询-->包含受保护空间和证书
 *  @param completionHandler 完成回调-->告诉服务器如何处置证书
 */
- (void)webView:(WKWebView*)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullablecredential))completionHandler {
    // 创建凭据对象
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    // 告诉服务器信任证书
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}


/**
 *  当网页加载完毕时调用：该方法使用最频繁
 */
- (void)webView:(WKWebView*)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // js 代码
//    NSString *jsCode = [NSString stringWithFormat:@"window.location.href='#howtorecharge'"];
    // 可以在这个方法执行JS代码
//    [webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError* _Nullable error) {
//        YYLog(@"执行完毕JS代码");
//    }];
    
    //加载网页完毕，此时设置一下自身的相关属性
    self.navigationItem.title = webView.title;
    [SVProgressHUD dismiss];

}

@end
