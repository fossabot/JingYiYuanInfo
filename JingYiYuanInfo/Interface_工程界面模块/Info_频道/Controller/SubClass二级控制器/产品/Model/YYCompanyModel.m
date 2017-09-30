//
//  YYCompanyModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCompanyModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYCompanyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
  
    return @{
             @"comId":@"id"
             };
}

- (NSString *)logo {
    
    if (![_logo containsString:@"http"]) {
        return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_logo];
    }
    return _logo;
}

@end
