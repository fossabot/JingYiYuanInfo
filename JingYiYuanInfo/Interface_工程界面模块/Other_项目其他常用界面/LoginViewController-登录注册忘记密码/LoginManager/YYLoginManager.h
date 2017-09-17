//
//  YYLoginManager.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYLoginManager : NSObject


/**
 登录时 验证账号密码

 @param account 账号
 @param password 密码
 @param success 返回BOOL值 成功或者失败
 */

+ (void)loginSucceedWithAccount:(NSString *)account password:(NSString *)password responseMsg:(void (^)(BOOL success))success;


/**
 注册验证账号密码验证码

 @param account 账号
 @param verification 验证码
 @param password 密码
 @param success 成功回调
 */

+ (void)registeAccount:(NSString *)account verification:(NSString *)verification password:(NSString *)password response:(void (^)(BOOL success))success;


/**
 重置密码

 @param account 手机号
 @param password 新密码
 @param verification 验证码
 @param success 成功回调
 */

+ (void)resetPasswordWithAccount:(NSString *)account password:(NSString *)password verification:(NSString *)verification response:(void (^)(BOOL success))success;


/**
 重设手机号，更换后则用新手机号登陆

 @param telephoneNum 新手机号
 @param verification 验证码
 */
+ (void)resetTelephoneNumber:(NSString *)telephoneNum  verification:(NSString *)verification completion:(void(^)())completion;



/**
 修改密码

 @param oldPwd 旧密码
 @param newPwd 新密码
 */
+ (void)changePasswordWithOldPassword:(NSString *)oldPwd newPwd:(NSString *)newPwd;






@end
