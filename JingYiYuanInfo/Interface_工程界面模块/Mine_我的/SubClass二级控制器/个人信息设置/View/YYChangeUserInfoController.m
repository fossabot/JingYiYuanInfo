//
//  YYChangeTelController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChangeUserInfoController.h"
#import "YYUser.h"

#import "NSString+Predicate.h"

@interface YYChangeUserInfoController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation YYChangeUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"修改%@",self.cell.textLabel.text];
    self.textField.placeholder = self.cell.textLabel.text;
    self.textField.text = self.cell.detailTextLabel.text;
}

/** 提交更改信息*/
- (IBAction)commit:(UIButton *)sender {
    
    NSString *textFieldText = self.textField.text;
    if (!textFieldText.length && [self.paraKey isEqualToString:USERNAME]) {
        [SVProgressHUD showInfoWithStatus:@"用户昵称不能为空"];
        return;
    }
    if (textFieldText.length && [self.paraKey isEqualToString:@"email"]) {
        if (![NSString isValidEmail:textFieldText]) {
            [SVProgressHUD showInfoWithStatus:@"邮箱格式不正确"];
            return;
        }
    }
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,self.paraKey,@"act",self.textField.text,self.paraKey, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:mineChangeUserInfoUrl parameters:para success:^(id response) {
        [YYUser configUserInfoWithDic:response[@"userinfo"]];
        self.cell.detailTextLabel.text = self.textField.text;
    } failure:^(NSError *error) {
        
    } showSuccessMsg:@"修改成功"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
