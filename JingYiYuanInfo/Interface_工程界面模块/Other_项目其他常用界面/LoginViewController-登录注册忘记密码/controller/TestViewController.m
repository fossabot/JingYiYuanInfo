//
//  TestViewController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/10.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "TestViewController.h"
#import "YYTextFilter.h"
#import "UITextField+LeftView.h"

@interface TestViewController ()<UITextFieldDelegate,YYTextFilterDelegate>

/** teleTextField*/
@property (nonatomic, strong) UITextField *teleTextField;

@property (nonatomic,strong) YYTextFilter *textFilterAccount;

@property (nonatomic, strong) UIView *container;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = GrayColor;
    self.container = container;
    [self.view addSubview:container];
    
    UITextField *teleTextField = [[UITextField alloc] init];
    teleTextField.delegate = self;
    teleTextField.font = TitleFont;
    teleTextField.placeholder = @"请输入手机号";
    teleTextField.tintColor = ThemeColor;
    teleTextField.returnKeyType = UIReturnKeyNext;
    [self.container addSubview:teleTextField];
    self.teleTextField = teleTextField;
    
    UIButton *fanhui = [UIButton buttonWithType:UIButtonTypeCustom];
    [fanhui setTitle:@"fanhui" forState:UIControlStateNormal];
    fanhui.backgroundColor = [UIColor redColor];
    [fanhui addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fanhui];
    
    [self.container makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(YYTopNaviHeight+40);
        make.width.equalTo(kSCREENWIDTH-60);
    }];
    
    [self.teleTextField makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(200);
        make.left.right.equalTo(self.view);
        make.height.equalTo(35);
        make.bottom.equalTo(self.container.bottom).offset(-10);
    }];
    
    [fanhui makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(50);
        make.top.equalTo(400);
        make.width.height.equalTo(50);
    }];
    
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
    
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
