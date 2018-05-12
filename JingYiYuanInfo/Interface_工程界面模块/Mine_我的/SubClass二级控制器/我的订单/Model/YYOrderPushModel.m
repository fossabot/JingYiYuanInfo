//
//  YYOrderPushModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/31.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYOrderPushModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYOrderPushModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"pushId":@"id"
             };
}

- (NSString *)addtime {
    return [NSString stringWithFormat:@"服务时间：%@",_addtime];
}

- (NSString *)gpdm {
    return [NSString stringWithFormat:@"代码名称：%@",_gpdm];
}

- (NSString *)stateImageName {
    if ([_isgain isEqualToString:@"0"]) {
        return @"order_success";
    }else if ([_isgain isEqualToString:@"1"]){
        return @"order_fail";
    }else {
        return @"order_holding";
    }
}

- (NSString *)isgain {
    
    if ([_isgain isEqualToString:@"0"]) {
        return @"成功";
    }else if ([_isgain isEqualToString:@"1"]){
        return @"失败";
    }else {
        return @"持股中";
    }
}



@end
