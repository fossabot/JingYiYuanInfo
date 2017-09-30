//
//  YYRelativeProductionModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYRelativeProductionModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYRelativeProductionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"produtionId":@"id"
             };
}

@end
