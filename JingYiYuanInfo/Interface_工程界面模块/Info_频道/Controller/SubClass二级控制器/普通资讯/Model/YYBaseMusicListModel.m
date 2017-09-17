//
//  YYBaseMusicListModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseMusicListModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYBaseMusicListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"m_arr":@"YYBaseMusicModel"
             };
}

@end
