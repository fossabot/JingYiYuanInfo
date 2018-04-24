//
//  YYMainPostmsgModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainPostmsgModel.h"
#import "MJExtension.h"

@implementation YYMainPostmsgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"postmsg_id":@"id"
             };
}

- (NSString *)formatterTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:_addtime];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *returnDate = [formatter stringFromDate:date];
    
    _formatterTime = returnDate;
    return returnDate;
}

@end


