//
//  YYCompanyListModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCompanyListModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYCompanyListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"com_arr":@"YYCompanyModel"
             };
}

@end
