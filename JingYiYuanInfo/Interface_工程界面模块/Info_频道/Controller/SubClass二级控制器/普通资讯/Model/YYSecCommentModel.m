//
//  YYSecCommentModel.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSecCommentModel.h"
#import <MJExtension/MJExtension.h>
#import "NSCalendar+YYCommentDate.h"

@implementation YYSecCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"secComment_id":@"id"
             };
}

- (NSString *)name {
    
    if (_to_user_name) {
        return [NSString stringWithFormat:@"%@||回复%@",_from_user_name,_to_user_name];
    }
    return [NSString stringWithFormat:@"%@",_from_user_name];
}

- (NSString *)create_date {
    
    return [NSCalendar commentDateByOriginalDate:_create_date withDateFormat:yyyyMMddHHmmss];
}

@end
