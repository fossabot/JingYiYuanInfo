//
//  YYProductionVIPModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProductionVIPModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYProductionVIPModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"vipId":@"id"
             };
}

- (NSString *)sellstate {
    
    if ([_sellstate isEqualToString:@"1"]) {
        
        return @"在售";
    }else {
        
        return @"售罄";
    }
}

@end
