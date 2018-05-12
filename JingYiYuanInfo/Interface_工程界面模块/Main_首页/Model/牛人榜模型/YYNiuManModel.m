//
//  YYNiuManModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManModel.h"
#import "NSCalendar+YYCommentDate.h"
#import <MJExtension/MJExtension.h>

@implementation YYNiuManModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"niu_id":@"id"
             };
}

- (NSString *)niu_modtime {
    NSString *modtime = [NSCalendar commentDateByOriginalDate:_niu_modtime withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:@"%@更新",modtime];
}

- (NSString *)niu_pop {
    
    NSInteger pop = [_niu_pop integerValue];
    if (pop >= 10000) {
        return [NSString stringWithFormat:@" %.2lf万",(float)pop/10000];
    }
    return [@" " stringByAppendingString:_niu_pop];
}

- (NSString *)niu_follow {
    
    NSInteger pop = [_niu_follow integerValue];
    if (pop >= 10000) {
        return [NSString stringWithFormat:@" %.2lf万",(float)pop/10000];
    }
    return [@" " stringByAppendingString:_niu_follow];
}

@end
