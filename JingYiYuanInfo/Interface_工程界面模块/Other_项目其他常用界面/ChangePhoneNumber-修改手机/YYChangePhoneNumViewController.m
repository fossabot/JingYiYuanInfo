//
//  YYChangePhoneNumViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChangePhoneNumViewController.h"
#import "YYCountDownButton.h"
#import "NSString+Predicate.h"
#import "YYLoginManager.h"

@interface YYChangePhoneNumViewController ()

@property (weak, nonatomic) IBOutlet UITextField *telephoneText;
@property (weak, nonatomic) IBOutlet UITextField *verificationText;

@end

@implementation YYChangePhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)getVerification:(YYCountDownButton *)sender {
    
    if (![NSString isValidMobileNumber:self.telephoneText.text]) {
        return;
    }
    [sender countDownFromTime:60 unitTitle:@"s后可重发" completion:^(YYCountDownButton *countDownButton) {
        
    }];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"reg",KEYWORD,self.telephoneText.text,MOBILE, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:mineChangeTelGetYzmUrl parameters:para success:^(id response) {
//        status:1 成功 status:0 失败 3 失败,已经注册
        NSString *status = response[@"status"];
        if ([status isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else if ([status isEqualToString:@"0"]) {
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败，稍后再试"];
        }else {
            [SVProgressHUD showErrorWithStatus:@"手机号已注册，请更换未注册手机号码"];
        }
        
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];

}

- (IBAction)changeTelephone:(id)sender {
    
    [YYLoginManager resetTelephoneNumber:self.telephoneText.text verification:self.verificationText.text completion:^{

        YYUser *user = [YYUser shareUser];
        [user setMobile:self.telephoneText.text];
//        if (_completion) {
//            _completion();
//        }
    }];
    
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
