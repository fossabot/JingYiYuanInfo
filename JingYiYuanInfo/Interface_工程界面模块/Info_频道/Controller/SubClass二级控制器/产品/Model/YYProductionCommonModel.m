//
//  YYProductionCommonModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  普通产品模型

#import "YYProductionCommonModel.h"
#import <MJExtension/MJExtension.h>


#define sepecialDetailUrl @"http://yyapp.1yuaninfo.com/app/yyfwapp/goods_info.php?goodtpye=2&goodid="

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

- (NSString *)iosyprice {
    return [NSString stringWithFormat:@"￥%@",_iosyprice];
}

- (NSString *)ystate {
    
    if ([_ystate isEqualToString:@"1"]) {
        return @"在售";
    }else {
        return @"售罄";
    }
}


- (NSString *)webUrl {
    
    return [NSString stringWithFormat:@"%@%@",sepecialDetailUrl,_productionId];
}

@end
