//
//  NSString+YYSecretaryPassword.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "NSString+YYSecretaryPassword.h"
#import "NSString+MD5.h"


static NSString * const salt = @"beijingjingyiyuanzixunfuwuyouxiangongsi";

@implementation NSString (YYSecretaryPassword)

-(NSString *)translateIntoScretaryPassword {
    
    return [[self stringByAppendingString:salt] md5WithString];
    
}

@end
