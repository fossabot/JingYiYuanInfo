//
//  YYLogInController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYLogInController.h"
#import "YYCountDownButton.h"
#import "YYForgotPwdController.h"
#import "YYRegistController.h"

#import <SAMKeychain/SAMKeychain.h>
#import "YYLoginManager.h"
#import "NSString+Predicate.h"
#import "UITextField+LeftView.h"
#import "YYTextFilter.h"
#import "UIView+YYCategory.h"

@interface YYLogInController ()<YYTextFilterDelegate,UITextFieldDelegate>

/** navView*/
@property (nonatomic, strong) UIView *navView;

/** titleView*/
@property (nonatomic, strong) UILabel *titleView;

/** exit*/
@property (nonatomic, strong) UIButton *exit;

/** container*/
@property (nonatomic, strong) UIView *container;

/** teleTextField*/
@property (nonatomic, strong) UITextField *teleTextField;

/** separator1*/
@property (nonatomic, strong) UIView *separator1;

/** pwdTextField*/
@property (nonatomic, strong) UITextField *pwdTextField;

/** separator1*/
@property (nonatomic, strong) UIView *separator2;

/** regist*/
@property (nonatomic, strong) UIButton *regist;

/** forgot*/
@property (nonatomic, strong) UIButton *forgot;

/** logIn*/
@property (nonatomic, strong) UIButton *logIn;


/** textField filter*/
@property (nonatomic,strong) YYTextFilter *textFilterAccount;
@property (nonatomic,strong) YYTextFilter *textFilterPassword;


@end

@implementation YYLogInController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self masonrySubView];
    [self configTextfield];
}


#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = ThemeColor;
    self.navView = navView;
    [self.view addSubview:navView];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeCustom];
    [exit setImage:imageNamed(@"login_close_32x32") forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    self.exit = exit;
    [self.navView addSubview:exit];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"登录";
    titleView.textColor = WhiteColor;
    [self.navView addSubview:titleView];
    self.titleView = titleView;
    
    UIView *container = [[UIView alloc] init];
    self.container = container;
    [self.view addSubview:container];
    
    UITextField *teleTextField = [[UITextField alloc] init];
    teleTextField.delegate = self;
    teleTextField.font = SubTitleFont;
    teleTextField.placeholder = @"请输入手机号";
    teleTextField.tintColor = ThemeColor;
    [teleTextField setLeftViewWithImage:@"textfield_leftview_telephone_25x25_"];
    [self.container addSubview:teleTextField];
    self.teleTextField = teleTextField;
    
    UIView *separator1 = [[UIView alloc] init];
    separator1.backgroundColor = ThemeColor;
    self.separator1 = separator1;
    [self.container addSubview:separator1];
    
    
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.delegate = self;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.font = SubTitleFont;
    pwdTextField.placeholder = @"请输入密码(至少6位)";
    pwdTextField.tintColor = ThemeColor;
    [pwdTextField setLeftViewWithImage:@"textfield_leftview_password_25x25_"];
    [self.container addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    
    UIView *separator2 = [[UIView alloc] init];
    separator2.backgroundColor = ThemeColor;
    self.separator2 = separator2;
    [self.container addSubview:separator2];
    
    UIButton *regist = [UIButton buttonWithType:UIButtonTypeCustom];
    regist.titleLabel.font = SubTitleFont;
    [regist setTitle:@"注册壹元" forState:UIControlStateNormal];
    [regist setTitleColor:ThemeColor forState:UIControlStateNormal];
    [regist addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.regist = regist;
    [self.view addSubview:regist];
    
    UIButton *forgot = [UIButton buttonWithType:UIButtonTypeCustom];
    forgot.titleLabel.font = SubTitleFont;
    [forgot setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgot setTitleColor:ThemeColor forState:UIControlStateNormal];
    [forgot addTarget:self action:@selector(forgotPasswordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.forgot = forgot;
    [self.view addSubview:forgot];
    
    UIButton *logIn = [UIButton buttonWithType:UIButtonTypeCustom];
    logIn.enabled = NO;
    logIn.titleLabel.font = TitleFont;
    [logIn setBackgroundColor:LightGraySeperatorColor];
    [logIn setTitle:@"登录" forState:UIControlStateNormal];
    [logIn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [logIn addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.logIn = logIn;
    [self.view addSubview:logIn];
    
}

- (void)masonrySubView {
    
    [self.navView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(64);
    }];
    
    [self.exit makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(15);
        make.bottom.equalTo(self.navView).offset(-10);
        make.width.height.equalTo(25);
    }];
    
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.navView);
        make.bottom.equalTo(self.navView);
        make.height.equalTo(44);
    }];
    
    [self.container makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.centerY).offset(-50);
        make.width.equalTo(kSCREENWIDTH-80);
    }];
    
    [self.teleTextField makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.container);
        make.height.equalTo(35);
    }];
    
    [self.separator1 makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.teleTextField);
        make.top.equalTo(self.teleTextField.bottom).offset(2);
        make.height.equalTo(1);
    }];
    
    [self.pwdTextField makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.separator1.bottom).offset(5);
        make.height.equalTo(35);
    }];
    
    [self.separator2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.pwdTextField);
        make.top.equalTo(self.pwdTextField.bottom).offset(2);
        make.height.equalTo(1);
        make.bottom.equalTo(self.container.bottom).offset(-5);
    }];
    
    [self.regist makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.container);
        make.top.equalTo(self.container.bottom).offset(10);
        make.width.equalTo(60);
        make.height.equalTo(20);
    }];
    
    [self.forgot makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.container);
        make.top.equalTo(self.container.bottom).offset(10);
        make.width.equalTo(60);
        make.height.equalTo(20);
    }];
    
    [self.logIn makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.container.bottom).offset(60);
        make.width.equalTo(kSCREENWIDTH/2);
        make.height.equalTo(40);
    }];
    
}





