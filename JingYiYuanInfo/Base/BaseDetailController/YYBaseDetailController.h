//
//  YYBaseDetailController.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "ShareView.h"
#import "YYPlaceHolderView.h"
#import "BAButton.h"
#import <WebKit/WebKit.h>
#import "PageSlider.h"

@interface YYBaseDetailController : THBaseViewController<WKNavigationDelegate,WKUIDelegate>

/** webview详情页的url*/
@property (nonatomic, copy) NSString *url;

/** 文章的id*/
@property (nonatomic, copy) NSString *artId;

/** 分类的id*/
@property (nonatomic, copy) NSString *classId;

/** 分享的图片*/
@property (nonatomic, strong) NSString *shareImgUrl;

/** 分享的副标题*/
@property (nonatomic, strong) NSString *subTitle;

/** webview*/
@property (nonatomic, strong) WKWebView *wkWebview;

/** tipView*/
@property (nonatomic, strong) BAButton *tipView;

/**
 *  分享方法
 */
- (void)share;

/** 显示webview的占位图*/
- (void)showPlaceHolder;

/** 刷新webView*/
- (void)refreshWebView:(UIButton *)sender;

@end
