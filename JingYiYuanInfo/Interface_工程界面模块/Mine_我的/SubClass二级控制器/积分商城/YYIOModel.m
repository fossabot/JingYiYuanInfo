//
//  YYIOModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYIOModel.h"
#import <MJExtension/MJExtension.h>
#import "NSCalendar+YYCommentDate.h"

@implementation YYIOModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             
             @"ioId":@"id"
             };
}

// 0 收入 1 商品兑换支出 2 其他支出
- (NSString *)amount {
    if ([_type isEqualToString:@"0"]) {
        
        return [NSString stringWithFormat:@"+%@",_amount];
    }else {
        return [NSString stringWithFormat:@"-%@",_amount];
    }
}


- (NSString *)goodimg {
    
    if ([_goodimg containsString:@"http"]) {
        return _goodimg;
    }
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_goodimg];
}

- (NSString *)addtime {
    return [NSCalendar commentDateByOriginalDate:_addtime withDateFormat:yyyyMMddHHmmss];
}

@end
