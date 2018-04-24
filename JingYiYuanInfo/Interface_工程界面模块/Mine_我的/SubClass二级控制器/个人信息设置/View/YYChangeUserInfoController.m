//
//  YYChangeTelController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChangeUserInfoController.h"
#import "YYUser.h"
#import "YYCommonCell.h"
#import "NSString+Predicate.h"
#import "UITextField+LeftView.h"
#import "UIView+YYCategory.h"
#import "NSString+Predicate.h"
#import "YYTextFilter.h"

@interface YYChangeUserInfoController ()<YYTextFilterDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

/** textfilter*/
@property (nonatomic, strong) YYTextFilter *textfilter;

@end

@implementation YYChangeUserInfoController
{
    BOOL _validToCommit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GrayBackGroundColor;
    self.navigationItem.title = [NSString stringWithFormat:@"修改%@",self.cell.title.text];
    [self initSelf];
    [self.textField addTarget:self action:@selector(obserTextfield:) forControlEvents:UIControlEventEditingChanged];
    [self.textField addTarget:self action:@selector(endEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
}

- (void)initSelf {
    
    YYUser *user = [YYUser shareUser];
    NSString *detail = @"";
    NSString *placeHolder = @"";
    self.textfilter = [[YYTextFilter alloc] init];
    
    if ([self.cell.title.text isEqualToString:@"股龄"]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.autocorrectionType = UITextAutocorrectionTypeYes;
        placeHolder = @"股龄0-99";
        detail = user.guling;
        self.leftLabel.text = @"股龄(年):";
        [self.textfilter setNumberfilter:self.textField maxNum:100 delegate:self];
        
    }else if([self.cell.title.text isEqualToString:@"资金量"]) {
        
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.autocorrectionType = UITextAutocorrectionTypeYes;
        placeHolder = @"有效资金量";
        detail = user.capital;
        self.leftLabel.text = @"资金量(万):";
        [self.textfilter SetMoneyFilter:self.textField maxMoney:10000.f delegate:self];
        
    }else {
        placeHolder = self.cell.title.text;
        detail = self.cell.detail.text;
        self.leftLabel.text = [self.cell.title.text stringByAppendingString:@":"];
    }
    self.textField.text = detail;
    
    self.textField.placeholder = [@"请输入" stringByAppendingString:placeHolder];
    YYLog(@"文字长度%ld",self.cell.detail.text.length);
    
}

/** 监听textfield输入变化时的代理回调*/
- (void)obserTextfield:(UITextField *)textField {
    
    _validToCommit = [self validToCommit:textField.text];
    
    self.sendBtn.backgroundColor = _validToCommit ? ThemeColor : UnactiveButtonColor;
}

/** 监听textfield输入完成的代理回调*/
- (void)endEditing:(UITextField *)textField {
    
    
}

/** 提交更改信息*/
- (IBAction)commit:(UIButton *)sender {
    
    if (!_validToCommit) {
        return;
    }
    NSString *textFieldText = self.textField.text;
    if (!textFieldText.length && [self.paraKey isEqualToString:USERNAME]) {
        [SVProgressHUD showInfoWithStatus:@"用户昵称不能为空"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    if (textFieldText.length && [self.paraKey isEqualToString:@"email"]) {
        if (![NSString isValidEmail:textFieldText]) {
            [SVProgressHUD showInfoWithStatus:@"邮箱格式不正确"];
            [SVProgressHUD dismissWithDelay:1];
            return;
        }
    }
    

    YYWeakSelf
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,self.paraKey,@"act",self.textField.text,self.paraKey, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:mineChangeUserInfoUrl parameters:para success:^(id response) {
        [YYUser configUserInfoWithDic:response[@"userinfo"]];
        [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"1"}];
        if ([self.cell.title.text isEqualToString:@"股龄"]) {
            self.cell.detail.text = [self.textField.text stringByAppendingString:@"年"];
        }else if([self.cell.title.text isEqualToString:@"资金量"]) {
            self.cell.detail.text = [self.textField.text stringByAppendingString:@"万"];
        }else {
            self.cell.detail.text = self.textField.text;
        }
        
        NSString *toast = response[@"addintegral"];
        if (toast.length) {
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"修改成功获得 %@ 积分",toast]];
        }else {
            [SVProgressHUD showImage:nil status:@"修改成功"];
        }
        [SVProgressHUD dismissWithDelay:1];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}



- (BOOL)validToCommit:(NSString *)text {
    
    BOOL valid;
    if ([self.cell.title.text isEqualToString:@"股龄"]) {
        valid = [NSString isOnlyNumber:text];
        if ([text floatValue] > 99.f) {
            self.tipLabel.text = @"*股龄不能超过99年";
            valid = NO;
        }else {
            self.tipLabel.text = @"";
        }
    }else if([self.cell.title.text isEqualToString:@"资金量"]) {
        valid = [NSString isOnlyNumber:text];
        if ([text floatValue] > 10000.f) {
            self.tipLabel.text = @"*资金量不能超过10000万元";
            valid = NO;
        }else {
            self.tipLabel.text = @"";
        }
    }else if([self.cell.title.text isEqualToString:@"邮箱"]){
        valid = [NSString isValidEmail:text];
        self.tipLabel.text = valid ? @"" : @"*邮箱格式不正确";
    }else {
        valid = text.length;
        self.tipLabel.text = @"";
    }
    if (!text.length) {
        valid = NO;
    }

    return valid;
}


#pragma textField delegate  -----

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


@end
