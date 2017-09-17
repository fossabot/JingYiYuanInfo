//
//  YYBaseDetailController.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "ShareView.h"
#import <WebKit/WebKit.h>

@interface YYBaseDetailController : THBaseViewController<WKNavigationDelegate,WKUIDelegate>

/** webview详情页的url*/
@property (nonatomic, copy) NSString *url;

/** 文章的id*/
@property (nonatomic, copy) NSString *artId;

/** 分类的id*/
@property (nonatomic, copy) NSString *classId;

/** 分享的图片*/
@property (nonatomic, strong) NSString *shareImgUrl;

/** webview*/
@property (nonatomic, strong) WKWebView *wkWebview;

/**
 *  分享方法
 */
- (void)share;

@end
