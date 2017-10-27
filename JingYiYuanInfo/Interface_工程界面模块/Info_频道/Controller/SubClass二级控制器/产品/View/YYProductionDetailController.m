//
//  YYProductionDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  产品的详情，可购买

#import "YYProductionDetailController.h"
#import "YYIAPTool.h"

@interface YYProductionDetailController ()

/** buy*/
@property (nonatomic, strong) UIButton *buy;

@end

@implementation YYProductionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.view addSubview:self.buy];
    [self.buy makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

/** 购买会员*/
- (void)buyProduct:(UIButton *)sender {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    if (![user.groupid containsString:@"3"]) {
        [SVProgressHUD showInfoWithStatus:@"非会员用户不能购买该产品"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    [YYIAPTool buyProductByProductionId:self.productionId type:@"3"];
    
}

#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.wkWebview.frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight-50);
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    _buy.enabled = YES;
    [SVProgressHUD dismiss];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self showPlaceHolder];
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismiss];
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIButton *)buy{
    if (!_buy) {
        _buy = [UIButton buttonWithType:UIButtonTypeCustom];
        _buy.enabled = NO;
        [_buy setTitle:@"购买" forState:UIControlStateNormal];
        [_buy setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_buy setBackgroundColor:ThemeColor];
        [_buy addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buy;
}


@end
