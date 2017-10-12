//
//  YYLoginManager.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYLoginManager.h"
#import "NSString+Predicate.h"
#import "NSString+YYSecretaryPassword.h"
#import "YYUser.h"

@implementation YYLoginManager

#pragma mark -------  外部调用接口  ------------------------------------------

//根据userid获取个人信息
+ (void)getUserInfo {
    
    YYUser *user = [YYUser shareUser];
    [YYHttpNetworkTool GETRequestWithUrlstring:userInfoUrl parameters:@{USERID:user.userid} success:^(id response) {
        
        if (response) {
            
            [YYUser configUserInfoWithDic:response];
            [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"1"}];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}

/** 登录时 验证账号密码*/
+ (void)loginSucceedWithAccount:(NSString *)account password:(NSString *)password responseMsg:(void (^)(BOOL success))success{
    
    BOOL validToLogin = [self validAccount:account password:password verification:nil];

    if (!validToLogin) {//格式不正确，不能登录
        return;
    }
    
    YYUser *user = [YYUser shareUser];
    //用afnetworking进行网络请求，responseMsg返回登录账号密码验证结果，直接用SVProgressHud负责弹出提示框
    password = [password translateIntoScretaryPassword];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:account,MOBILE,password,PASSWORD,user.deviceToken,@"devicetoken",@"1",@"mobiletype", nil];
#warning 登录接口
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [YYHttpNetworkTool GETRequestWithUrlstring:signinUrl parameters:para success:^(id response) {
        // 0 代表失败   1代表成功
        if (response) {
            NSString *status = response[@"state"];
            if ([status isEqualToString:@"0"]) {
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
                success(NO);
            }else if ([status isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [YYUser configUserInfoWithDic:response[USERINFO]];
                //在success回调里通知更新个人信息
                success(YES);
            }
        }
        [SVProgressHUD dismissWithDelay:1];
        
    } failure:^(NSError *error) {
        //封装的方法内部有网络不佳的提醒，网络请求失败
        success(NO);
        [SVProgressHUD dismissWithDelay:1];
    } showSuccessMsg:nil];
    
}


/** 退出登录*/
+ (void)logOutAccountSuccess:(void(^)(BOOL))success {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary* para = [NSDictionary dictionaryWithObjectsAndKeys:@"logout",@"act",user.mobile,MOBILE,user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:logOutUrl parameters:para success:^(id response) {
        
        [YYUser logOut];
        success(YES);
    } failure:^(NSError *error) {
        success(NO);
        [SVProgressHUD showErrorWithStatus:@"退出失败"];
        [SVProgressHUD dismissWithDelay:1];
    } showSuccessMsg:nil];
}

/**  注册验证账号密码验证码*/
+ (void)registeAccount:(NSString *)account verification:(NSString *)verification password:(NSString *)password response:(void (^)(BOOL success))success {
    
    BOOL validToLogin = [self validAccount:account password:password verification:verification];
    if (!validToLogin) {//格式不正确，不能登录
        return;
    }
    
    __block NSString *passwordStr = password;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];

#warning 更改了注册接口  注册时先获取userid
    YYUser *user = [YYUser shareUser];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"getuserid",@"act",user.deviceToken,@"devicetoken",@"1",@"mobiletype", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:firstConfigUrl parameters:dic success:^(id response) {
        
        if (response) {
            NSString *userid = response[@"userid"];
            
            
            //用afnetworking进行网络请求，responseMsg返回登录账号密码验证结果，controller负责弹出提示框
            passwordStr = [passwordStr translateIntoScretaryPassword];
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:account,MOBILE,passwordStr,PASSWORD,verification,YZM,user.deviceToken,@"devicetoken",@"1",@"mobiletype",userid,USERID, nil];
#warning 注册接口
            [YYHttpNetworkTool GETRequestWithUrlstring:signupUrl parameters:para success:^(id response) {
                
                //success只是访问网络成功，并没有说明登录成功或失败，response里会有返回的登录信息response[@"status"]来判断登录成功与否，然后在调成功的回调
                //status:0（不能为空）,1（成功）,2（插入数据库失败）,3（验证码超时）,4（验证码错误）
                if (response) {
                    NSString *status = response[@"state"];
                    if ([status isEqualToString:@"1"]) {
                        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                        [YYUser configUserInfoWithDic:response[USERINFO]];
                        //在success回调里通知更新个人信息
                        success(YES);
                    }else if ([status isEqualToString:@"0"]) {
                        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
                    }else if ([status isEqualToString:@"2"]) {
                        [SVProgressHUD showErrorWithStatus:@"系统繁忙，请稍后再试"];
                    }else if ([status isEqualToString:@"3"]) {
                        [SVProgressHUD showErrorWithStatus:@"验证码超时"];
                    }else if ([status isEqualToString:@"4"]) {
                        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
                    }
                }
                [SVProgressHUD dismissWithDelay:1];
                
            } failure:^(NSError *error) {
                //封装的方法内部有网络不佳的提醒，网络请求失败
                success(NO);
                [SVProgressHUD dismissWithDelay:1];
            } showSuccessMsg:nil];
            
            
            
            
        }
        [SVProgressHUD dismissWithDelay:1];
       
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithDelay:1];
    } showSuccessMsg:nil];
    
    
}



