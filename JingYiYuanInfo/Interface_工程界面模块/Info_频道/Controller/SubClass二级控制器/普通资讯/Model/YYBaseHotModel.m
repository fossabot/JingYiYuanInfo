//
//  YYBaseHotModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseHotModel.h"

#import <MJExtension/MJExtension.h>

@implementation YYBaseHotModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"hotId":@"id"
             };
}

@end
