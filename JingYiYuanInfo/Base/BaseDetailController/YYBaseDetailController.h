//
//  YYBaseDetailController.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import <WebKit/WebKit.h>

@interface YYBaseDetailController : THBaseViewController

/** webview详情页的url*/
@property (nonatomic, copy) NSString *url;

/** webview*/
@property (nonatomic, strong) WKWebView *wkWebview;

@end
