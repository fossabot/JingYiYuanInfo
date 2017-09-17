//
//  YYBaseInfoModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseInfoModel.h"
#import <MJExtension/MJExtension.h>


@implementation YYBaseInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"hangqing":@"YYHotInfoModel",
             @"rank_arr":@"YYBaseHotModel"
             };
    
}


@end
