//
//  YYGoodsModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/26.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYGoodsModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"goodsId":@"id"
             };
}

- (NSString *)webUrl {
    
    return [NSString stringWithFormat:@"%@%@",goodsJointUrl,_goodsId];
}

@end
