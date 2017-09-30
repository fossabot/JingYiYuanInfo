//
//  YYProductionCommonModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  普通产品模型

#import "YYProductionCommonModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYProductionCommonModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"productionId":@"id"
             };
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

- (NSString *)yprice {
    return [NSString stringWithFormat:@"￥%@",_yprice];
}

- (NSString *)ystate {
    
    if ([_ystate isEqualToString:@"1"]) {
        return @"在售";
    }else {
        return @"售罄";
    }
}


@end
