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
    oldPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    [oldPwdTextField setLeftTitle:@"旧密码: "];
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
    [changedPwdTextField setLeftTitle:@"新密码: "];
    [self.view2 addSubview:changedPwdTextField];
    self.changedPwdTextField = changedPwdTextField;
    
    
    UIButton *changePwd = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePwd setTitle:@"修改密码" forState:UIControlStateNormal];
    changePwd.backgroundColor = ThemeColor;
    [changePwd setTitleColor:WhiteColor forState:UIControlStateNormal];
    changePwd.titleLabel.font = TitleFont;
    [changePwd addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    self.changePwd = changePwd;
    [self.view addSubview:changePwd];
    
    
    [self.view1 makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        make.top.equalTo(100);
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
        make.width.equalTo(kSCREENWIDTH/2);
        make.height.equalTo(40);
    }];
}

- (void)commit:(UIButton *)sender {
    
    if (![self validToChange]) {
        [SVProgressHUD showErrorWithStatus:@"密码格式有误"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    YYWeakSelf
    
    
    [YYLoginManager changePasswordWithOldPassword:_oldPwdTextField.text newPwd:_changedPwdTextField.text completion:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (BOOL)validToChange {
    if(self.oldPwdTextField.text.length >= 6 && self.changedPwdTextField.text.length >= 6){
        
        return YES;
    }else {
        return NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
