//
//  YYUser.m
//  壹元服务
//
//  Created by VINCENT on 2017/7/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  

#import "YYUser.h"
#import <objc/runtime.h>



@implementation YYUser

YYSingletonM(User)

#pragma mark -- setters

- (void)setDeviceToken:(NSString *)deviceToken {
    
    [kUserDefaults setValue:deviceToken forKey:@"deviceToken"];
    [kUserDefaults synchronize];
}

/**
 userid setter方法，将userid存进userdefaults
 */
- (void)setUserid:(NSString *)userid {
    [kUserDefaults setValue:userid forKey:@"user_userid"];
    [kUserDefaults synchronize];
//    [YYUser alertNotification];
}

- (void)setUsername:(NSString *)username {
    [kUserDefaults setValue:username forKey:@"user_username"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setAvatar:(NSString *)avatar {
    [kUserDefaults setValue:avatar forKey:@"user_avatar"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setMobile:(NSString *)mobile {
    NSString *str = [NSString stringWithFormat:@"%@",mobile];
    [kUserDefaults setValue:str forKey:@"user_mobile"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setGuling:(NSString *)guling {
    NSString *str = [NSString stringWithFormat:@"%@",guling];
    [kUserDefaults setValue:str forKey:@"user_guling"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setCapital:(NSString *)capital {
    NSString *str = [NSString stringWithFormat:@"%@",capital];
    [kUserDefaults setValue:str forKey:@"user_capital"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setEmail:(NSString *)email {
    [kUserDefaults setValue:email forKey:@"user_email"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setQqnum:(NSString *)qqnum {
    [kUserDefaults setValue:qqnum forKey:@"user_qqnum"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setWeixin:(NSString *)weixin {
    [kUserDefaults setValue:weixin forKey:@"user_weixin"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setWeibo:(NSString *)weibo {
    [kUserDefaults setValue:weibo forKey:@"user_weibo"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setGroupid:(NSString *)groupid {
    NSString *str = [NSString stringWithFormat:@"%@",groupid];
    [kUserDefaults setValue:str forKey:@"user_groupid"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setExpiretime:(NSString *)expiretime {
//    NSString *temp = [expiretime substringToIndex:9];
    [kUserDefaults setValue:expiretime forKey:@"user_expiretime"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setIntegral:(NSString *)integral {
    
    NSString *str = [NSString stringWithFormat:@"%@",integral];
    YYLog(@"我的积分   -------    %@",str);
    if (!str.length) {
        str = @"0";
    }
    [kUserDefaults setValue:str forKey:@"user_integral"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setWebfont:(CGFloat)webfont {
    [kUserDefaults setFloat:webfont forKey:@"webfont"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}

- (void)setOnlyWIFIPlay:(BOOL)onlyWIFIPlay {
    [kUserDefaults setBool:onlyWIFIPlay forKey:@"onlyWIFIPlay"];
    [kUserDefaults synchronize];
    [YYUser alertNotification];
}


#pragma mark -- getters

- (NSString *)deviceToken {
    return [kUserDefaults objectForKey:@"deviceToken"];
}

- (NSString *)userid{
    return [kUserDefaults objectForKey:@"user_userid"];
}

- (NSString *)username {
    return [kUserDefaults objectForKey:@"user_username"];
}

- (NSString *)avatar {
    
    return [kUserDefaults objectForKey:@"user_avatar"];
}

- (NSString *)mobile{
    return [kUserDefaults objectForKey:@"user_mobile"];
}

- (NSString *)guling{
    return [kUserDefaults objectForKey:@"user_guling"];
}

- (NSString *)capital{
    return [kUserDefaults objectForKey:@"user_capital"];
}

- (NSString *)email{
    return [kUserDefaults objectForKey:@"user_email"];
}

- (NSString *)qqnum{
    return [kUserDefaults objectForKey:@"user_qqnum"];
}

- (NSString *)weixin{
    return [kUserDefaults objectForKey:@"user_weixin"];
}

- (NSString *)weibo{
    return [kUserDefaults objectForKey:@"user_weibo"];
}

- (NSString *)groupid{
    
    return [kUserDefaults objectForKey:@"user_groupid"];
}

- (NSString *)expiretime{
    
    NSString *temp = [kUserDefaults objectForKey:@"user_expiretime"];
    return [temp substringToIndex:10];
}

- (NSString *)integral {
    NSString *integralStr = [NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:@"user_integral"]];
    if (integralStr.length == 0 || !self.isLogin) {
        return @"0";
    }
    return integralStr;
}

- (CGFloat)webfont{
    CGFloat fontScale = [kUserDefaults floatForKey:@"webfont"];
    if (!fontScale) {
        return 1.0;
    }
    return fontScale;
}

- (BOOL)onlyWIFIPlay {
    return [kUserDefaults boolForKey:@"onlyWIFIPlay"];
}

- (NSString *)webFontStr {
    CGFloat webfont = self.webfont;
    if (webfont == 1.0f) {
        return @"标准";
    }else if (webfont == 1.2f) {
        return @"大";
    }else if (webfont == 1.5f) {
        return @"极大";
    }else if (webfont == 2.0f) {
        return @"超级大";
    }
    return @"标准";
}

- (NSInteger)currentPoint {
    
    NSArray *fontArr = @[@1.0f,@1.2f,@1.5f,@2.0f];
    CGFloat currentFont = [self webfont];
    return [fontArr indexOfObject:@(currentFont)]+1;
}

- (BOOL)isLogin{
    return [kUserDefaults boolForKey:LOGINSTATUS];
}

- (NSString *)setUp {
    return [kUserDefaults stringForKey:setUpInfo];
}

- (void)setSetUp:(NSString *)setUp {
    [kUserDefaults setValue:setUp forKey:setUpInfo];
    [kUserDefaults synchronize];
}


/**
 填充个人信息
 */
+ (void)configUserInfoWithDic:(NSDictionary *)infoDic {
    
//    userid,avatar(头	像),mobile,guling,capital(资金),email,qqnum,weixin,weibo,groupid(会员级别)
//    NSArray *properties = [self getAllProperties];
    
    for (NSString *property in [infoDic allKeys]) {
        NSString *user_property = [NSString stringWithFormat:@"user_%@",property];
        if (![infoDic[property] isKindOfClass:[NSNull class]]) {
//            NSString *str = (NSString *)infoDic[property];
            [kUserDefaults setObject:infoDic[property] forKey:user_property];
        }else{
            [kUserDefaults setObject:@"" forKey:user_property];
        }
    }
    [kUserDefaults setBool:YES forKey:LOGINSTATUS];
    [kUserDefaults synchronize];
    
}

/**
 用户登出，删除所有用户信息
 */
+ (void)logOut {
    
    YYUser *user = [self shareUser];
    [[SDImageCache sharedImageCache] removeImageForKey:user.avatar withCompletion:^{
        
    }];
    
    //将user的各属性置为nil
    
    YYWeakSelf
    [[kUserDefaults dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
        
         if([key hasPrefix:@"user_"])
         {
             [kUserDefaults removeObjectForKey:key];
         }
         [kUserDefaults setBool:NO forKey:LOGINSTATUS];
         [kUserDefaults synchronize];
         [weakSelf alertNotification];
         
     }];
    
//    [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"1"}];
//    
//    NSArray *properties = [self getAllProperties];
//    for (NSString *property in properties) {
//        [kUserDefaults removeObjectForKey:property];
//    }
}

/** 提醒代理 该干活了*/
+ (void)alertNotification {

    [kNotificationCenter postNotificationName:YYUserInfoDidChangedNotification object:nil userInfo:@{LASTLOGINSTATUS:@"1"}];
}

/**
 获取全部属性数组

 @return 属性数组
 */
+ (NSArray *)getAllProperties {
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArr = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);

        [propertiesArr addObject:[NSString stringWithUTF8String:propertyName]];
        
    }
    
    free(properties);
    return propertiesArr;
}



@end