/** 注册账号按钮点击事件*/
- (void)registerButtonClick:(UIButton *)sender {
    
    YYRegistController *regist = [[YYRegistController alloc] init];
    [self presentViewController:regist animated:YES completion:nil];
    
}

/** 忘记密码按钮点击事件*/
- (void)forgotPasswordButtonClick:(UIButton *)sender {
    
    [self presentViewController:[[YYForgotPwdController alloc] init] animated:YES completion:^{
        
    }];
    
}

/** 登录按钮点击事件*/
- (void)loginButtonClick:(UIButton *)sender {
    
    [YYLoginManager loginSucceedWithAccount:self.teleTextField.text password:self.pwdTextField.text responseMsg:^(BOOL success) {
        
        //loginmanager 内部已经处理好了所有用户体验的东西,包括，这里拿到登录状态跳转页面
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
            //这时候登录成功了，可以全局通知，我登录成功了，该刷新的刷新去吧
            [kUserDefaults setBool:YES forKey:LOGINSTATUS];
            [kUserDefaults synchronize];
            [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"0"}];
        }
        
    }];
    
}

/** 退出*/
- (void)dismiss:(UIButton *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- uitextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //这里不用验证手机及密码输入框的正确性，只需改变第一响应者，loginmethod里判断
    if (textField == self.teleTextField) {
        
        [self.teleTextField resignFirstResponder];
        [self.pwdTextField becomeFirstResponder];
    }
    if (textField == self.pwdTextField) {
        [self.view endEditing:YES];
        [self loginButtonClick:self.logIn];
    }
    return YES;
}




/** 配置输入框的相关属性*/
- (void)configTextfield{
    
    [self.teleTextField setLeftViewWithImage:@"textfield_leftview_telephone_25x25_"];
    self.textFilterAccount = [[YYTextFilter alloc] init];
    [self.textFilterAccount SetFilter:self.teleTextField
                             delegate:self
                               maxLen:11
                             allowNum:YES
                              allowCH:NO
                          allowLetter:NO
                          allowLETTER:NO
                          allowSymbol:NO
                          allowOthers:nil];
    
    [self.pwdTextField setLeftViewWithImage:@"textfield_leftview_password_25x25_"];
    self.textFilterPassword = [[YYTextFilter alloc] init];
    [self.textFilterPassword SetFilter:self.pwdTextField
                              delegate:self
                                maxLen:30
                              allowNum:YES
                               allowCH:NO
                           allowLetter:YES
                           allowLETTER:YES
                           allowSymbol:YES
                           allowOthers:nil];
    
    //输入框添加监听事件，监听输入长度，使重置密码按钮可点击
    [self.teleTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
}

/** 监听手机号和密码的输入长度*/
- (void)observeLengthForTextField:(UITextField *)textField {
    if (textField == self.teleTextField) {
        self.pwdTextField.text = [SAMKeychain passwordForService:KEYCHAIN_SERVICE_LOGIN account:self.teleTextField.text];
    }
    //输入框都满足条件，则注册按钮可点击
    self.logIn.enabled = [self validToLogin];
    self.logIn.backgroundColor = [self validToLogin] ? ThemeColor : LightGraySeperatorColor;
}

- (BOOL)validToLogin {
    if(self.teleTextField.text.length == 11 && self.pwdTextField.text.length >= 6){
        return YES;
    }else {
        return NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
