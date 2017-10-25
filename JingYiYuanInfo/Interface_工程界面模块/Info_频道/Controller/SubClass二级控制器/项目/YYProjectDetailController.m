//
//  YYProjectDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProjectDetailController.h"
#import "YYMineOnlineChatViewController.h"

@interface YYProjectDetailController ()

/** 在线咨询*/
@property (nonatomic, strong) UIButton *connect;

/** 收藏*/
@property (nonatomic, strong) UIButton *favor;

/** state*/
@property (nonatomic, assign) BOOL state;

/** collectionId*/
@property (nonatomic, copy) NSString *collectionId;


@end

@implementation YYProjectDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self checkCollectState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)share {
    
    [ShareView shareWithTitle:self.navigationItem.title subTitle:@"" webUrl:self.url imageUrl:self.shareImgUrl isCollected:NO shareViewContain:nil shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}


/** 查询项目的收藏状态*/
- (void)checkCollectState {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        return;
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"collectstate",@"act",self.projectId,@"id",@"5",@"col_type",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:collectionUrl parameters:para success:^(id response) {
        
        if (response) {
            if ([response[@"state"] isEqualToString:@"0"]) {
                self.state = NO;
                YYLog(@"没收藏该项目");
            }else {
                
                self.state = YES;
                self.collectionId = response[@"state"];
                self.favor.selected = YES;
            }
        }
    } failure:^(NSError *error) {
        
        YYLog(@"查询失败");
    } showSuccessMsg:nil];
}

/** 联系我们*/
- (void)connectUs:(UIButton *)sender {
    
    YYWeakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请通过以下方式联系我们" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *qq = [UIAlertAction actionWithTitle:@"QQ交流" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        YYMineOnlineChatViewController *online = [[YYMineOnlineChatViewController alloc] init];
        [weakSelf.navigationController pushViewController:online animated:YES];
    }];
    UIAlertAction *mobile = [UIAlertAction actionWithTitle:@"电话沟通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([kApplication canOpenURL:[NSURL URLWithString:@"telprompt://010-87777077"]]) {
            [kApplication openURL:[NSURL URLWithString:@"telprompt://010-87777077"]];
        }
    }];
    UIAlertAction *giveUp = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:qq];
    [alert addAction:mobile];
    [alert addAction:giveUp];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/** 收藏 sender.selected 为yes是选中状态则是为了取消收藏  否则相反*/
- (void)collectProject:(UIButton *)sender {

    YYUser *user = [YYUser shareUser];
    
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    NSDictionary *para = nil;
    if (sender.selected) {//取消收藏
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"del",@"act",self.collectionId,@"colid",user.userid,USERID, nil];
    }else{//收藏
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"add",@"act",self.projectId,@"arid",@"5",@"type",user.userid,USERID, nil];
    }
    
    [YYHttpNetworkTool GETRequestWithUrlstring:collectionUrl parameters:para success:^(id response) {
        
        if (response && ![response[@"state"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:sender.selected ? @"取消收藏" : @"收藏成功"];
            if (!sender.selected) {
                self.collectionId = response[@"state"];
            }
            self.state = !sender.selected;
            sender.selected = !sender.selected;
        }else {
            [SVProgressHUD showSuccessWithStatus:@"网络不佳"];
        }
        [SVProgressHUD dismissWithDelay:1];
    } failure:^(NSError *error) {
        
        
    } showSuccessMsg:nil];

}

#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIButton *connect = [UIButton buttonWithType:UIButtonTypeCustom];
    [connect setTitle:@"在线咨询" forState:UIControlStateNormal];
    [connect addTarget:self action:@selector(connectUs:) forControlEvents:UIControlEventTouchUpInside];
    [connect setBackgroundColor:OrangeColor];
    [self.view addSubview:connect];
    self.connect = connect;
    
    UIButton *favor = [UIButton buttonWithType:UIButtonTypeCustom];
    [favor setTitle:@"收藏" forState:UIControlStateNormal];
    [favor addTarget:self action:@selector(collectProject:) forControlEvents:UIControlEventTouchUpInside];
    [favor setImage:imageNamed(@"project_favor_normal_20x20") forState:UIControlStateNormal];
    [favor setImage:imageNamed(@"project_favor_select_20x20") forState:UIControlStateSelected];
    [favor setBackgroundColor:ThemeColor];
    [self.view addSubview:favor];
    self.favor = favor;
    
    [self.connect makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    [self.favor makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.connect.right);
        make.bottom.equalTo(self.view);
        make.height.equalTo(50);
        make.right.equalTo(self.view);
        make.width.equalTo(self.connect);
    }];
    
}



#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.favor.enabled = NO;
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    webView.yy_height = kSCREENHEIGHT - YYTopNaviHeight - 50;
    self.favor.enabled = YES;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    [SVProgressHUD dismiss];
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.favor.enabled = NO;
    [self showPlaceHolder];
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismiss];
}

@end
