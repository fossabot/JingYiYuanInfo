//
//  YYRegistController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYRegistController.h"
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

@interface YYRegistController ()<YYTextFilterDelegate,UITextFieldDelegate>

/** navView*/
@property (nonatomic, strong) UIView *navView;

/** titleView*/
@property (nonatomic, strong) UILabel *titleView;

/** exit*/
@property (nonatomic, strong) UIButton *exit;

/** container*/
@property (nonatomic, strong) UIView *container;

/** 手机号*/
@property (strong, nonatomic) UITextField *telephoneTextfield;

/** separator1*/
@property (nonatomic, strong) UIView *separator1;

/** 验证码*/
@property (strong, nonatomic) UITextField *verificationTextfield;

/** verificationBtn*/
@property (nonatomic, strong) YYCountDownButton *verificationBtn;

/** separator2*/
@property (nonatomic, strong) UIView *separator2;

/** 密码*/
@property (strong, nonatomic) UITextField *passwordTextfield;

/** separator3*/
@property (nonatomic, strong) UIView *separator3;

/** 注册按钮*/
@property (strong, nonatomic) UIButton *registeButton;

/** textFilter*/
@property (nonatomic,strong) YYTextFilter *textFilterAccount; //账号输入框限制条件
@property (nonatomic,strong) YYTextFilter *textFilterPassword; //密码输入框限制条件
@property (nonatomic,strong) YYTextFilter *textFilterVerification; //验证码输入框限制条件


@end

@implementation YYRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self masonrySubView];
    //配置输入框的相关属性
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
    [exit addTarget:self action:@selector(exitbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.exit = exit;
    [self.navView addSubview:exit];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"注册";
    titleView.textColor = WhiteColor;
    [self.navView addSubview:titleView];
    self.titleView = titleView;
    
    UIView *container = [[UIView alloc] init];
    self.container = container;
    [self.view addSubview:container];
    
    UITextField *telephoneTextfield = [[UITextField alloc] init];
    telephoneTextfield.delegate = self;
    telephoneTextfield.font = SubTitleFont;
    telephoneTextfield.placeholder = @"请输入手机号";
    telephoneTextfield.tintColor = ThemeColor;
    [telephoneTextfield setLeftViewWithImage:@"textfield_leftview_telephone_25x25_"];
    [self.container addSubview:telephoneTextfield];
    self.telephoneTextfield = telephoneTextfield;
    
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
    self.verificationTextfield = verificationtextField;
    
    YYCountDownButton *verificationBtn = [[YYCountDownButton alloc] init];
    verificationBtn.titleLabel.font = SubTitleFont;
    verificationBtn.layer.cornerRadius = 5;
    verificationBtn.layer.borderColor = ThemeColor.CGColor;
    verificationBtn.layer.borderWidth = 0.5;
    verificationBtn.backgroundColor = WhiteColor;
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
    self.passwordTextfield = pwdTextField;
    
    UIView *separator3 = [[UIView alloc] init];
    separator3.backgroundColor = ThemeColor;
    self.separator3 = separator3;
    [self.container addSubview:separator3];
    
    
    UIButton *registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registeButton.enabled = NO;
    registeButton.titleLabel.font = TitleFont;
    registeButton.backgroundColor = LightGraySeperatorColor;
    [registeButton setTitle:@"注册" forState:UIControlStateNormal];
    [registeButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [registeButton addTarget:self action:@selector(registeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.registeButton = registeButton;
    [self.view addSubview:registeButton];
    
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
    
    [self.telephoneTextfield makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.container);
        make.height.equalTo(35);
    }];
    
    [self.separator1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.telephoneTextfield.bottom).offset(2);
        make.height.equalTo(1);
    }];
    
    
    [self.verificationTextfield makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.container);
        make.top.equalTo(self.separator1.bottom).offset(5);
        make.height.equalTo(35);
    }];
    
    [self.verificationBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.container);
        make.left.equalTo(self.verificationTextfield.right).offset(10);
        make.centerY.equalTo(self.verificationTextfield);
        make.width.equalTo(90);
        make.height.equalTo(30);
    }];
    
    [self.separator2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.verificationTextfield.bottom).offset(2);
        make.height.equalTo(1);
    }];
    
    [self.passwordTextfield makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.separator2.bottom).offset(5);
        make.height.equalTo(35);
    }];
    
    [self.separator3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.container);
        make.top.equalTo(self.passwordTextfield.bottom).offset(2);
        make.height.equalTo(1);
        make.bottom.equalTo(self.container.bottom).offset(-5);
    }];
    
    [self.registeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.container.bottom).offset(60);
        make.width.equalTo(kSCREENWIDTH/2);
        make.height.equalTo(40);
    }];
    
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
- (void)exitbuttonClick {
    
//    UIViewController *rootVC = self.presentingViewController;
//    while (rootVC.presentingViewController) {
//        rootVC = rootVC.presentingViewController;
//    }
//    [rootVC dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 获取验证码*/
- (void)getVerificattion:(YYCountDownButton *)sender {
    
    BOOL isValidMobileNumber = [NSString isValidMobileNumber:self.telephoneTextfield.text];
    if (isValidMobileNumber) {
        [sender countDownFromTime:60 unitTitle:@"s后可重发" completion:^(YYCountDownButton *countDownButton) {
            
        }];
        //发送请求，获取验证码
        assert(@"发送请求获取验证码");
        [YYLoginManager getRegisterVerificationByMobile:self.telephoneTextfield.text];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
}

/** 查看用户协议*/
- (void)userProtocol:(UIButton *)sender {
    
    YYMineIntroduceDetailController *introduce = [[YYMineIntroduceDetailController alloc] init];
    introduce.url = userProtocolUrl;
    [self.navigationController pushViewController:introduce animated:YES];
}

/** 注册按钮事件*/
- (void)registeButtonClick:(UIButton *)sender {
#warning 注册操作，尚未完成
    //发送手机号 验证码 密码等给后台  注册用户  同时密码加密
    [YYLoginManager registeAccount:self.telephoneTextfield.text verification:self.verificationTextfield.text password:self.passwordTextfield.text response:^(BOOL success) {
        
        if (success) {
            [SAMKeychain setPassword:self.passwordTextfield.text forService:KEYCHAIN_SERVICE_LOGIN account:self.telephoneTextfield.text];
            //注册成功，返回主界面，更新个人信息，刷新主界面等操作
            [kUserDefaults setBool:YES forKey:LOGINSTATUS];
            [kUserDefaults synchronize];
            [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"0"}];
            //注册成功，返回到顶层，如果没有返回个人信息，那就调登录接口
            UIViewController *vc = self;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            //注册失败
            YYLog(@"注册失败");
        }
        
    }];
    
}
/** 拨打客服电话☎️*/
- (void)callClientHelper {
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
