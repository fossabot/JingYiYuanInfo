//
//  YYOrderModel.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYOrderModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"orderId":@"id"
             };
}

- (NSString *)packname {
    
    return [NSString stringWithFormat:@"产品:%@",_packname];
}

- (NSString *)unique_ordernum {
    
    if (_unique_ordernum.length) {
        
        return [NSString stringWithFormat:@"订单号:%@",_unique_ordernum];
    }else {
        return [NSString stringWithFormat:@"订单号:后台操作"];
    }
}

- (NSString *)ordernum {
    
    if (_ordernum.length) {
        
        return [NSString stringWithFormat:@"订单号:%@",_ordernum];
    }else {
        return [NSString stringWithFormat:@"订单号:后台操作"];
    }
}

- (NSString *)price {
    
    return [NSString stringWithFormat:@"单价(元):%@",_price];
}

- (NSString *)cost {
    
    return [NSString stringWithFormat:@"实付金额(元):%@",_cost];
}

- (NSString *)buytime {
    
    return [NSString stringWithFormat:@"购买时间:%@",_buytime];
}

- (NSString *)expireCalculate {
    
    if (!_expiretime.length || [_expiretime isKindOfClass:[NSNull class]]) {
        
        return [NSString stringWithFormat:@"剩余次数:%@次",_lastime];
    }else {
        
        return [NSString stringWithFormat:@"到期时间:%@",_expiretime];
    }
}


@end
