//
//  YYNiuNewsDetailViewController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  牛人新闻详情页

#import "YYNiuNewsDetailViewController.h"
#import "YYDetailToolBar.h"
#import "YYRewardView.h"
#import "UIViewController+BackButtonHandler.h"
#import "YYLoginManager.h"

@interface YYNiuNewsDetailViewController ()<YYDetailToolBarDelegate>

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

/** state*/
@property (nonatomic, assign) BOOL state;

/** collectionId*/
@property (nonatomic, copy) NSString *collectionId;

@end

@implementation YYNiuNewsDetailViewController
{
    BOOL _canRemoveToolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.toolBar];
    //    self.toolBar.hidden = YES;
    
    YYWeakSelf
    self.toolBar.sendCommentBlock = ^(NSString *comment) {
        
        YYLog(@"发送评论 --- %@",comment);
        [weakSelf askQuestionForNiuMan:comment];
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
    
    [ShareView shareWithTitle:self.navigationItem.title subTitle:@"" webUrl:self.url imageUrl:self.shareImgUrl isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog | ShareViewTypeFont | ShareViewTypeCopyLink shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}


#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.wkWebview.frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight-ToolBarHeight);
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    YYWeakSelf
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        weakSelf.navigationItem.title = title;
    }];
    [SVProgressHUD dismiss];
    self.toolBar.transform = CGAffineTransformMakeTranslation(0, -ToolBarHeight);
    [self checkCollectState];
    
}


-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self showPlaceHolder];
    
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismissWithDelay:1];
    
}

#pragma mark -------  YYDetailToolBarDelegate -----------------------

- (void)detailToolBar:(YYDetailToolBar *)toolBar didSelectBarType:(DetailToolBarType)barType {
    
    switch (barType) {
            
        case DetailToolBarTypeWriteComment:{
            YYWeakSelf
            [_toolBar writeComments:^(NSString *comment) {
                
                [weakSelf askQuestionForNiuMan:comment];
            }];
        }
            break;
        
        case DetailToolBarTypeReward:{
            
            YYUser *user = [YYUser shareUser];
            if (!user.isLogin) {
                [SVProgressHUD showErrorWithStatus:@"账号未登录"];
                [SVProgressHUD dismissWithDelay:1];
                return;
            }
            //弹出打赏界面
            YYWeakSelf
            
            YYRewardView *rewardView = [[YYRewardView alloc] init];
            rewardView.rewardBlock = ^(NSString *integeration) {
              
                NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"reward",@"act",user.userid,USERID,integeration,@"num",weakSelf.niuNewsId,@"articleid", nil];
                [YYHttpNetworkTool GETRequestWithUrlstring:rewardUrl parameters:para success:^(id response) {
                    
                    if (response) {//1成功 0 积分不足 2 入库失败
                        if ([response[STATE] isEqualToString:@"1"]) {
                            
                            [SVProgressHUD showSuccessWithStatus:@"感谢您的打赏！您的打赏让牛人更有动力创作更有质量的文章！"];
                            [YYLoginManager getUserInfo];
                        }else if ([response[STATE] isEqualToString:@"0"]) {
                            
                            [SVProgressHUD showInfoWithStatus:@"积分不足，可以去积分商城购买"];
                        }else if ([response[STATE] isEqualToString:@"2"]) {
                            
                            [SVProgressHUD showErrorWithStatus:@"服务器忙，稍后再试"];
                        }
                        [SVProgressHUD dismissWithDelay:2];
                    }
                } failure:^(NSError *error) {
                    
                    
                } showSuccessMsg:nil];
            };
            [rewardView show];
            
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
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"collectstate",@"act",self.niuNewsId,@"id",@"3",@"col_type",user.userid,USERID, nil];
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

/** 收藏或者取消*/
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
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"add",@"act",self.niuNewsId,@"arid",@"3",@"type",user.userid,USERID, nil];
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


//提问牛人
- (void)askQuestionForNiuMan:(NSString *)question {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"useraddq",@"act", user.userid,USERID,self.niuNewsId,@"artid", self.newsTitle,@"arttitle",question,@"content",nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            if ([response[STATE] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"提问成功,在我的问答可查看牛人回复哦"];
            }else {
                [SVProgressHUD showErrorWithStatus:@"服务器忙，稍后再试"];
            }
            [SVProgressHUD dismissWithDelay:1];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------


- (YYDetailToolBar *)toolBar {
    
    if (!_toolBar) {
        _toolBar = [[YYDetailToolBar alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT-YYTopNaviHeight, kSCREENWIDTH, ToolBarHeight)];
        _toolBar.placeHolder = @"提问";
        _toolBar.toolBarType = DetailToolBarTypeWriteComment | DetailToolBarTypeReward | DetailToolBarTypeFavor | DetailToolBarTypeShare;
        _toolBar.delegate = self;
        
    }
    return _toolBar;
}



@end
