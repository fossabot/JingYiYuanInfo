//
//  YYGoodsDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYGoodsDetailController.h"
#import "YYAddressController.h"
#import "YYLoginManager.h"

@interface YYGoodsDetailController ()

/** buy*/
@property (nonatomic, strong) UIButton *buy;

@end

@implementation YYGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.view addSubview:self.buy];
    [self.buy makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIButton *)buy{
    if (!_buy) {
        _buy = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buy setTitle:@"立即兑换" forState:UIControlStateNormal];
        [_buy setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_buy setBackgroundColor:ThemeColor];
        [_buy addTarget:self action:@selector(alertUser) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buy;
}

/* 提醒用户是否兑换商品*/
- (void)alertUser {
    
    NSString *msg = [NSString stringWithFormat:@"您是否要花费%@积分兑换该商品",self.integral];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"兑换商品" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        YYLog(@"点击了取消");
    }]];
    
    YYWeakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf buyGoods];
    }]];
    
    [kKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

/** 兑换商品*/
- (void)buyGoods {
 
    
    YYUser *user = [YYUser shareUser];
    if (user.isLogin) {
        
        YYWeakSelf
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:self.goodId,@"goodid",user.userid,USERID, nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:exchangeGoodUrl parameters:para success:^(id response) {
            
            if (response) {//state  0收货地址为空 1成功 2积分不足 3入库失败
                if ([response[STATE] isEqualToString:@"0"]) {
                    [SVProgressHUD showErrorWithStatus:@"没有收货地址"];
                    [SVProgressHUD dismissWithDelay:1 completion:^{
                        
                        YYAddressController *addressVc = [[YYAddressController alloc] init];
                        [weakSelf.navigationController pushViewController:addressVc animated:YES];
                    }];
                }else if ([response[STATE] isEqualToString:@"1"]) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"兑换成功，稍后客服会与您联系！"];
                    [YYLoginManager getUserInfo];
                }else if ([response[STATE] isEqualToString:@"2"]) {
                    
                    [SVProgressHUD showInfoWithStatus:@"积分不足"];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"服务器忙，稍后再试"];
                }
                [SVProgressHUD dismissWithDelay:2];
            }
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
        
    }else {
        
        [SVProgressHUD showInfoWithStatus:@"对不起！账号未登录，无法兑换！"];
        [SVProgressHUD dismissWithDelay:1];
    }
}




#pragma mark -------  wkWebview 代理方法  --------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.wkWebview.frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight-50);
    YYWeakSelf
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        weakSelf.navigationItem.title = title;
    }];
    YYUser *user = [YYUser shareUser];
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(NSInteger)user.webfont*100];
    [webView evaluateJavaScript:js completionHandler:nil];
    [SVProgressHUD dismiss];
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self showPlaceHolder];
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismissWithDelay:1];
}



@end
