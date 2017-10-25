//
//  YYProjectModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProjectModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYProjectModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"projectId":@"id",
             @"desc":@"description"
             };
}


- (NSString *)webUrl {
    return [NSString stringWithFormat:@"%@%@",projecyJointUrl,_projectId];
}

- (NSString *)picurl {
    
    if ([_picurl containsString:@"http"]) {
        return _picurl;
    }
    return [NSString stringWithFormat:@"%@%@",yyfwJointUrl,_picurl];
}

- (NSString *)label {
    
    if ([_label isEqualToString:@"1"]) {
        return @"热";
    }else if ([_label isEqualToString:@"2"]) {
        return @"荐";
    }else {
        return @"推";
    }
}

@end
