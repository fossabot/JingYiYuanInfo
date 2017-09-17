//
//  YYHotModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  热搜榜的模型

#import "YYHotModel.h"
#import "MJExtension.h"


@implementation YYHotModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"tag_arr":@"YYHotTagModel",
             @"hot_arr":@"YYHotHotModel",
             @"info_arr":@"YYHotInfoModel"
             };
}

@end
