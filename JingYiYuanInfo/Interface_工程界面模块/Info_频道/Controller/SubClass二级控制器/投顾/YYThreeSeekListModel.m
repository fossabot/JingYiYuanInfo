//
//  YYThreeSeekListModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  三找的列表页模型

#import "YYThreeSeekListModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYThreeSeekListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"recommend":@"YYCompanyModel",
             @"other":@"YYCompanyModel"
             };
}

@end
