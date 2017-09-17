//
//  YYForgotPwdViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYForgotPwdViewController.h"
#import "YYLoginManager.h"

#import <SAMKeychain/SAMKeychain.h>
#import "YYCountDownButton.h"

#import "UITextField+LeftView.h"
#import "NSString+YYSecretaryPassword.h"
#import "NSString+Predicate.h"
#import "YYTextFilter.h"


@interface YYForgotPwdViewController ()<YYTextFilterDelegate>
/** 手机号*/
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
/** 验证码*/
@property (weak, nonatomic) IBOutlet UITextField *verificationtextField;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *resetPasswordTextField;
/** 发送新的密码*/
@property (weak, nonatomic) IBOutlet UIButton *sendNewPasswordButton;

/** textField的限制条件*/
@property (nonatomic,strong) YYTextFilter *textFilterAccount;
@property (nonatomic,strong) YYTextFilter *textFilterVerification;
@property (nonatomic,strong) YYTextFilter *textFilterPassword;

@end

@implementation YYForgotPwdViewController


#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //发送新密码的按钮不能点击，当手机密码验证码符合要求再置为可用
//    self.sendNewPasswordButton.enabled = NO;
    //配置输入框限制条件等相关属性
    [self configTextField];
    
    
}

#pragma mark -- mannulMethods
/** 配置输入框限制条件等相关属性*/
- (void)configTextField {
    
    //手机号的限制条件
    [self.telephoneTextField setLeftViewWithImage:@"textfield_leftview_telephone_25x25_"];
    self.textFilterAccount = [[YYTextFilter alloc] init];
    [self.textFilterAccount SetFilter:self.telephoneTextField
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
                                maxLen:MAXFLOAT
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
    [self.telephoneTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [self.resetPasswordTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [self.verificationtextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
}


/** 监听手机号密码和验证码长度*/
- (void)observeLengthForTextField:(UITextField *)textField {
    
    //输入框都满足条件，则注册按钮可点击
    self.sendNewPasswordButton.enabled = [self validToSend];
    self.sendNewPasswordButton.backgroundColor = [self validToSend] ? ThemeColor : [UIColor lightGrayColor];
}

- (BOOL)validToSend {
    if(self.telephoneTextField.text.length == 11 && self.resetPasswordTextField.text.length >= 6 && self.verificationtextField.text.length == 6){
        return YES;
    }else {
        return NO;
    }
}


#pragma mark -- outlet clickEvent
/** 退出控制器*/
- (IBAction)exit {
    
    UIViewController *rootVC = self.presentingViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:nil];
    
}

/** 获取验证码*/
- (IBAction)getVerificattion:(YYCountDownButton *)sender {
    
    BOOL isValidMobileNumber = [NSString isValidMobileNumber:self.telephoneTextField.text];
    if (isValidMobileNumber) {
        [sender countDownFromTime:60 unitTitle:@"s后重发" completion:^(YYCountDownButton *countDownButton) {
            
        }];
        //发送请求，获取验证码
        assert(@"发送请求获取验证码");
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:self.telephoneTextField.text,@"mobile", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:resetpwdVerificationUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[@"status"] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"发送失败"];
                }
            }
            
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
    }

}

/** 发送更新密码*/
- (IBAction)sendNewPasswordButtonClick:(UIButton *)sender {
    
    [YYLoginManager resetPasswordWithAccount:self.telephoneTextField.text
                                    password:[self.resetPasswordTextField.text translateIntoScretaryPassword]
                                verification:self.verificationtextField.text response:^(BOOL success) {
        
        if (success) {
            //更改密码成功
            [SAMKeychain setPassword:self.resetPasswordTextField.text forService:KEYCHAIN_SERVICE_LOGIN account:self.telephoneTextField.text];
        }else{
            
        }
    }];
}




#pragma mark -- UITextfieldDelegate
/** 点击键盘确认按钮*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (_telephoneTextField == textField) {
        [_telephoneTextField resignFirstResponder];
        [_verificationtextField becomeFirstResponder];
    }else if (_verificationtextField == textField) {
        [_verificationtextField resignFirstResponder];
        [_resetPasswordTextField becomeFirstResponder];
    }else if (_resetPasswordTextField == textField) {
        [self sendNewPasswordButtonClick:self.sendNewPasswordButton];
    }
    return YES;
    
}



@end
