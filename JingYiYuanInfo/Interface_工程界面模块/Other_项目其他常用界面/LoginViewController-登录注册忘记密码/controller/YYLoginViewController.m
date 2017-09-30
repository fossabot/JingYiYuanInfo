//
//  YYLoginViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYLoginViewController.h"
#import "YYForgotPwdViewController.h"
#import "YYRegisterViewController.h"

#import <SAMKeychain/SAMKeychain.h>
#import "YYLoginManager.h"
#import "NSString+Predicate.h"
#import "UITextField+LeftView.h"
#import "YYTextFilter.h"
#import "UIView+YYCategory.h"

@interface YYLoginViewController ()<YYTextFilterDelegate>
/** 手机号*/
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextfield;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
/** 登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/** textField filter*/
@property (nonatomic,strong) YYTextFilter *textFilterAccount;
@property (nonatomic,strong) YYTextFilter *textFilterPassword;

@end

@implementation YYLoginViewController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //输入手机和密码后再使其可用
//    self.loginButton.enabled = NO;
    //配置输入框的相关属性
    [self configTextfield];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.loginButton cutRoundViewRadius:5];
}

#pragma mark -- inner Methods
/** 配置输入框的相关属性*/
- (void)configTextfield{
    
    [self.telephoneTextfield setLeftViewWithImage:@"textfield_leftview_telephone_25x25_"];
    self.textFilterAccount = [[YYTextFilter alloc] init];
    [self.textFilterAccount SetFilter:self.telephoneTextfield
                             delegate:self
                               maxLen:11
                             allowNum:YES
                              allowCH:NO
                          allowLetter:NO
                          allowLETTER:NO
                          allowSymbol:NO
                          allowOthers:nil];
    
    [self.passwordTextfield setLeftViewWithImage:@"textfield_leftview_password_25x25_"];
    self.textFilterPassword = [[YYTextFilter alloc] init];
    [self.textFilterPassword SetFilter:self.passwordTextfield
                              delegate:self
                                maxLen:30
                              allowNum:YES
                               allowCH:NO
                           allowLetter:YES
                           allowLETTER:YES
                           allowSymbol:YES
                           allowOthers:nil];
    
    //输入框添加监听事件，监听输入长度，使重置密码按钮可点击
    [self.telephoneTextfield addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextfield addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
}

/** 监听手机号和密码的输入长度*/
- (void)observeLengthForTextField:(UITextField *)textField {
    if (textField == self.telephoneTextfield) {
        self.passwordTextfield.text = [SAMKeychain passwordForService:KEYCHAIN_SERVICE_LOGIN account:self.telephoneTextfield.text];
    }
    //输入框都满足条件，则注册按钮可点击
    self.loginButton.enabled = [self validToLogin];
    self.loginButton.backgroundColor = [self validToLogin] ? ThemeColor : LightGraySeperatorColor;
}

- (BOOL)validToLogin {
    if(self.telephoneTextfield.text.length == 11 && self.passwordTextfield.text.length >= 6){
        return YES;
    }else {
        return NO;
    }
}

#pragma mark -- outlet Methods

/** 注册账号按钮点击事件*/
- (IBAction)registerButtonClick:(UIButton *)sender {
    
    
    YYRegisterViewController *regist = [[YYRegisterViewController alloc] init];
    regist.jz_wantsNavigationBarVisible = NO;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regist];
//    [self.navigationController pushViewController:regist animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
    
}

/** 忘记密码按钮点击事件*/
- (IBAction)forgotPasswordButtonClick:(UIButton *)sender {
    
    [self presentViewController:[[YYForgotPwdViewController alloc] init] animated:YES completion:^{
        
    }];
    
}

/** 登录按钮点击事件*/
- (IBAction)loginButtonClick:(UIButton *)sender {
    
    [YYLoginManager loginSucceedWithAccount:self.telephoneTextfield.text password:self.passwordTextfield.text responseMsg:^(BOOL success) {
        
        //loginmanager 内部已经处理好了所有用户体验的东西,包括，这里拿到登录状态跳转页面
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
            //这时候登录成功了，可以全局通知，我登录成功了，该刷新的刷新去吧
            [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil];
        }
        
    }];

}

/** 退出*/
- (IBAction)dismiss:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- uitextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   //这里不用验证手机及密码输入框的正确性，只需改变第一响应者，loginmethod里判断
    if (textField == self.telephoneTextfield) {

        [self.telephoneTextfield resignFirstResponder];
        [self.passwordTextfield becomeFirstResponder];
    }
    if (textField == self.passwordTextfield) {
        [self.view endEditing:YES];
        [self loginButtonClick:self.loginButton];
    }
    return YES;
}



@end
