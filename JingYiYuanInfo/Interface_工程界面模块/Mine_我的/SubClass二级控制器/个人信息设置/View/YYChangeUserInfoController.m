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

@interface YYChangeUserInfoController ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation YYChangeUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GrayBackGroundColor;
    self.navigationItem.title = [NSString stringWithFormat:@"修改%@",self.cell.title.text];
    
    [self.sendBtn addTarget:self action:@selector(obserTextfield:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)initSelf {
    
    YYUser *user = [YYUser shareUser];
    NSString *detail = @"";
    NSString *placeHolder = @"";
    if ([self.cell.title.text isEqualToString:@"股龄"]) {
        self.textField.keyboardType = UIKeyboardTypePhonePad;
        placeHolder = @"股龄";
        detail = user.guling;
    }else if([self.cell.title.text isEqualToString:@"资金量"]) {
        self.textField.keyboardType = UIKeyboardTypePhonePad;
        placeHolder = @"资金量";
        detail = user.capital;
    }else {
        placeHolder = self.cell.title.text;
        detail = self.cell.detail.text;
    }
    self.textField.text = detail;
    
    self.textField.placeholder = [@"请输入" stringByAppendingString:placeHolder];
    YYLog(@"文字长度%ld",self.cell.detail.text.length);
    
    if ([self.cell.title.text isEqualToString:@"股龄"]) {
        
        self.leftLabel.text = @"股龄(年):";
        
    }else if([self.cell.title.text isEqualToString:@"资金量"]) {
        
        self.leftLabel.text = @"资金量(万):";
    }else {
        
        self.leftLabel.text = [self.cell.title.text stringByAppendingString:@":"];
    }
}

- (void)obserTextfield:(UITextField *)textField {
    
    self.sendBtn.backgroundColor = [self validToCommit] ? ThemeColor : UnactiveButtonColor;
}

/** 提交更改信息*/
- (IBAction)commit:(UIButton *)sender {
    
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
        self.cell.detail.text = self.textField.text;
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




- (BOOL)validToCommit {
    return self.textField.text.length;
}

@end
