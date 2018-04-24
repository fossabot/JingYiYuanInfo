//
//  YYBaseDetailController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

/** 
 
 YYUser *user = [YYUser shareUser];
 [PageSlider showPageSliderWithTotalPoint:4 currentPoint:[user currentPoint] pointNames:@[@"标准",@"大",@"极大",@"超级大"] fontChanged:^(CGFloat rate) {
 
 }];
 在点击字体按钮时方法调用
 然后在shareview 的回调方法获取点击的按钮是不是字体，从而修改当前详情页的字体
 */

#import "YYBaseDetailController.h"
#import "UIBarButtonItem+YYExtension.h"
//#import "YYPlaceHolderView.h"

@interface YYBaseDetailController ()

@end

@implementation YYBaseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *share = [UIBarButtonItem itemWithImage:@"share_32x32" highImage:@"share_32x32" target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = share;
    
    [self.view addSubview:self.wkWebview];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [self.wkWebview loadRequest:request];
 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}



- (WKWebView *)wkWebview {
    
    if (!_wkWebview) {
        _wkWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-64)];
        
        _wkWebview.navigationDelegate = self;
        _wkWebview.UIDelegate = self;
    }
    
    return _wkWebview;
}


/** 刷新webView*/
- (void)refreshWebView:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [self.wkWebview loadRequest:request];
}

- (void)share {
    
}

- (void)showPlaceHolder {
    
    YYWeakSelf
    [YYPlaceHolderView showInView:weakSelf.view image:emptyImageName clickAction:^{
        
        [weakSelf refreshWebView:nil];
    } dismissAutomatically:YES];
}


- (BAButton *)tipView{
    if (!_tipView) {
        _tipView = [BAButton creatButtonWithFrame:CGRectMake(0, 0, 160, 154) title:@"网络出错，点此重新加载" selTitle:@"网络出错，点此重新加载" titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:14] image:[UIImage imageNamed:@"yyfw_push_empty_112x94_"] selImage:[UIImage imageNamed:@"yyfw_push_empty_112x94_"] buttonPositionStyle:BAButtonPositionStyleTop target:self selector:@selector(refreshWebView:)];
        _tipView.hidden = YES;
        _tipView.yy_centerX = self.view.yy_centerX;
        _tipView.yy_centerY = self.view.yy_centerY-40;
        _tipView.padding = 20;
        [self.view addSubview:_tipView];
    }
    return _tipView;
}



@end
