//
//  NSString+Predicate.h
//  iOS+Category
//
//

#import <Foundation/Foundation.h>

@interface NSString (Predicate)

//有效的电话号码
+ (BOOL) isValidMobileNumber:(NSString *)phoneNumber;

//只能由数字和26个英文字母组成的密码验证
+ (BOOL) isValidCorrectPasswordFormat:(NSString *)password;

//有效的真实姓名
+ (BOOL) isValidRealName:(NSString *)code;

//是否只有中文
+ (BOOL) isOnlyChinese:(NSString *)chinese;

//有效的验证码(根据自家的验证码位数进行修改)
+ (BOOL) isValidVerifyCode:(NSString *)name;

//有效的银行卡号
+ (BOOL) isValidBankCardNumber:(NSString *)bankCardNumber;

//有效的邮箱
+ (BOOL) isValidEmail:(NSString *)email;

//有效的字母数字密码
+ (BOOL) isValidAlphaNumberPassword:(NSString *)numPassword;

//检测有效身份证
//15位
+ (BOOL) isValidIdentifyFifteen:(NSString *)identifyFifteen;

//18位
+ (BOOL) isValidIdentifyEighteen:(NSString *)identifyEighteen;

//限制只能输入数字
+ (BOOL) isOnlyNumber:(NSString *)number;

@end
