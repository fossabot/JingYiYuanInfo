//
//  YYVIPDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  购买会员

#import "YYVIPDetailController.h"
#import "YYIAPTool.h"
#import <DateTools/DateTools.h>
#import "UIAlertController+YYShortAlert.h"

@interface YYVIPDetailController ()

/** buy*/
@property (nonatomic, strong) UIButton *buy;

@end

@implementation YYVIPDetailController


- (void)dealloc {
    
    [kNotificationCenter removeObserver:self name:YYIapSucceedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.view addSubview:self.buy];
    [self.buy makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    [kNotificationCenter addObserver:self selector:@selector(pop:) name:YYIapSucceedNotification object:nil];
}




/** 购买会员*/
- (void)buyVip:(UIButton *)sender {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    NSDate *now = [NSDate date];
    NSString *expireTime = [user.expiretime substringToIndex:10];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = yyyyMMdd;
    NSDate *expireDate = [formatter dateFromString:expireTime];
    NSDate *fourYearAfter = [now dateByAddingYears:4];
    
    if (![expireDate isEarlierThan:fourYearAfter]) {//如果到期时间比现在往后推4年还早的话，说明购买一年到期时间会比现在往后推5年还早，也就是可以购买
        UIAlertController *alert = [UIAlertController showAlertWithTitle:@"提示" subtitle:@"您的会员时间已达五年，暂无法购买" cancelTitle:nil confirmTitle:@"确认" cancel:^{
            
        } confirm:^{
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [YYIAPTool buyProductByProductionId:@"com.yyapp_vip_1" type:@"1"];
    
}

- (void)pop:(NSNotification *)notice {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- inner Methods 自定义方法  -------------------------------


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIButton *)buy{
    if (!_buy) {
        _buy = [UIButton buttonWithType:UIButtonTypeCustom];
        _buy.enabled = NO;
        [_buy setTitle:@"购买会员" forState:UIControlStateNormal];
        [_buy setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_buy setBackgroundColor:ThemeColor];
        [_buy addTarget:self action:@selector(buyVip:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buy;
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
    _buy.enabled = YES;
    [SVProgressHUD dismiss];
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self showPlaceHolder];
    [SVProgressHUD showErrorWithStatus:@"网络出错"];
    [SVProgressHUD dismissWithDelay:1];
}



@end
