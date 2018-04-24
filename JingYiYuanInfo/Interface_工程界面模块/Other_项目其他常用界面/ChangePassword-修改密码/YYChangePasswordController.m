//
//  YYChangePasswordController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChangePasswordController.h"
#import "NSString+Predicate.h"
#import "UITextField+LeftView.h"
#import "YYLoginManager.h"
#import "YYTextFilter.h"
#import "UIView+YYCategory.h"

@interface YYChangePasswordController ()<YYTextFilterDelegate,UITextFieldDelegate>

/** view1*/
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (strong, nonatomic) UITextField *oldPwdTextField;
@property (strong, nonatomic) UITextField *changedPwdTextField;

/** changePwd*/
@property (nonatomic, strong) UIButton *changePwd;

/** textField filter*/
@property (nonatomic,strong) YYTextFilter *textFilterOldPassword;

/** textField filter*/
@property (nonatomic,strong) YYTextFilter *textFilterNewPassword;

@end

@implementation YYChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = GrayBackGroundColor;
    [self configSubView];
    
    [self configTextFilter];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self.changePwd cutRoundViewRadius:5];
}

- (void)configTextFilter {
    
    self.textFilterOldPassword = [[YYTextFilter alloc] init];
    [self.textFilterOldPassword SetFilter:self.oldPwdTextField
                              delegate:self
                                maxLen:30
                              allowNum:YES
                               allowCH:NO
                           allowLetter:YES
                           allowLETTER:YES
                           allowSymbol:YES
                           allowOthers:nil];

    self.textFilterNewPassword = [[YYTextFilter alloc] init];
    [self.textFilterNewPassword SetFilter:self.changedPwdTextField
                                 delegate:self
                                   maxLen:30
                                 allowNum:YES
                                  allowCH:NO
                              allowLetter:YES
                              allowLETTER:YES
                              allowSymbol:YES
                              allowOthers:nil];
    
    //输入框添加监听事件，监听输入长度，使重置密码按钮可点击
    [self.oldPwdTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.changedPwdTextField addTarget:self action:@selector(observeLengthForTextField:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = WhiteColor;
    self.view1 = view1;
    [self.view addSubview:view1];
    
    UITextField *oldPwdTextField = [[UITextField alloc] init];
    oldPwdTextField.delegate = self;
//    oldPwdTextField.secureTextEntry = YES;
    oldPwdTextField.font = TitleFont;
    oldPwdTextField.placeholder = @"旧密码(至少6位)";
    oldPwdTextField.tintColor = ThemeColor;
    oldPwdTextField.returnKeyType = UIReturnKeyNext;
    [oldPwdTextField setLeftTitle:@"旧密码"];
    [self.view1 addSubview:oldPwdTextField];
    self.oldPwdTextField = oldPwdTextField;
    
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = WhiteColor;
    self.view2 = view2;
    [self.view addSubview:view2];
    
    UITextField *changedPwdTextField = [[UITextField alloc] init];
    changedPwdTextField.delegate = self;
    //    oldPwdTextField.secureTextEntry = YES;
    changedPwdTextField.font = TitleFont;
    changedPwdTextField.placeholder = @"新密码(至少6位)";
    changedPwdTextField.tintColor = ThemeColor;
    changedPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    [changedPwdTextField setLeftTitle:@"新密码"];
    [self.view2 addSubview:changedPwdTextField];
    self.changedPwdTextField = changedPwdTextField;
    
    UIButton *changePwd = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePwd setTitle:@"确定" forState:UIControlStateNormal];
    changePwd.layer.cornerRadius = 5;
    changePwd.backgroundColor = UnactiveButtonColor;
    [changePwd setTitleColor:WhiteColor forState:UIControlStateNormal];
    changePwd.titleLabel.font = TitleFont;
    [changePwd addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    self.changePwd = changePwd;
    [self.view addSubview:changePwd];
    
    
    [self.view1 makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        make.top.equalTo(20);
        make.height.equalTo(60);
    }];
    
    
    [self.oldPwdTextField makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.centerY.equalTo(self.view1);
        make.height.equalTo(40);
    }];

    [self.view2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view1.bottom).offset(1);
        make.height.equalTo(60);
    }];
    
    [self.changedPwdTextField makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.centerY.equalTo(self.view2);
        make.height.equalTo(40);
    }];


    [self.changePwd makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view2.bottom).offset(50);
        make.width.equalTo(kSCREENWIDTH-60);
        make.height.equalTo(40);
    }];
}

- (void)commit:(UIButton *)sender {
    
    if (![self validToChange]) return;
    
    [self.view endEditing:YES];
    YYWeakSelf
    [YYLoginManager changePasswordWithOldPassword:_oldPwdTextField.text newPwd:_changedPwdTextField.text completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    
}

/** 监听新旧密码的输入长度*/
- (void)observeLengthForTextField:(UITextField *)textField {
    //    if (textField == self.teleTextField) {
    //        self.pwdTextField.text = [SAMKeychain passwordForService:KEYCHAIN_SERVICE_LOGIN account:self.teleTextField.text];
    //    }
    //输入框都满足条件，则注册按钮可点击
    self.changePwd.enabled = [self validToChange];
    self.changePwd.backgroundColor = [self validToChange] ? ThemeColor : UnactiveButtonColor;
}

- (BOOL)validToChange {
    
    if(self.oldPwdTextField.text.length >= 6 && self.changedPwdTextField.text.length >= 6){
        
        return YES;
    }
    
    return NO;
}


#pragma textfield delegate ----

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.oldPwdTextField) {
        [self.changedPwdTextField becomeFirstResponder];
    }else {
        [self commit:nil];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
