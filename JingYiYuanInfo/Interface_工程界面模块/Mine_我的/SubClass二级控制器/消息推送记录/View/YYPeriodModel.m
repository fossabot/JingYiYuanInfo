//
//  YYPeriodModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPeriodModel.h"
#import <MJExtension/MJExtension.h>
#import "NSCalendar+YYCommentDate.h"

@implementation YYPeriodModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"periodId":@"id"
             };
}

- (NSString *)time {
    
    return [NSCalendar commentDateByOriginalDate:_time withDateFormat:yyyyMMddHHmmss];
}

- (NSString *)webUrl {
    return [NSString stringWithFormat:@"%@%@",periodJointUrl,_periodId];
}




@end
