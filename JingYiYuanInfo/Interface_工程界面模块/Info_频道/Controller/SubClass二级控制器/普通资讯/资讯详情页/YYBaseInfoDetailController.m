//
//  YYBaseInfoDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  普通新闻资讯的详情页

#import "YYBaseInfoDetailController.h"
#import "ShareView.h"
#import "YYDetailToolBar.h"
#import "UIViewController+BackButtonHandler.h"

#define ViewWidth self.view.bounds.size.width
#define ViewHeight self.view.bounds.size.height

@interface YYBaseInfoDetailController ()<YYDetailToolBarDelegate>

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

/** state*/
@property (nonatomic, assign) BOOL state;

/** collectionId*/
@property (nonatomic, copy) NSString *collectionId;

@end

@implementation YYBaseInfoDetailController
{
    BOOL _canRemoveToolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    YYLog(@"viewHeight : %lf",ViewHeight);
    
    
    [self.view addSubview:self.toolBar];
//    self.toolBar.hidden = YES;
    
    self.toolBar.sendCommentBlock = ^(NSString *comment) {
      
        YYLog(@"发送评论 --- %@",comment);
    };
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _canRemoveToolBar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //为了让父类调用
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_canRemoveToolBar) {
        
        [self.toolBar removeFromSuperview];
        self.toolBar = nil;
    }
}

#pragma mark -- BackButtonHandlerProtocol  ------------
/** 拦截返回按钮的点击事件和pop手势的返回事件*/
-(BOOL)navigationShouldPopOnBackButton{

    //手势为完成就回调，如果用户取消手势返回，则必须在-viewDidDisappear:处理能确定用户已pop返回
    //相关逻辑处理
    _canRemoveToolBar = YES;
    [SVProgressHUD dismiss];
    return YES;
}




#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)share {
    
    YYWeakSelf
    [ShareView shareWithTitle:self.navigationItem.title subTitle:@"" webUrl:self.url imageUrl:self.shareImgUrl isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog | ShareViewTypeFont | ShareViewTypeCopyLink shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
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
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.wkWebview.frame = CGRectMake(0, 0, ViewWidth, ViewHeight-40);
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    YYWeakSelf
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        weakSelf.navigationItem.title = title;
    }];
    YYUser *user = [YYUser shareUser];
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)user.webfont*100];
    [webView evaluateJavaScript:js completionHandler:nil];
    [SVProgressHUD dismiss];
    self.toolBar.transform = CGAffineTransformMakeTranslation(0, -40);
    [self checkCollectState];
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {

    [self showPlaceHolder];

//    self.tipView.hidden = NO;
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismissWithDelay:1];
    
}

#pragma mark -------  YYDetailToolBarDelegate -----------------------

- (void)detailToolBar:(YYDetailToolBar *)toolBar didSelectBarType:(DetailToolBarType)barType {
    
    switch (barType) {

            case DetailToolBarTypeComment:{

                //跳转评论列表
            }
                break;

            case DetailToolBarTypeFavor:{

                //调用收藏接口
                if (self.state == YES) {
                    
                    [self collectOrNot:NO];
                }else {
                    [self collectOrNot:YES];
                }
            }
                break;

            case DetailToolBarTypeShare:{

                [self share];
            }
                break;
                
            default:
                break;
    }

}

/** 查询项目的收藏状态*/
- (void)checkCollectState {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        return;
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"collectstate",@"act",self.newsId,@"id",@"1",@"col_type",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:collectionUrl parameters:para success:^(id response) {
        
        if (response) {
            if ([response[@"state"] isEqualToString:@"0"]) {
                self.state = NO;
                YYLog(@"没收藏该项目");
            }else {
                self.state = YES;
                self.collectionId = response[@"state"];
                [self.toolBar setIsFavor:YES];
            }
        }
        
    } failure:^(NSError *error) {
        
        YYLog(@"查询失败");
    } showSuccessMsg:nil];
}

/** 收藏或者取消  yes代表要收藏  no代表取消*/
- (void)collectOrNot:(BOOL)collect {
    
    YYUser *user = [YYUser shareUser];
    
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    NSDictionary *para = nil;
    if (!collect) {//取消收藏
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"del",@"act",self.collectionId,@"colid",user.userid,USERID, nil];
    }else{//收藏
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"add",@"act",self.newsId,@"arid",@"1",@"type",user.userid,USERID, nil];
    }
    
    [YYHttpNetworkTool GETRequestWithUrlstring:collectionUrl parameters:para success:^(id response) {
        
        if (response && ![response[@"state"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:collect ? @"收藏成功" : @"取消收藏"];
            self.state = collect;
            [self.toolBar setIsFavor:collect];
        }else {
            [SVProgressHUD showErrorWithStatus:@"网络不佳"];
        }
        [SVProgressHUD dismissWithDelay:1];
    } failure:^(NSError *error) {
        
        
    } showSuccessMsg:nil];
    
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------


- (YYDetailToolBar *)toolBar {
    
    if (!_toolBar) {
        _toolBar = [[YYDetailToolBar alloc] initWithFrame:CGRectMake(0, ViewHeight-YYTopNaviHeight, ViewWidth, 40)];
        _toolBar.toolBarType = DetailToolBarTypeWriteComment | DetailToolBarTypeComment | DetailToolBarTypeFavor | DetailToolBarTypeShare;
        
        _toolBar.delegate = self;
//        YYWeakSelf
//        _toolBar.selectBlock = ^(DetailToolBarType toolBarType) {
//          
//            switch (toolBarType) {
//                    
//                case DetailToolBarTypeComment:{
//                 
//                    //跳转评论列表
//                }
//                    break;
//                
//                case DetailToolBarTypeFavor:{
//                 
//                    //调用收藏接口
//                }
//                    break;
//                    
//                case DetailToolBarTypeShare:{
//                 
//                    [weakSelf share];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//        };

    
    }
    return _toolBar;
}

@end
