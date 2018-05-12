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
#import "THBaseTableView.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIAlertController+YYShortAlert.h"

#import "YYCommentModel.h"
#import "YYCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import <MJExtension/MJExtension.h>

#import "YYFirstCommentController.h"
#import "YYSecondCommentController.h"

@interface YYBaseInfoDetailController ()<YYDetailToolBarDelegate,UITableViewDelegate,UITableViewDataSource>

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

/** 收藏状态state*/
@property (nonatomic, assign) BOOL state;

/** collectionId*/
@property (nonatomic, copy) NSString *collectionId;



@property (nonatomic, strong) THBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

/** iamges*/
@property (nonatomic, strong) NSMutableArray *imagesArr;

/** bgView*/
@property (nonatomic, strong) UIScrollView *bgView;

@end

@implementation YYBaseInfoDetailController
{
    BOOL _canRemoveToolBar;
    NSString *_commentStr;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
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
    [ShareView shareWithTitle:self.navigationItem.title subTitle:self.subTitle webUrl:self.shareUrl imageUrl:self.shareImgUrl isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog | ShareViewTypeFont | ShareViewTypeCopyLink shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
        switch (shareViewType) {
            case ShareViewTypeFont:{
             
                YYUser *user = [YYUser shareUser];
                [PageSlider showPageSliderWithCurrentPoint:user.currentPoint fontChanged:^(CGFloat rate) {
                   
                    YYLog(@"webview改变之前的高度 ---  %lf",weakSelf.wkWebview.yy_height);
                    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(long)(100*rate)];
                    [weakSelf.wkWebview evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                        
                        YYLog(@"webview改变之后的高度 ---  %lf",weakSelf.wkWebview.scrollView.contentSize.height);
                    }];
                    
                    
                    [weakSelf.wkWebview evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable result,NSError *_Nullable error) {
                        
                        YYLog(@"webview测量js值得到的高度   ---   %lf",[result floatValue]);
                        //获取页面高度，并重置webview的高度
                        weakSelf.wkWebview.yy_height = [result floatValue];
                        [weakSelf.tableView reloadData];

                    }];
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
                model.commentid = response[@"id"];
                model.zan_count = @"0";
                model.avatar = user.avatar;
                model.username = user.username;
                model.userid = user.userid;
                model.reply_msg = commentStr;
                model.create_date = now;
                model.flag = @"0";
                [self.dataSource addObject:model];
                NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
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
    YYUser *user = [YYUser shareUser];
    //调整字体大小
    //document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)user.webfont*100];
    [self.wkWebview evaluateJavaScript:js completionHandler:nil];
//    if (!self.wkWebview.isLoading) {
//        [self.wkWebview reload];
//    }
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    self.wkWebview.frame = CGRectMake(0, 0, ViewWidth, ViewHeight-ToolBarHeight);
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    YYWeakSelf
    YYUser *user = [YYUser shareUser];
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(long)(100*user.webfont)];
    [webView evaluateJavaScript:js completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        weakSelf.navigationItem.title = title;
    }];
    
    [SVProgressHUD dismiss];
    self.toolBar.transform = CGAffineTransformMakeTranslation(0, -ToolBarHeight);
    [self checkCollectState];
    
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable result,NSError *_Nullable error) {
        
        YYLog(@"result   ---   %lf",[result floatValue]);
        //获取页面高度，并重置webview的frame
    
        YYLog(@"webview 高度 ---  %lf",weakSelf.wkWebview.yy_height);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.wkWebview.yy_height = weakSelf.wkWebview.scrollView.contentSize.height;
            [weakSelf.tableView reloadData];
            
        });
    }];
    
    ZWHTMLOption *option = [[ZWHTMLOption alloc] init];
    http://yyapp.1yuaninfo.com/app/yyfwapp/img/dianzan.png
    option.filterURL = @[@"http://yyapp.1yuaninfo.com/app/yyfwapp/img/dianzan.png",@"http://yyapp.1yuaninfo.com/app/yyfwapp/img/shanchu.png",@"http://yyapp.1yuaninfo.com/app/yyfwapp/img/dianzan-cur.png"];
    option.getAllImageCoreJS = OPTION_DefaultCoreJS;
    self.htmlSDK = [ZWHTMLSDK zw_loadBridgeJSWebview:webView withOption:option];
    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSString *requestString = [[navigationAction.request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
//    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
//        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
//        if (self.bgView) {
//            //设置不隐藏，还原放大缩小，显示图片
//            self.bgView.hidden = NO;
//            NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
//            int i = [imageIndex.lastObject intValue];
//            [self.bgView setContentOffset:CGPointMake(kSCREENWIDTH *i, 0)];
//        }else{
//            [self showBigImage:imageUrl];//创建视图并显示图片
//        }
//
//    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    [self.htmlSDK zw_handlePreviewImageRequest:navigationAction.request];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController showAlertWithTitle:@"提示" subtitle:message?:@"" cancelTitle:nil confirmTitle:@"确认" cancel:^{
        
    } confirm:^{
        completionHandler();
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    YYWeakSelf
    UIAlertController *alertController = [UIAlertController showAlertWithTitle:@"提示" subtitle:message?:@"" cancelTitle:@"取消" confirmTitle:@"确认" cancel:^{
        
        completionHandler(NO);
    } confirm:^{
        
        completionHandler(YES);
        if (weakSelf.dislikeBlock) {
            weakSelf.dislikeBlock(weakSelf.newsId);
        }
    }];
    
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
        
        _toolBar = [[YYDetailToolBar alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT-YYTopNaviHeight, kSCREENWIDTH, ToolBarHeight)];
        _toolBar.toolBarType = DetailToolBarTypeWriteComment | DetailToolBarTypeComment | DetailToolBarTypeFavor | DetailToolBarTypeShare;
        
        _toolBar.delegate = self;
        YYWeakSelf
        _toolBar.sendCommentBlock = ^(NSString *comment) {
            
            [weakSelf commentToArticle:comment];
        };
    }
    return _toolBar;
}

- (THBaseTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, ToolBarHeight, 0);
        [_tableView registerClass:[YYCommentCell class] forCellReuseIdentifier:YYCommentCellId];
        //        _tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

@end
