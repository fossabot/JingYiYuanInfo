//
//  YYChannel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannel.h"
#import "MJExtension.h"


@implementation YYChannel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"subtitles":@"YYSubtitle"
             };
}

@end
