//
//  YYChangePwdController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChangePwdController.h"
#import "NSString+Predicate.h"
#import "YYLoginManager.h"

@interface YYChangePwdController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *changedPwdTextField;

@end

@implementation YYChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    //userid  oldpwd=旧密码   newpwd=新密码
}


- (IBAction)commit:(UIButton *)sender {
    
//    [YYLoginManager changePasswordWithOldPassword:_oldPwdTextField.text newPwd:_changedPwdTextField.text];
    
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
