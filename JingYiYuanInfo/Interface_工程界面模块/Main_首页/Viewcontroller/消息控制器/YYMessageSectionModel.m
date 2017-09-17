//
//  YYMessageSectionModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMessageSectionModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYMessageSectionModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"info":@"YYMessageModel"
             };
}


- (NSString *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM月dd日";
    NSDate *now = [NSDate date];
    NSString *today = [dateFormatter stringFromDate:now];
    if ([today isEqualToString:_date]) {
        return @"今天";
    }else {
        return _date;
    }
    
}

@end
