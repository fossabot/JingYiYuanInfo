//
//  YYRegisterViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYRegisterViewController.h"
#import "YYMineIntroduceDetailController.h"

#import "YYLoginManager.h"
#import "YYCountDownButton.h"

//#import "SAMKeychain.h"
#import <SAMKeychain/SAMKeychain.h>
#import "NSString+Predicate.h"
#import "UITextField+LeftView.h"
#import "NSString+YYSecretaryPassword.h"
#import "YYTextFilter.h"
#import "UIView+YYCategory.h"

@interface YYRegisterViewController ()<YYTextFilterDelegate>
/** 手机号*/
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextfield;
/** 验证码*/
@property (weak, nonatomic) IBOutlet UITextField *verificationTextfield;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
/** 注册按钮*/
@property (weak, nonatomic) IBOutlet UIButton *registeButton;

/** textFilter*/
@property (nonatomic,strong) YYTextFilter *textFilterAccount; //账号输入框限制条件
@property (nonatomic,strong) YYTextFilter *textFilterPassword; //密码输入框限制条件
@property (nonatomic,strong) YYTextFilter *textFilterVerification; //验证码输入框限制条件

@end

@implementation YYRegisterViewController


#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置输入框的相关属性
    [self configTextfield];

    //让注册按钮失效，不能点击
//    self.registeButton.enabled = NO;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.registeButton cutRoundViewRadius:5];
}

#pragma mark -- inner Methods
/** 配置输入框的相关属性*/
- (void)configTextfield {

    //手机号的限制条件
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
    //密码的限制条件
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
    
    //验证码的限制条件
    [self.verificationTextfield setLeftViewWithImage:@"textfield_leftview_verification_25x25_"];
    self.textFilterVerification = [[YYTextFilter alloc] init];
    [self.textFilterVerification SetFilter:self.verificationTextfield
                                  delegate:self
                                    maxLen:6
                                  allowNum:YES
                                   allowCH:NO
                               allowLetter:NO
                               allowLETTER:NO
                               allowSymbol:NO
                               allowOthers:nil];
    
    //输入框添加监听事件，监听输入长度，使注册按钮可点击
    [self.telephoneTextfield addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextfield addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.verificationTextfield addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];

}

/** 限制手机号和验证码长度*/
- (void)observeLengthForTextField:(UITextField *)textField {

    //输入框都满足条件，则注册按钮可点击
    self.registeButton.enabled = [self validToRegiste];
    self.registeButton.backgroundColor = [self validToRegiste] ? ThemeColor : LightGraySeperatorColor;
}

- (BOOL)validToRegiste {
    if(self.telephoneTextfield.text.length == 11 && self.passwordTextfield.text.length >= 6 && self.verificationTextfield.text.length == 6){
        return YES;
    }else {
        return NO;
    }
}


#pragma mark -- outlet Methods
/** 退出按钮点击事件*/
- (IBAction)exitbuttonClick {
    
    UIViewController *rootVC = self.presentingViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:nil];
    
}

/** 获取验证码*/
- (IBAction)getVerificattion:(YYCountDownButton *)sender {
    
    BOOL isValidMobileNumber = [NSString isValidMobileNumber:self.telephoneTextfield.text];
    if (isValidMobileNumber) {
        [sender countDownFromTime:60 unitTitle:@"s后可重发" completion:^(YYCountDownButton *countDownButton) {
            
        }];
        //发送请求，获取验证码
        assert(@"发送请求获取验证码");
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"reg",@"keyword",self.telephoneTextfield.text,@"mobile", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:registerVerificationUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[@"status"] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                } else if ([response[@"status"] isEqualToString:@"0"]) {
                    [SVProgressHUD showErrorWithStatus:@"发送失败"];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"手机号已注册"];
                }
            }
            
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
    }
    
}

/** 查看用户协议*/
- (IBAction)userProtocol:(UIButton *)sender {
    
    YYMineIntroduceDetailController *introduce = [[YYMineIntroduceDetailController alloc] init];
    introduce.url = userProtocolUrl;
    [self.navigationController pushViewController:introduce animated:YES];
}

/** 注册按钮事件*/
- (IBAction)registeButtonClick:(UIButton *)sender {
#warning 注册操作，尚未完成
    //发送手机号 验证码 密码等给后台  注册用户  同时密码加密
    [YYLoginManager registeAccount:self.telephoneTextfield.text verification:self.verificationTextfield.text password:self.passwordTextfield.text response:^(BOOL success) {
        
       if (success) {
           [SAMKeychain setPassword:self.passwordTextfield.text forService:KEYCHAIN_SERVICE_LOGIN account:self.telephoneTextfield.text];
            //注册成功，返回到顶层，如果没有返回个人信息，那就调登录接口
            UIViewController *vc = self;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
            //注册成功，返回主界面，更新个人信息，刷新主界面等操作
            
        }else{
            //注册失败
            
        }
        
    }];
    
}
/** 拨打客服电话☎️*/
- (IBAction)callClientHelper {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"客服" message:@"联系壹元服务客服：010-87777077" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        YYLog(@"取消拨打客服电话");
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:clientHelper]];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark -- uitextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (_telephoneTextfield == textField) {
        [_telephoneTextfield resignFirstResponder];
        [_verificationTextfield becomeFirstResponder];
    }else if (_verificationTextfield == textField) {
        [_verificationTextfield resignFirstResponder];
        [_passwordTextfield becomeFirstResponder];
    }else if (_passwordTextfield == textField) {
        [self registeButtonClick:nil];
    }
    return YES;
    
}


/** 每次输入都会调用*/
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    //当密码输入框文字个数大于等于6个数，手机号不为空，验证码不为空，则注册按钮可点击，否则不能
//    if ([self.passwordTextfield.text length] >= 6 && self.telephoneTextfield.text != nil && self.verificationTextfield.text != nil) {
//        self.registeButton.enabled = YES;
//    }else{
//        self.registeButton.enabled = !self.registeButton.enabled;
//    }
//    
//    //限制密码输入框的输入个数
//    if (_verificationTextfield == textField && range.location >= 6) {
//        
//     //6代表字符个数， 一个汉字和一个字母都是一个字符
//        //返回no 输入框就编辑失效了
//        //        return NO;
//    }
//    return YES;
//}


@end
