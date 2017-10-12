//
//  YYSearchList.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSearchList.h"
#import "MJExtension.h"
#import "YYSearchModel.h"

@implementation YYSearchList

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             
             @"art_arr":@"YYSearchModel",
             @"vid_arr":@"YYSearchModel",
             @"sh_arr":@"YYSearchModel",
             @"nar_arr":@"YYSearchModel",
             @"sm_arr":@"YYSearchModel",
             @"sa_arr":@"YYSearchModel"
             
             };
}

@end