/** 重置密码*/
+ (void)resetPasswordWithAccount:(NSString *)account password:(NSString *)password verification:(NSString *)verification response:(void (^)(BOOL success))success {
    BOOL validToLogin = [self validAccount:account password:password verification:verification];
    if (!validToLogin) {//格式不正确，不能登录
        return;
    }

    //用afnetworking进行网络请求，responseMsg返回登录账号密码验证结果
    password = [password translateIntoScretaryPassword];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:account,MOBILE,password,PASSWORD,verification,YZM, nil];
#warning 重置密码接口
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [YYHttpNetworkTool GETRequestWithUrlstring:changenewPwdUrl parameters:para success:^(id response) {
        //status:1成功 2验证码错误或者超时,3入库失败(系统错误)
        if (response) {
            NSString *status = response[STATUS];
            if ([status isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
                success(YES);
            }else if ([status isEqualToString:@"2"]) {
                [SVProgressHUD showErrorWithStatus:@"验证码错误或已超时"];
            }else {
                [SVProgressHUD showInfoWithStatus:@"系统繁忙，请稍后再试"];
            }
        }
        [SVProgressHUD dismissWithDelay:1];

        
    } failure:^(NSError *error) {
        //封装的方法内部有网络不佳的提醒，网络请求失败
        success(NO);
        [SVProgressHUD dismissWithDelay:1];
    } showSuccessMsg:nil];
    
    
}

/** 重置手机号*/
+ (void)resetTelephoneNumber:(NSString *)telephoneNum verification:(NSString *)verification completion:(void(^)(BOOL success))completion{
    
    if (telephoneNum.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (![NSString isValidMobileNumber:telephoneNum]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:telephoneNum,MOBILE,verification,YZM, nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [YYHttpNetworkTool GETRequestWithUrlstring:mineChangeTelUrl parameters:para success:^(id response) {
        if (response) {
            
            //        status:0 不能为空,1成功,2插入数据库失败,3验证码超时,4验证码错误
            NSString *status = response[STATUS];
            if ([status isEqualToString:@"1"]) {
                YYUser *user = [YYUser shareUser];
                [user setMobile:telephoneNum];
                [SVProgressHUD showSuccessWithStatus:@"修改成功，您可以使用新手机号登录"];
                if (completion) {
                    completion(YES);
                }
            }else if ([status isEqualToString:@"0"]) {
                [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
            }else if ([status isEqualToString:@"2"]) {
                [SVProgressHUD showErrorWithStatus:@"服务器繁忙，稍后再试"];
            }else if ([status isEqualToString:@"3"]) {
                [SVProgressHUD showErrorWithStatus:@"验证码超时"];
            }else if ([status isEqualToString:@"4"]) {
                [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            }
        }
        [SVProgressHUD dismissWithDelay:1];
    } failure:^(NSError *erro) {
        completion(NO);
        [SVProgressHUD dismissWithDelay:1];
    } showSuccessMsg:nil];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 注册获取验证码

 @param mobile 手机号
 */
+ (void)getRegisterVerificationByMobile:(NSString *)mobile {
    
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:mobile,MOBILE,@"reg",KEYWORD, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:registerVerificationUrl parameters:para success:^(id response) {
        //status:1 (成功) 0 (失败) 3 (失败,已经注册)
        if (response) {
            NSString *status = response[STATUS];
            if ([status isEqualToString:@"1"]) {
                [SVProgressHUD showInfoWithStatus:@"验证码即将发送至手机"];
            }else if ([status isEqualToString:@"0"]) {
                [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
            }else if ([status isEqualToString:@"3"]) {
                [SVProgressHUD showInfoWithStatus:@"手机号已注册"];
            }
            [SVProgressHUD dismissWithDelay:1];
        }
        
    } failure:^(NSError *erro) {
        
    } showSuccessMsg:nil];
    
}


/**
 *  修改密码
 */
+ (void)changePasswordWithOldPassword:(NSString *)oldPwd newPwd:(NSString *)newPwd completion:(void(^)())completion{
 
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,oldPwd,@"oldpwd",newPwd,@"newpwd", nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [YYHttpNetworkTool GETRequestWithUrlstring:mineChangePwdUrl parameters:para success:^(id response) {
        if (response) {
            
            if ([response[STATUS] isEqualToString:@"0"]) {
                [SVProgressHUD showErrorWithStatus:@"旧密码错误，请重新输入"];
            }else if ([response[STATUS] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功，可以使用新密码登录了"];
                completion();
            }
        }
        [SVProgressHUD dismissWithDelay:1];
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithDelay:1];
    } showSuccessMsg:nil];
}



/**
 重置密码或者叫忘记密码时获取验证码的方法

 @param mobile 手机号
 */
+ (void)getResetPasswordVerificationByMobile:(NSString *)mobile {
    
//    参数 mobile(手机号) 返回值 status:1 成功 status:0失败
    //发送请求，获取验证码
    assert(@"发送请求获取验证码");
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:mobile,MOBILE, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:resetpwdVerificationUrl parameters:para success:^(id response) {

        if (response) {
            if ([response[STATUS] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
            }
        }

    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];

}



/** 本地初步验证账号密码验证码的格式正确性*/
+ (BOOL)validAccount:(NSString *)account password:(NSString *)password verification:(NSString *)verification {
    
    if (account && ![NSString isValidMobileNumber:account] ) {
        //提醒手机格式不对
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        [SVProgressHUD dismissWithDelay:1];
        return  NO;
    }
    if (password && password.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码长度应大于6位"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    }
    if (verification && verification.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"验证码格式不正确"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    }

    return YES;
}

@end
