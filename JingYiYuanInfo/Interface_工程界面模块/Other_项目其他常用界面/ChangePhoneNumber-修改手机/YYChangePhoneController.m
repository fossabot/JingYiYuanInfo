//
//  YYChangePhoneController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChangePhoneController.h"
#import "UITextField+LeftView.h"
#import "YYCountDownButton.h"

#import "YYLoginManager.h"
#import "NSString+Predicate.h"
#import "YYTextFilter.h"
#import "UIView+YYCategory.h"
@interface YYChangePhoneController ()<YYTextFilterDelegate,UITextFieldDelegate>

/** view1*/
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (strong, nonatomic) UITextField *telephoneText;
@property (strong, nonatomic) UITextField *verificationText;
/** verificationBtn*/
@property (nonatomic, strong) UIButton *verificationBtn;

/** changePwd*/
@property (nonatomic, strong) UIButton *changePhone;

/** textField filter*/
@property (nonatomic,strong) YYTextFilter *textFilterPhone;

/** textField filter*/
@property (nonatomic,strong) YYTextFilter *textFilterVerification;

@end

@implementation YYChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改手机";
    self.view.backgroundColor = GrayBackGroundColor;
    [self configSubView];
    [self configTextFilter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.changePhone cutRoundViewRadius:5];
}

- (void)configTextFilter {
    
    self.textFilterPhone = [[YYTextFilter alloc] init];
    [self.textFilterPhone SetFilter:self.telephoneText
                                 delegate:self
                                   maxLen:11
                                 allowNum:YES
                                  allowCH:NO
                              allowLetter:YES
                              allowLETTER:YES
                              allowSymbol:YES
                              allowOthers:nil];
    
    self.textFilterVerification = [[YYTextFilter alloc] init];
    [self.textFilterVerification SetFilter:self.verificationText
                                 delegate:self
                                   maxLen:6
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
    
    UITextField *telephoneText = [[UITextField alloc] init];
    telephoneText.delegate = self;
    telephoneText.font = TitleFont;
    telephoneText.placeholder = @"新手机号码";
    telephoneText.tintColor = ThemeColor;
    telephoneText.leftViewMode = UITextFieldViewModeAlways;
    [telephoneText setLeftTitle:@"新手机: "];
    [self.view1 addSubview:telephoneText];
    self.telephoneText = telephoneText;
    
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = WhiteColor;
    self.view2 = view2;
    [self.view addSubview:view2];
    
    UITextField *verificationText = [[UITextField alloc] init];
    verificationText.delegate = self;
    verificationText.font = TitleFont;
    verificationText.placeholder = @"验证码";
    verificationText.tintColor = ThemeColor;
    verificationText.leftViewMode = UITextFieldViewModeAlways;
    [verificationText setLeftTitle:@"验证码 "];
    [self.view2 addSubview:verificationText];
    self.verificationText = verificationText;
    
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
    [self.view2 addSubview:verificationBtn];
    
    
    UIButton *changePhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePhone setTitle:@"修改手机" forState:UIControlStateNormal];
    changePhone.backgroundColor = ThemeColor;
    [changePhone setTitleColor:WhiteColor forState:UIControlStateNormal];
    changePhone.titleLabel.font = TitleFont;
    [changePhone addTarget:self action:@selector(changePhoneNum) forControlEvents:UIControlEventTouchUpInside];
    self.changePhone = changePhone;
    [self.view addSubview:changePhone];
    
    
    [self.view1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.top.equalTo(100);
        make.height.equalTo(60);
    }];
    
    
    [self.telephoneText makeConstraints:^(MASConstraintMaker *make) {
        
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
    
    [self.verificationText makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.centerY.equalTo(self.view2);
        make.height.equalTo(40);
    }];
    
    [self.verificationBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.view2).offset(-YYInfoCellCommonMargin);
        make.centerY.equalTo(self.view2);
        make.width.equalTo(90);
        make.height.equalTo(30);
    }];
    
    
    [self.changePhone makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view2.bottom).offset(50);
        make.width.equalTo(kSCREENWIDTH/2);
        make.height.equalTo(40);
    }];
}


/** 修改手机号*/
- (void)changePhoneNum {
    
    YYWeakSelf
    [YYLoginManager resetTelephoneNumber:self.telephoneText.text verification:self.verificationText.text completion:^(BOOL success) {
       
        if (success) {
            
            [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"1"}];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}



/** 获取验证码*/
- (void)getVerificattion:(YYCountDownButton *)sender {
    
    BOOL isValidMobileNumber = [NSString isValidMobileNumber:self.telephoneText.text];
    if (isValidMobileNumber) {
        [sender countDownFromTime:60 unitTitle:@"s后重发" completion:^(YYCountDownButton *countDownButton) {
            
        }];
        //发送请求，获取验证码
        assert(@"发送请求获取验证码");
        
        [YYLoginManager getRegisterVerificationByMobile:self.telephoneText.text];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


@end
