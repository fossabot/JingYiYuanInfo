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
#import "YYCommentView.h"
#import "UIViewController+BackButtonHandler.h"

#import "YYCommentModel.h"
#import "YYCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import <MJExtension/MJExtension.h>

#import "YYFirstCommentController.h"
#import "YYSecondCommentController.h"

#define ViewWidth self.view.bounds.size.width
#define ViewHeight self.view.bounds.size.height

@interface YYBaseInfoDetailController ()<YYDetailToolBarDelegate,UITableViewDelegate,UITableViewDataSource>

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

/** 收藏状态state*/
@property (nonatomic, assign) BOOL state;

/** collectionId*/
@property (nonatomic, copy) NSString *collectionId;



@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation YYBaseInfoDetailController
{
    BOOL _canRemoveToolBar;
    NSString *_commentStr;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    YYLog(@"viewHeight : %lf",ViewHeight);
    
    [self loadComment];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    
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


/* 加载评论数据*/
- (void)loadComment {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"first",@"act",self.newsId,@"articleid",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        if (response) {
            
            self.dataSource = [YYCommentModel mj_objectArrayWithKeyValuesArray:response[@"first_comment"]];
            
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}

/* 点赞的回调*/
- (void)zan:(YYCommentModel *)model zanState:(BOOL)zanState {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = nil;
    if (zanState) {//cell回调返回要点赞还是取消的状态  yes点赞  no取消
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"addlike",@"act",@"0",@"comment",model.commentid,@"commentid",user.userid,USERID, nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"dellike",@"act",@"0",@"comment",model.commentid,@"commentid",user.userid,USERID, nil];
    }
    
    // comment  0一级评论 1回复评论
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        if (response) {//1成功0失败
            NSString *state = response[STATE];
            if ([state isEqualToString:@"1"]) {
                
                NSString *tip = zanState ? @"点赞成功" : @"取消点赞";
                YYLog(@"%@",tip);
            }else {
                NSString *tip = zanState ? @"点赞失败" : @"取消点赞失败";
                YYLog(@"%@",tip);
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}

/* 回复评论的回调*/
- (void)writeComment:(YYCommentModel *)model {
    

    YYUser *user = [YYUser shareUser];
    YYCommentView *commmentView = [[YYCommentView alloc] init];
    commmentView.placeHolder = [NSString stringWithFormat:@"回复%@",model.username];
    commmentView.commentBlock = ^(NSString *comment) {
        
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"addcomment",@"act",@"1",@"comment",self.newsId,@"articleid",user.userid,USERID,comment,@"reply_msg",model.commentid,@"comment_id",model.userid,@"to_user_id",model.username,@"to_user_name",user.avatar,@"user_avatar", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
            
            if (response) {//state  1成功0失败
                
                if ([response[STATE] isEqualToString:@"1"]) {
                    
                    YYLog(@"回复一级评论成功");
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                }else {
                    
                    YYLog(@"回复一级评论失败");
                    [SVProgressHUD showErrorWithStatus:@"服务器繁忙！稍后再试"];
                }
                
                [SVProgressHUD dismissWithDelay:1];
            }
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
    };
    [commmentView show];
    
}

/* 评论文章*/
- (void)commentToArticle:(NSString *)commentStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = yyyyMMddHHmmss;
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"addcomment",@"act",@"0",@"comment",self.newsId,@"articleid",user.userid,USERID,commentStr,@"reply_msg", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        if (response) {//state  1成功0失败
            
            if ([response[STATE] isEqualToString:@"1"]) {
                YYLog(@"评论文章成功");
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                
                YYCommentModel *model = [[YYCommentModel alloc] init];
                model.zan_count = @"0";
                model.avatar = user.avatar;
                model.username = user.username;
                model.userid = user.userid;
                model.reply_msg = commentStr;
                model.create_date = now;
                model.flag = @"0";
                [self.dataSource insertObject:model atIndex:0];
                NSIndexPath *indexPath0 = [NSIndexPath  indexPathForRow:0 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath0] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                
                YYLog(@"评论文章失败");
                [SVProgressHUD showErrorWithStatus:@"服务器繁忙！稍后再试"];
            }
            
            [SVProgressHUD dismissWithDelay:1];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];

}

#pragma mark tableview 代理方法  ---------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCommentModel *model = self.dataSource[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:YYCommentCellId cacheByIndexPath:indexPath configuration:^(YYCommentCell *cell) {
        
        cell.model = model;
    }];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.wkWebview.scrollView.scrollEnabled = NO;
    [self.wkWebview removeFromSuperview];
    return self.wkWebview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.wkWebview.yy_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYLog(@"选中了cell  ---  %ld",indexPath.row);
    
    YYCommentModel *model = self.dataSource[indexPath.row];
    YYSecondCommentController *secCommentVc = [[YYSecondCommentController alloc] init];
    secCommentVc.commentid = model.commentid;
    secCommentVc.newsId = self.newsId;
    secCommentVc.firstCommentModel = model;
    [self.navigationController pushViewController:secCommentVc animated:YES];
}

