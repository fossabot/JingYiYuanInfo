//
//  YYHotTagModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotTagModel.h"
#import "MJExtension.h"

@implementation YYHotTagModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"tagid":@"id"
             };
}


@end
