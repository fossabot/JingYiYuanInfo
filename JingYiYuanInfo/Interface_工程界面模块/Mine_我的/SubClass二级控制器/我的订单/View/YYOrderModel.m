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

- (NSString *)ordernum {
    
    return [NSString stringWithFormat:@"订单号:%@",_ordernum];
}

- (NSString *)price {
    
    return [NSString stringWithFormat:@"单价:%@",_price];
}

- (NSString *)cost {
    
    return [NSString stringWithFormat:@"实付金额:%@",_cost];
}

- (NSString *)buytime {
    
    return [NSString stringWithFormat:@"购买时间:%@",_buytime];
}

- (NSString *)expireCalculate {
    
    if (!_expiretime.length || [_expiretime isKindOfClass:[NSNull class]]) {
        
        return [NSString stringWithFormat:@"剩余次数:%@/%@",_lastime,_alltimes];
    }else {
        
        return [NSString stringWithFormat:@"到期时间:%@",_expiretime];
    }
    
}


@end