#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCommentModel *model = self.dataSource[indexPath.row];
    YYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:YYCommentCellId];
    YYWeakSelf
    cell.zanBlock = ^(id data, YYCommentCell *cell, BOOL zanState) {
        
        YYCommentModel *commentModel = (YYCommentModel *)data;
        [weakSelf zan:commentModel zanState:zanState];
    };
    
    cell.feedBackBlock = ^(id data){
        
        YYCommentModel *commentModel = (YYCommentModel *)data;
        [weakSelf writeComment:commentModel];
    };
    
    cell.model = model;
    return cell;
}


#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
   
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    self.wkWebview.frame = CGRectMake(0, 0, ViewWidth, ViewHeight-ToolBarHeight);
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    YYWeakSelf
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        weakSelf.navigationItem.title = title;
    }];
    YYUser *user = [YYUser shareUser];
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)user.webfont*100];
    [webView evaluateJavaScript:js completionHandler:nil];
    [SVProgressHUD dismiss];
    self.toolBar.transform = CGAffineTransformMakeTranslation(0, -ToolBarHeight);
    [self checkCollectState];
//    if (self.dataSource) {
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable result,NSError *_Nullable error) {
        
        YYLog(@"result   ---   %lf",[result floatValue]);
        //获取页面高度，并重置webview的frame
        
//        weakSelf.wkWebview.yy_height = [result floatValue];
        YYLog(@"webview 高度 ---  %lf",weakSelf.wkWebview.yy_height);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.wkWebview.yy_height = weakSelf.wkWebview.scrollView.contentSize.height;
            [weakSelf.tableView reloadData];
        });
    }];
    
//    }
   
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    
//    NSURL *URL = navigationAction.request.URL;
//    NSString *scheme = [URL scheme];
//    UIApplication *app = [UIApplication sharedApplication];
//    // 打电话
//    if ([scheme isEqualToString:@"tel"]) {
//        if ([app canOpenURL:URL]) {
//            [app openURL:URL];
//            // 一定要加上这句,否则会打开新页面
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
//    // 打开appstore
//    if ([URL.absoluteString containsString:@"ituns.apple.com"]) {
//        if ([app canOpenURL:URL]) {
//            [app openURL:URL];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
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
                YYFirstCommentController *firstCommentVc = [[YYFirstCommentController alloc] init];
                firstCommentVc.newsId = self.newsId;
                firstCommentVc.hotDataSource = self.dataSource;
                [self.navigationController pushViewController:firstCommentVc animated:YES];
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
            if (collect) {
                self.collectionId = response[@"state"];
            }
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
        
        _toolBar = [[YYDetailToolBar alloc] initWithFrame:CGRectMake(0, ViewHeight-YYTopNaviHeight, ViewWidth, ToolBarHeight)];
        _toolBar.toolBarType = DetailToolBarTypeWriteComment | DetailToolBarTypeComment | DetailToolBarTypeFavor | DetailToolBarTypeShare;
        
        _toolBar.delegate = self;
        YYWeakSelf
        _toolBar.sendCommentBlock = ^(NSString *comment) {
            
            [weakSelf commentToArticle:comment];
        };
    }
    return _toolBar;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, ToolBarHeight, 0);
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YYCommentCell class] forCellReuseIdentifier:YYCommentCellId];
        
    }
    return _tableView;
}



@end
