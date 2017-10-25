//
//  YYForgotPwdController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYForgotPwdController.h"
#import "YYLoginManager.h"

#import <SAMKeychain/SAMKeychain.h>
#import "YYCountDownButton.h"

#import "UITextField+LeftView.h"
#import "NSString+YYSecretaryPassword.h"
#import "NSString+Predicate.h"
#import "YYTextFilter.h"


@interface YYForgotPwdController ()<YYTextFilterDelegate,UITextFieldDelegate>

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

/** 验证码*/
@property (strong, nonatomic) UITextField *verificationtextField;

/** verificationBtn*/
@property (nonatomic, strong) YYCountDownButton *verificationBtn;

/** separator2*/
@property (nonatomic, strong) UIView *separator2;

/** 新密码*/
@property (strong, nonatomic) UITextField *resetPasswordTextField;

/** separator3*/
@property (nonatomic, strong) UIView *separator3;

/** pwdTextField*/
@property (nonatomic, strong) UITextField *pwdTextField;


/** 发送新的密码*/
@property (strong, nonatomic) UIButton *sendNewPasswordButton;

/** textField的限制条件*/
@property (nonatomic,strong) YYTextFilter *textFilterAccount;
@property (nonatomic,strong) YYTextFilter *textFilterVerification;
@property (nonatomic,strong) YYTextFilter *textFilterPassword;

@end

@implementation YYForgotPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self masonrySubView];
    //配置输入框限制条件等相关属性
    [self configTextField];
}


#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = ThemeColor;
    self.navView = navView;
    [self.view addSubview:navView];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeCustom];
    [exit setImage:imageNamed(@"login_close_32x32") forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(dismissCurrentVc) forControlEvents:UIControlEventTouchUpInside];
    self.exit = exit;
    [self.navView addSubview:exit];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"忘记密码";
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
    
    UITextField *verificationtextField = [[UITextField alloc] init];
    verificationtextField.delegate = self;
    verificationtextField.font = SubTitleFont;
    verificationtextField.placeholder = @"请输入验证码";
    verificationtextField.tintColor = ThemeColor;
    [verificationtextField setLeftViewWithImage:@"textfield_leftview_verification_25x25_"];
    [self.container addSubview:verificationtextField];
    self.verificationtextField = verificationtextField;
    
    YYCountDownButton *verificationBtn = [[YYCountDownButton alloc] init];
    verificationBtn.titleLabel.font = SubTitleFont;
    verificationBtn.layer.cornerRadius = 5;
    verificationBtn.layer.borderColor = ThemeColor.CGColor;
    verificationBtn.layer.borderWidth = 0.5;
    verificationBtn.backgroundColor = ThemeColor;
    [verificationBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificationBtn addTarget:self action:@selector(getVerificattion:) forControlEvents:UIControlEventTouchUpInside];
    self.verificationBtn = verificationBtn;
    [self.container addSubview:verificationBtn];
    
    
    UIView *separator2 = [[UIView alloc] init];
    separator2.backgroundColor = ThemeColor;
    self.separator2 = separator2;
    [self.container addSubview:separator2];
    
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.delegate = self;
    pwdTextField.font = SubTitleFont;
    pwdTextField.placeholder = @"请输入密码(至少6位)";
    pwdTextField.tintColor = ThemeColor;
    [pwdTextField setLeftViewWithImage:@"textfield_leftview_password_25x25_"];
    [self.container addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    
    UIView *separator3 = [[UIView alloc] init];
    separator3.backgroundColor = ThemeColor;
    self.separator3 = separator3;
    [self.container addSubview:separator3];
    
    
    UIButton *sendNewPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendNewPasswordButton.enabled = NO;
    sendNewPasswordButton.titleLabel.font = TitleFont;
    sendNewPasswordButton.backgroundColor = LightGraySeperatorColor;
    [sendNewPasswordButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendNewPasswordButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [sendNewPasswordButton addTarget:self action:@selector(sendNewPasswordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sendNewPasswordButton = sendNewPasswordButton;
    [self.view addSubview:sendNewPasswordButton];
    
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
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.teleTextField.bottom).offset(2);
        make.height.equalTo(1);
    }];
    
    
    [self.verificationtextField makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.container);
        make.top.equalTo(self.separator1.bottom).offset(5);
        make.height.equalTo(35);
    }];
    
    [self.verificationBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.container);
        make.left.equalTo(self.verificationtextField.right).offset(10);
        make.centerY.equalTo(self.verificationtextField);
        make.width.equalTo(90);
        make.height.equalTo(30);
    }];
    
    [self.separator2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.verificationtextField.bottom).offset(2);
        make.height.equalTo(1);
    }];
    
    [self.pwdTextField makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.separator2.bottom).offset(5);
        make.height.equalTo(35);
    }];
    
    [self.separator3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.pwdTextField.bottom).offset(2);
        make.height.equalTo(1);
        make.bottom.equalTo(self.container.bottom).offset(-5);
    }];
    
    [self.sendNewPasswordButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.container.bottom).offset(60);
        make.width.equalTo(kSCREENWIDTH/2);
        make.height.equalTo(40);
    }];
    
}










