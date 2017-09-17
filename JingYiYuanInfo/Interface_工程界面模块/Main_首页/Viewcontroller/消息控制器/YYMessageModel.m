//
//  YYMessageModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/9/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  首页消息的模型数据

#import "YYMessageModel.h"
#import "MJExtension.h"
#import "NSCalendar+YYCommentDate.h"

@implementation YYMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"msgId":@"id"
             };
}

//- (NSString *)addtime {
//    
//    return [NSCalendar commentDateByOriginalDate:_addtime withDateFormat:@"yyyy-MM"];
//}

@end