#pragma mark -- mannulMethods
/** 配置输入框限制条件等相关属性*/
- (void)configTextField {
    
    //手机号的限制条件
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
    //密码的限制条件
    [self.resetPasswordTextField setLeftViewWithImage:@"textfield_leftview_password_25x25_"];
    self.textFilterPassword = [[YYTextFilter alloc] init];
    [self.textFilterPassword SetFilter:self.resetPasswordTextField
                              delegate:self
                                maxLen:30
                              allowNum:YES
                               allowCH:NO
                           allowLetter:YES
                           allowLETTER:YES
                           allowSymbol:YES
                           allowOthers:nil];
    //验证码的限制条件
    [self.verificationtextField setLeftViewWithImage:@"textfield_leftview_verification_25x25_"];
    self.textFilterVerification = [[YYTextFilter alloc] init];
    [self.textFilterVerification SetFilter:self.verificationtextField
                                  delegate:self
                                    maxLen:6
                                  allowNum:YES
                                   allowCH:NO
                               allowLetter:NO
                               allowLETTER:NO
                               allowSymbol:NO
                               allowOthers:nil];
    
    //输入框添加监听事件，监听输入长度，使重置密码按钮可点击
    [self.teleTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [self.resetPasswordTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [self.verificationtextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
}


/** 监听手机号密码和验证码长度*/
- (void)observeLengthForTextField:(UITextField *)textField {
    
    //输入框都满足条件，则注册按钮可点击
    self.sendNewPasswordButton.enabled = [self validToSend];
    self.sendNewPasswordButton.backgroundColor = [self validToSend] ? ThemeColor : LightGraySeperatorColor;
}

- (BOOL)validToSend {
    if(self.teleTextField.text.length == 11 && self.resetPasswordTextField.text.length >= 6 && self.verificationtextField.text.length == 6){
        return YES;
    }else {
        return NO;
    }
}


#pragma mark -- outlet clickEvent
/** 完全退出控制器*/
- (void)dismissVc {
    
    UIViewController *rootVC = self.presentingViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:nil];
    
}

/** 退出当前界面*/

- (void)dismissCurrentVc {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 获取验证码*/
- (void)getVerificattion:(YYCountDownButton *)sender {
    
    BOOL isValidMobileNumber = [NSString isValidMobileNumber:self.teleTextField.text];
    if (isValidMobileNumber) {
        [sender countDownFromTime:60 unitTitle:@"s后重发" completion:^(YYCountDownButton *countDownButton) {
            
        }];
        
        [YYLoginManager getResetPasswordVerificationByMobile:self.teleTextField.text];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
    }
    
}

/** 发送更新密码*/
- (void)sendNewPasswordButtonClick:(UIButton *)sender {
    
    YYWeakSelf
    [YYLoginManager resetPasswordWithAccount:self.teleTextField.text
                                    password:[self.resetPasswordTextField.text translateIntoScretaryPassword]
                                verification:self.verificationtextField.text response:^(BOOL success) {
                                    
                                    if (success) {
                                        //更改密码成功
                                        [SAMKeychain setPassword:self.resetPasswordTextField.text forService:KEYCHAIN_SERVICE_LOGIN account:self.teleTextField.text];
                                        [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"1"}];
                                        [weakSelf dismissVc];
                                        
                                    }else{
                                        YYLog(@"更新密码失败");
                                    }
                                }];
}




#pragma mark -- UITextfieldDelegate
/** 点击键盘确认按钮*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (_teleTextField == textField) {
        [_teleTextField resignFirstResponder];
        [_verificationtextField becomeFirstResponder];
    }else if (_verificationtextField == textField) {
        [_verificationtextField resignFirstResponder];
        [_resetPasswordTextField becomeFirstResponder];
    }else if (_resetPasswordTextField == textField) {
        if ([self validToSend]) {
            
            [self sendNewPasswordButtonClick:self.sendNewPasswordButton];
        }
    }
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
